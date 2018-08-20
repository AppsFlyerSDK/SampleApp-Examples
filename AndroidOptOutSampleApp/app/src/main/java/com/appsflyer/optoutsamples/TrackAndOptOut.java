package com.appsflyer.optoutsamples;


import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.widget.TextView;

import com.appsflyer.AppsFlyerLib;
import com.appsflyer.AppsFlyerTrackingRequestListener;

import static com.appsflyer.optoutsamples.MainApplication.DEVKEY;
import static com.appsflyer.optoutsamples.MainApplication.LOGTAG;


public class TrackAndOptOut extends AppCompatActivity {

    TextView tv1;
    TextView tv2;
    Context context;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initUI(this);

        if (SharedPrefsUtil.getInstance().getBooleanFromSharedPreferences(getApplicationContext(),SharedPrefsUtil.ENABLE_TRACKING_FOROPT, true)) {

            /** Make use of the AppsFlyerTrackingRequestListener interface - onTrackingRequestSuccess will be invoked on first successful server response.
             *  Get response from server and disable any subsequent event or session.
             *  Calling for stopTracking(true, context) right after startTracking will most likely resolve in a race-condition and complete opt-out of all tracking
             **/

            AppsFlyerLib.getInstance().startTracking(getApplication(), DEVKEY, new AppsFlyerTrackingRequestListener() {
                @Override
                public void onTrackingRequestSuccess() {
                    Log.d(LOGTAG,"Request to server successfully sent");

                    // Stop all Tracking with the AppsFlyer SDK once a 200 OK response is received for the initial attribution call.
                    AppsFlyerLib.getInstance().stopTracking(true, getApplicationContext());

                    // Update UI and SharedPrefs (App Logic)
                    SharedPrefsUtil.getInstance().saveBooleanToSharedPreferences(getApplicationContext(), SharedPrefsUtil.ENABLE_TRACKING_FOROPT, false);
                    SharedPrefsUtil.getInstance().saveBooleanToSharedPreferences(getApplicationContext(), SharedPrefsUtil.WAS_TRACKING_INITIALIZED, true);
                    updateUI();
                }

                @Override
                public void onTrackingRequestFailure(String s) {
                    Log.d(LOGTAG,"Error sending request to server: "+s);
                }
            });
        }
    }

    public void updateUI() {
        ((Activity) context).runOnUiThread(new Runnable() {
            @Override
            public void run() {
                tv1.setText(String.valueOf(SharedPrefsUtil.getInstance().getBooleanFromSharedPreferences(getApplicationContext(), SharedPrefsUtil.WAS_TRACKING_INITIALIZED, false)));

                // Use AppsFlyerLib.getInstance().isTrackingStopped() to get the current opt-out state
                tv2.setText(String.valueOf(AppsFlyerLib.getInstance().isTrackingStopped()));
            }
        });
    }

    private void initUI(Context ctx) {
        setContentView(R.layout.activity_tracknopt);
        tv1 = (TextView)findViewById(R.id.tReq);
        tv2 = (TextView)findViewById(R.id.optedOut);
        context = ctx;
        updateUI();
    }
}
