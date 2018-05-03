import { Component } from '@angular/core';
import { Platform } from 'ionic-angular';
import { StatusBar } from '@ionic-native/status-bar';
import { SplashScreen } from '@ionic-native/splash-screen';
declare var window;
import { HomePage } from '../pages/home/home';
@Component({
  templateUrl: 'app.html'
})
export class MyApp {
  rootPage:any = HomePage;

  constructor(platform: Platform, statusBar: StatusBar, splashScreen: SplashScreen) {
    platform.ready().then(() => {



      // Get Conversion Data and deep link data from the onSuccess callback
      function onSuccess(result) {
               alert(result);
          }

          function onError(err) {
              alert(err);
          }

          var options = {
                 devKey:  '<AF_DEV_KEY>',
                 isDebug: true,
                 onInstallConversionDataListener : true,
                 appId : '123488888'
               };

               if (platform.is('ios')) {
                   options.appId = "123456789";
               }

               // init the AppsFlyer SDK to track installs, sessions and in app events
              window.plugins.appsFlyer.initSdk(options , onSuccess , onError);

              var eventName = "af_purchase";
              var eventValues = {
                         "af_content_id": "id123",
                         "af_currency":"USD",
                         "af_revenue": "2"
                         };

              window.plugins.appsFlyer.trackEvent(eventName, eventValues);


      statusBar.styleDefault();
      splashScreen.hide();
    });
  }
}
