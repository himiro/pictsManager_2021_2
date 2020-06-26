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
  return res.status(200).send(files);
})

router.post('/', uploadMiddleware, async (req, res) => {
  return res.status(200).send(req.file);
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
    return res.sendFile(filePath);
  } catch (err) {
    console.error(`Error deleting file ${req.params.name}`, err);
    return rs.status(500).send({ message: `Error deleting file ${req.params.name}`});
  }
})

export default router;
export { createDirectory };
