import Nano from 'nano';
import config from '../config/index.js';
console.log('config', config)
let database = {};

const initDatabase = async () => {
  const nano = Nano(`http://${config.dbUser}:${config.dbPassword}@${config.dbHost}:5984`);
  database = nano.use('picts-manager');

  try {
    await database.info();
    console.log('Database ready');
  } catch (err) {
    throw new Error(`Error connecting to database: ${err}`)
  }
}

const insert = (req) => (database.insert(req));

const get = (req, options) => (database.get(req, { include_docs: true, ...options }));

const list = async (req) => {
  const { rows } = await database.list({ include_docs: true, ...req });
  return rows.map(r => r.doc);
};

const find = async (req, options) => {
  const { docs } = await database.find({ selector: req }, { include_docs: true, ...options });
  return docs;
};

const destroy = (req) => (database.destroy(req._id, req._rev));

export default {
  initDatabase,
  insert,
  get,
  list,
  find,
  destroy,
};
