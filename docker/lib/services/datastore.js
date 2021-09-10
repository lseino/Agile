const fs = require('fs');
const path = require('path');

function getStore() {
  return JSON.parse(fs.readFileSync(path.join(__dirname, '../../data/patients.json')).toString());
}

function saveStore(patients) {
  return fs.writeFileSync(path.join(__dirname, '../../data/patients.json'), JSON.stringify(patients, null, 2));
}

function get(id) {
  return getStore().find((p) => p.id === id);
}

function del(id) {
  const patients = getStore();

  saveStore(patients.filter((p) => p.id !== id));
}

module.exports = { get, delete: del };
