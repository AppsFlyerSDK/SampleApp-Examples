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

public class TrackAndAnonymize extends AppCompatActivity {

    TextView tv1;
    TextView tv2;
    Context context;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initUI(this);

        if (!SharedPrefsUtil.getInstance().getBooleanFromSharedPreferences(getApplicationContext(),SharedPrefsUtil.TRACKING_ANONYMIZED, false)) {

            /** Make use of the AppsFlyerTrackingRequestListener interface - onTrackingRequestSuccess will be invoked on first successful server response.
             *  Get response from server and anonymize any subsequent event or session.
             *  Calling for setDeviceTrackingDisabled(true) right after startTracking will most likely resolve in a race-condition and attribution to Organic
             **/

            AppsFlyerLib.getInstance().startTracking(getApplication(), DEVKEY, new AppsFlyerTrackingRequestListener() {
                @Override
                public void onTrackingRequestSuccess() {
                    Log.d(LOGTAG,"Request to server successfully sent");

                    // setDeviceTrackingDisabled(true); will anonymize all attribution data to Organic
                    AppsFlyerLib.getInstance().setDeviceTrackingDisabled(true);

                    // Update UI and SharedPrefs (App Logic)
                    SharedPrefsUtil.getInstance().saveBooleanToSharedPreferences(getApplicationContext(), SharedPrefsUtil.TRACKING_ANONYMIZED, true);
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
                tv2.setText(String.valueOf(SharedPrefsUtil.getInstance().getBooleanFromSharedPreferences(getApplicationContext(), SharedPrefsUtil.TRACKING_ANONYMIZED, false)));
            }
        });
    }

    private void initUI(Context ctx) {
        setContentView(R.layout.activity_tracknanon);
        tv1 = (TextView)findViewById(R.id.atReq);
        tv2 = (TextView)findViewById(R.id.aAnon);
        context = ctx;
        updateUI();
    }
}
