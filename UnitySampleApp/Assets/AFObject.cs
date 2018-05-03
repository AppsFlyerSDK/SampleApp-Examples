using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AFObject : MonoBehaviour {
    
    bool tokenSent = false;

    void Start()
    {

        // register to push notifications
        //UnityEngine.iOS.NotificationServices.RegisterForNotifications(UnityEngine.iOS.NotificationType.Alert | UnityEngine.iOS.NotificationType.Badge | UnityEngine.iOS.NotificationType.Sound);
        //Screen.orientation = ScreenOrientation.Portrait;


        /* Mandatory - set your AppsFlyer’s Developer key. */
        AppsFlyer.setAppsFlyerKey("<AF_DEV_KEY>");

        /* For detailed logging */
         AppsFlyer.setIsDebug (true); 

#if UNITY_IOS

        AppsFlyer.setAppID("123456789");
        AppsFlyer.getConversionData();

        AppsFlyer.trackAppLaunch();

#elif UNITY_ANDROID

   /* Mandatory - set your Android package name */

   AppsFlyer.setAppID ("com.appsflyer.unitysampleapp");

   /* For getting the conversion data in Android, you need to add the "AppsFlyerTrackerCallbacks" listener.*/

        AppsFlyer.init ("AF_DEY_KEY","AppsFlyerTrackerCallbacks");

#endif

    }


    void Update()
    {
        /* iOS uninstall tracking */
        #if UNITY_IOS
        if (!tokenSent)
        { 
            byte[] token = UnityEngine.iOS.NotificationServices.deviceToken;
            if (token != null)
            {
                AppsFlyer.registerUninstall(token);
                tokenSent = true;
            }
        }
        #endif
    }

    public void sendAFEvent() {

        /* Send events */
        System.Collections.Generic.Dictionary<string, string> purchaseEvent = new System.Collections.Generic.Dictionary<string, string>();
        purchaseEvent.Add("af_currency", "USD");
        purchaseEvent.Add("af_revenue", "0.99");
        purchaseEvent.Add("af_quantity", "1");
        AppsFlyer.trackRichEvent("af_purchase", purchaseEvent);



    }

}
