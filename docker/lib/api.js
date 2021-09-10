const debug = require('debug')('@agilemd/pp:api');
const express = require('express');
const morgan = require('morgan');

// [ZL] Implement authenticate and authorize middleware below and use them in the correct places
const authenticate = require('./middleware/authenticate');
const authorize = require('./middleware/authorize');
const deletePatient = require('./controllers/patients/delete');
const getPatient = require('./controllers/patients/get');

const api = express();

api.use(morgan('dev'));
api.get('/patients/:patientId', getPatient);
api.delete('/patients/:patientId', deletePatient);

// eslint-disable-next-line no-unused-vars
api.use((err, req, res, next) => {
  debug('error', err);
  const statusCode = err.isBoom ? err.output.statusCode : 500;

  return res.status(statusCode)
    .send(JSON.stringify(err.isBoom ? err.output : { message: err.message }, null, 2));
});

module.exports = api;
