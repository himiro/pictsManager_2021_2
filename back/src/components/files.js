import express from 'express';
import multer from 'multer';
import path, { dirname } from 'path';
import { fileURLToPath } from 'url';
import fs from 'fs';

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
  let files = fs.readdirSync(path.join(uploadsDir, res.locals.user.email))
  if(files.includes('shared')) files.splice(files.indexOf('shared'), 1);
  return res.status(200).send(files);
})

router.post('/', uploadMiddleware, async (req, res) => {
  return res.status(200).send(req.file);
})

router.get('/share', async (req, res) => {
  const sharedFolder = `${uploadsDir}/${res.locals.user.email}/shared`;
  if (!fs.existsSync(sharedFolder)) {
    return res.status(200).send([]);
  }
  let files = fs.readdirSync(path.join(sharedFolder))
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
    if(!fs.existsSync(emailPath)) {
      fs.mkdir(emailPath, () => console.log(`Created directory ${emailPath}`));
    }
    fs.createReadStream(imgPath).pipe(fs.createWriteStream(emailPath + "/" + img));
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
    console.log(filePath)
    await fs.unlink(filePath, () => console.log(`Deleted ${filePath}`));
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

router.delete('/:name', async (req, res) => {
  try {
    const filePath = `${uploadsDir}/${res.locals.user.email}/${req.params.name}`;
    if (!fs.existsSync(filePath)) {
      return res.status(404).send({ message: 'File not found' });
    }
    await fs.unlink(filePath);
    return res.status(200).send({message: "Successfully deleted file"})
  } catch (err) {
    console.error(`Error deleting file ${req.params.name}`, err);
    return res.status(500).send({ message: `Error deleting file ${req.params.name}`});
  }
})

export default router;
export { createDirectory };
