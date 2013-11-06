c = require('config');
console.log(c.monitoring.newrelic.licenseKey);
exports.config = {
  app_name : ['hoopla-io-api'],
  license_key : "21b526b901469a2767eb002d3e70cb36bb695ba0",
  logging : {
    /**
     * Level at which to log. 'trace' is most useful to New Relic when diagnosing
     * issues with the agent, 'info' and higher will impose the least overhead on
     * production applications.
     */
    level : 'info'
  }
};
