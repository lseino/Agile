const CONFIGURATION = Object.freeze({
  PORT: 8080,
});

module.exports = (name) => CONFIGURATION[name.toUpperCase()];
