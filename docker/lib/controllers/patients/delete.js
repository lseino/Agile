const boom = require('boom');

const { get: getFromStore, delete: deleteFromStore } = require('../../services/datastore');

function deleteMethod(req, res) {
  const { params } = req;
  const { patientId } = params;

  const patient = getFromStore(patientId);

  if (!patient) {
    throw boom.notFound('no patient for id');
  }

  deleteFromStore(patientId);

  return res.json(null);
}

module.exports = deleteMethod;
