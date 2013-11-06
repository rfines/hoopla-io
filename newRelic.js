/**
 * New Relic agent configuration.
 *
 * See lib/config.defaults.js in the agent distribution for a more complete
 * description of configuration variables and their potential values.
 */
exports.config = {
  c = require('config');
  /**
   * Array of application names.
   */
  app_name : ['hoopla-io-api'],
  /**
   * Your New Relic license key.
   */
  license_key : c.monitoring.newrelic.licenseKey,
  logging : {
    /**
     * Level at which to log. 'trace' is most useful to New Relic when diagnosing
     * issues with the agent, 'info' and higher will impose the least overhead on
     * production applications.
     */
    level : 'info'
  }
};
