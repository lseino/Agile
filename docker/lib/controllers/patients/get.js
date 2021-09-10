const boom = require('boom');

const { get: getFromStore } = require('../../services/datastore');

function get(req, res) {
  const { params } = req;
  const { patientId } = params;

  const patient = getFromStore(patientId);

  if (!patient) {
    throw boom.notFound('no patient for id');
  }

  return res.json(patient);
}

module.exports = get;
