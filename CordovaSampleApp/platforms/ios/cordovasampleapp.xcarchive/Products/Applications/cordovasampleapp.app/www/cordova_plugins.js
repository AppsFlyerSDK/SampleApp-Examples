cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
  {
    "id": "cordova-plugin-appsflyer-sdk.appsflyer",
    "file": "plugins/cordova-plugin-appsflyer-sdk/www/appsflyer.js",
    "pluginId": "cordova-plugin-appsflyer-sdk",
    "clobbers": [
      "window.plugins.appsFlyer"
    ]
  },
  {
    "id": "cordova-plugin-appsflyer-sdk.AppsFlyerError",
    "file": "plugins/cordova-plugin-appsflyer-sdk/www/AppsFlyerError.js",
    "pluginId": "cordova-plugin-appsflyer-sdk",
    "clobbers": [
      "AppsFlyerError"
    ]
  }
];
module.exports.metadata = 
// TOP OF METADATA
{
  "cordova-plugin-whitelist": "1.3.3",
  "cordova-plugin-appsflyer-sdk": "4.4.0"
};
// BOTTOM OF METADATA
});