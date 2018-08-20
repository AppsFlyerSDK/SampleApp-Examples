package com.appsflyer.optoutsamples;

import android.content.Context;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.ToggleButton;

import com.appsflyer.AppsFlyerLib;

import static com.appsflyer.optoutsamples.MainApplication.DEVKEY;

public class OptInActivity extends AppCompatActivity {

    /**
     * An example of an asynchronous opt-in activity
     * Use case: User is prompted for terms of condition / a CDN reply is expected in order to determine if the user should be tracked
     * This example uses a toggle button to allow/disallow tracking
     */

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_optin);

        ToggleButton toggle = (ToggleButton) findViewById(R.id.togg_btn);
        toggle.setOnClickListener(toggleListener);
        toggle.setTextOff("Disabled");
        toggle.setTextOn("Enabled");

        boolean isTrackingEnabled = SharedPrefsUtil.getInstance().getBooleanFromSharedPreferences(getApplicationContext(), SharedPrefsUtil.ENABLE_TRACKING, false);

        toggle.setChecked(isTrackingEnabled);

        // handleTracking for current session (if enabled, condition is in invoked method).
        handleTracking(isTrackingEnabled);
    }

    private void handleTracking(boolean isTrackingEnabled) {
        if (isTrackingEnabled) {
            // Call for start tracking only if tracking is enabled.
            AppsFlyerLib.getInstance().startTracking(getApplication());
            // Set WAS_TRACKING_INITIALIZED to SharedPreferences for future launches and stopTracking(...) logic.
            SharedPrefsUtil.getInstance().saveBooleanToSharedPreferences(getApplicationContext(),SharedPrefsUtil.WAS_TRACKING_INITIALIZED, true);
        }
    }

    View.OnClickListener toggleListener = new View.OnClickListener() {
        @Override
        public void onClick(View view) {
            Context appContext = getApplicationContext();
            boolean isOn = ((ToggleButton) view).isChecked();
            if (isOn) {

                // Set the boolean property in the SharedPreferences for future launches and background-foreground transitions.
                SharedPrefsUtil.getInstance().saveBooleanToSharedPreferences(getApplicationContext(), SharedPrefsUtil.ENABLE_TRACKING, true);

                // If stopTracking(...) was invoked - switch to off.
                AppsFlyerLib.getInstance().stopTracking(false, appContext);

                // Track a session immediately once tracking is initialized for the fist time.
                AppsFlyerLib.getInstance().trackAppLaunch(appContext, DEVKEY);

                // handleTracking(true) for the next sessions.
                handleTracking(true);

            } else {

                //IMPORTANT! Call for stopTracking(true) only if the the call for startTracking(...) was previously made
                //IMPORTANT! Calling for stopTracking(true) prior to calling to startTracking(...) will result in attribution issues.

                if (SharedPrefsUtil.getInstance().getBooleanFromSharedPreferences(appContext, SharedPrefsUtil.WAS_TRACKING_INITIALIZED, false)) {
                    AppsFlyerLib.getInstance().stopTracking(true, getApplicationContext());
                }
                // Set SharedPreferences value for future launches.
                SharedPrefsUtil.getInstance().saveBooleanToSharedPreferences(appContext, SharedPrefsUtil.ENABLE_TRACKING, false);
            }
        }
    };
}