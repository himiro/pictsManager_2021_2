import express from 'express';
import morgan from 'morgan';

import config from './config/index.js';
import router from './components/index.js'

const server = express();
server.use(morgan('tiny'));
server.use(router);

const port = config.port;
server.listen(config.port);
console.log(`Server listening on ${port}`);
