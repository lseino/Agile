const debug = require('debug')('@agilemd/pp');
const http = require('http');

const api = require('./lib/api');
const config = require('./lib/config');

const server = http.createServer(api);

process.on('unhandledRejection', (stack) => {
  debug('unhandled promise error', stack);
});

server.listen(config('PORT'));
server.on('error', (err) => {
  debug('server error', err);
});
server.on('listening', () => {
  debug('listening', server.address());
});

module.exports = server;
