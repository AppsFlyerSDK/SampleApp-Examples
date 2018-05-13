package com.appsflyer.androidsampleapp;

import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;

import com.appsflyer.*;

import java.util.Map;

  /** Test this deep link with the link : https://androidsampleapp.onelink.me/Pvqj */
  /** run: $ adb shell am start -a android.intent.action.VIEW -d https://androidsampleapp.onelink.me/Pvqj */



public class DeepLink extends AppCompatActivity {


    final Handler handler = new Handler();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_deep_link);


        /* Add this call to the tracker on each deep linked activity */

        AppsFlyerLib.getInstance().sendDeepLinkData(this);


    }


    /* Used to display the deep link data returned from onAppOpenAttribution */

    public void setAttributionText(final String data){

        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                TextView attributionTextView = findViewById(R.id.attributionText);
                attributionTextView.setText(data);
            }
        } , 2500);
    }

}
