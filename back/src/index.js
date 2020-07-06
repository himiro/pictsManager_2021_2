import express from 'express';
import morgan from 'morgan';
import bodyParser from 'body-parser';

import config from './config/index.js';
import db from './services/database.js';
import router from './components/index.js';

const main = async () => {
  try {

    let dbConnected = false;
    while (!dbConnected) {
      await new Promise((resolve, _) => setTimeout(resolve, 1000));
      try {
        await db.initDatabase();
        dbConnected = true;
      } catch (err) {
        console.log('Database not ready, retrying in 1 sec', err)
      }
    }

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
