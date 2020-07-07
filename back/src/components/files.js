import express from 'express';
import multer from 'multer';
import path, { dirname } from 'path';
import { fileURLToPath } from 'url';
import fs from 'fs';
import db from '../services/database.js';

const __dirname = dirname(fileURLToPath(import.meta.url));

const router = express.Router();
const uploadsDir = path.resolve(`${__dirname}/../../uploads`);

const createDirectory = (directory='') => {
  let fullPath = path.join(uploadsDir, directory)
  if (!fs.existsSync(fullPath)) {
    fs.mkdir(fullPath, () => console.log(`Created directory ${directory}`));
  }
}
createDirectory()

const uploadMiddleware = (req, res, next) => {
  console.log(req.file)
  const storage = multer.diskStorage({
      destination: function (req, file, cb) {
        cb(null, path.join(uploadsDir, res.locals.user.email))
      },
      filename: function (req, file, cb) {
        cb(null, Date.now() + '-' + file.originalname)
      }
  })

  multer({ storage }).single('file')(req, res, (err) => {
    if (err instanceof multer.MulterError) {
      console.log('Upload error', err)
      return res.status(500).json(err)
    } else if (err) {
      console.log('Upload error', err)
      return res.status(500).json(err)
    }
    return next();
  })
}

router.get('/', async (req, res) => {
  if (!fs.existsSync(uploadsDir)) {
    return res.status(200).send([]);
  }
  let files = await db.find({ type: 'file', userId: res.locals.user.email });
  if (req.query.search) {
    files = files.filter((f) => (f.tags.indexOf(req.query.search) > -1))
  }
  return res.status(200).send(files.map(f => (`${f.shared ? 'shared/' : ''}${f.name}`)));
})

router.post('/', uploadMiddleware, async (req, res) => {
  await db.insert({
    type: 'file',
    name: req.file.filename,
    tags: [],
    createdAt: new Date(),
    userId: res.locals.user.email,
    shared: false,
  })
  return res.status(200).send(req.file);
})

router.get('/share', async (req, res) => {
  const folder = `${uploadsDir}/${res.locals.user.email}/shared`;
  if (!fs.existsSync(folder)) {
    return res.status(200).send([]);
  }
  let files = fs.readdirSync(path.join(folder))
  return res.status(200).send(files);
})

router.get('/share/:name', async(req, res) => {
  const filePath = `${uploadsDir}/${res.locals.user.email}/shared/${req.params.name}`;
  if (!fs.existsSync(filePath)) {
    return res.status(404).send({ message: 'File not found' });
  }
  res.header('Content-Type', 'image/png')
  return res.sendFile(filePath);
})

router.post('/share', async (req, res) => {
  try{
    if (!req.body.img_name || typeof(req.body.img_name) !== 'string' || req.body.img_name.length <= 0) {
      return res.status(400).send({ message: 'Missing image name' });
    }
    if (!req.body.email || typeof(req.body.email) !== 'string' || req.body.email.length <= 0) {
      return res.status(400).send({ message: 'Missing email of the receiver' });
    }
    const img = req.body.img_name
    const email = req.body.email;
    const imgPath = `${uploadsDir}/${res.locals.user.email}/${req.body.img_name}`;
    const emailPath = path.resolve(`${uploadsDir}/${email}/shared/`);
    if(!fs.existsSync(imgPath)) {
      return res.status(404).send({ message: 'Image: File not found' });
    }

    const files = await db.find({ type: 'file', userId: res.locals.email, name: req.params.name });
    if (files.length < 1) return res.status(404).send({ message: 'File does not exists' });
    const file = files[0];

    if(!fs.existsSync(emailPath)) {
      fs.mkdir(emailPath, () => console.log(`Created directory ${emailPath}`));
    }
    fs.symlinkSync(imgPath, `${emailPath}/${img}`);
    await db.insert({
      type: 'file',
      name: file.name,
      tags: file.tags,
      createdAt: new Date(),
      userId: req.body.email,
      shared: true,
    })

    return res.status(200).send({message: "Successfully shared file"})
  }catch(err){
    return res.status(500).send({message: err})
  }
})

router.delete('/share/:name', async(req, res) => {
  try {
    const filePath = `${uploadsDir}/${res.locals.user.email}/shared/${req.params.name}`;
    if (!fs.existsSync(filePath)) {
      return res.status(404).send({ message: 'File not found' });
    }
    const files = await db.find({ type: 'file', userId: res.locals.email, name: req.params.name, shared: true });
    if (files.length < 1) return res.status(404).send({ message: 'File does not exists' });
    await db.destroy({ _id: files[0]._id, _rev: files[0]._rev });

    // await fs.unlinkSync(filePath);
    return res.status(200).send({message: "Successfully deleted file"})
  } catch (err) {
    console.error(`Error deleting file ${req.params.name}`, err);
    return res.status(500).send({ message: `Error deleting file ${req.params.name}`});
  }
})

router.get('/:name', async (req, res) => {
  const filePath = `${uploadsDir}/${res.locals.user.email}/${req.params.name}`;
  if (!fs.existsSync(filePath)) {
    return res.status(404).send({ message: 'File not found' });
  }
  res.header('Content-Type', 'image/png')
  return res.sendFile(filePath);
})

router.get('/:name/tags', async (req, res) => {
  const files = await db.find({ type: 'file', userId: res.locals.email, name: req.params.name });
  if (files.length < 1) return res.status(404).send({ message: 'File does not exists' });
  return res.send(files[0].tags)
})

router.post('/:name/tags', async (req, res) => {
  if (typeof(req.body.tags) !== typeof([''])) return res.status(400).send({ message: 'Tags must be an array' });
  const files = await db.find({ type: 'file', userId: res.locals.email, name: req.params.name });
  if (files.length < 1) return res.status(404).send({ message: 'File does not exists' });
  files[0].tags = req.body.tags;
  await db.insert(files[0]);
  return res.send(files[0].tags);
})

router.delete('/:name', async (req, res) => {
  try {
    const filePath = `${uploadsDir}/${res.locals.user.email}/${req.params.name}`;
    if (!fs.existsSync(filePath)) {
      return res.status(404).send({ message: 'File not found' });
    }
    const files = await db.find({ type: 'file', userId: res.locals.email, name: req.params.name, shared: false });
    if (files.length < 1) return res.status(404).send({ message: 'File does not exists' });
    await db.destroy({ _id: files[0]._id, _rev: files[0]._rev });
    await fs.unlinkSync(filePath);
    return res.status(200).send({message: "Successfully deleted file"})
  } catch (err) {
    console.error(`Error deleting file ${req.params.name}`, err);
    return res.status(500).send({ message: `Error deleting file ${req.params.name}`});
  }
})

export default router;
export { createDirectory };
