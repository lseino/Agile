/* eslint-disable import/no-extraneous-dependencies */
const fs = require('fs');
const path = require('path');
const debug = require('debug')('@agilemd/pp:generate-patients');
const Chance = require('chance');
const crypto = require('crypto');

const chance = new Chance();
const pathToStore = path.join(__dirname, '../data/users.json');

function generateUser() {
  const password = chance.string({ alpha: true, length: 8 });

  return {
    id: chance.string({ alpha: true, length: 6 }),
    password,
    passwordHash: crypto.createHash('sha1').update(password).digest('hex'),
    permissions: [].concat(chance.pick(['GET', 'UPDATE', 'DELETE', 'LIST'], chance.integer({ min: 0, max: 4 }))),
  };
}

function generate(requestedNumber = 50) {
  const users = [];
  let number = requestedNumber;

  if (number > 100) {
    debug('cannot create more than 100 users - limiting to 100');
    number = 100;
  }
  if (number < 1) {
    debug('must create at least one user');
    number = 1;
  }

  for (let i = 0; i < number; i += 1) {
    users.push(generateUser());
  }

  fs.writeFileSync(pathToStore, JSON.stringify(users, null, 2));
}

generate();
