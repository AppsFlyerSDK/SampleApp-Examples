package com.appsflyer.optoutsamples;

import android.app.ActivityManager;
import android.app.Application;
import android.content.Context;
import android.os.Build;
import android.os.StrictMode;
import android.util.Log;
import android.widget.TextView;


import com.appsflyer.AppsFlyerConversionListener;
import com.appsflyer.AppsFlyerLib;

import java.io.File;
import java.util.Map;


public class MainApplication extends Application {

    /**
     * MainApplication Class
     * It is recommended to initialize the tracker and set all "global" setters from the Application class
     * For opt-out examples see:
     *  1. AsyncOptInActivity - Opting in on User Interaction
     *  2. TrackAndOptOutActivity - Track install and opt-out all subsequent data.
     *  3. TrackAndAnnonymize - Track install and anonymize all subsequent data.
     *
     */

    public static MainApplication getInstance() {
        return new MainApplication();
    }

    public static final String LOGTAG = "AppsFlyer_OptOutSample";

    //DevKey is matched per bundle name - replace with own DevKey when implementing the code in your app
    public static final String DEVKEY = "uAX9meXuM6aCsh3Zb4Q9KW";

    public void onCreate() {
        super.onCreate();

        // Enables LogCat debug logs - Important: disable the debug logs prior to building for release
        // AppsFlyerLib.getInstance().setDebugLog(true);

        // The init method prepares the SDK for tracking, but does not send any messages out - so it is safe to use prior to calling to 'stopTracking' in opt-out cases
        // appsFlyerConversionListener is optional, and can be initialized separately for each activity.
        AppsFlyerLib.getInstance().init(DEVKEY,null, getApplicationContext());

        // Disable all tracking prior to prompting user in AsyncOptInActivity
        SharedPrefsUtil.getInstance().saveBooleanToSharedPreferences(getApplicationContext(), SharedPrefsUtil.ENABLE_TRACKING, false);
    }
}