import express from 'express';
import morgan from 'morgan';
import bodyParser from 'body-parser';

import config from './config/index.js';
import db from './services/database.js';
import router from './components/index.js';

const main = async () => {
  try {
    await db.initDatabase();

    const server = express();
    server.use(morgan('tiny'));
    server.use(bodyParser.json());
    server.use(router);

    const port = config.port;
    server.listen(config.port);
    console.log(`Server listening on ${port}`);
  } catch (err) {
    console.error(`Error in main: ${err}`)
  }
}

main();
