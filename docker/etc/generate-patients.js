/* eslint-disable import/no-extraneous-dependencies */
const fs = require('fs');
const path = require('path');
const debug = require('debug')('@agilemd/pp:generate-patients');
const Chance = require('chance');
const moment = require('moment');
const { parseFullName } = require('parse-full-name');

const chance = new Chance();
const pathToStore = path.join(__dirname, '../data/patients.json');
function generatePatient() {
  const gender = chance.gender();
  const name = chance.name({ gender });
  const { first, last, middle } = parseFullName(name);

  return {
    resourceType: 'Patient',
    id: chance.string({ numeric: true, length: 4 }),
    gender: gender.toLowerCase().includes('f') ? 'female' : 'male',
    identifier: [
      {
        use: 'usual',
        system: 'urn:agilemd:fhir:patient:identifier-system:mrn',
        value: chance.string({ length: 8, pool: '0123456789' }),
      },
    ],
    birthDate: moment().subtract(chance.integer({ min: 18, max: 86 }), 'years').format('YYYY-MM-DD'),
    name: [
      {
        use: 'usual',
        text: name,
        family: last,
        given: [first].concat(middle.split(' ')).filter(Boolean),
      },
    ],
  };
}

function generate(requestedNumber = 50) {
  const patients = [];
  let number = requestedNumber;

  if (number > 100) {
    debug('cannot create more than 100 patients - limiting to 100');
    number = 100;
  }
  if (number < 1) {
    debug('must create at least one patient');
    number = 1;
  }

  for (let i = 0; i < number; i += 1) {
    patients.push(generatePatient());
  }

  fs.writeFileSync(pathToStore, JSON.stringify(patients, null, 2));
}

generate();
