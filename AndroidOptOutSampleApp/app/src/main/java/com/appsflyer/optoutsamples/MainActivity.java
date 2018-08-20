package com.appsflyer.optoutsamples;

import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;

import java.io.File;

import static com.appsflyer.optoutsamples.MainApplication.LOGTAG;

public class MainActivity extends AppCompatActivity {

    /**
     * App Logic - no opt-out examples here.
     *
     * For opt-out examples see:
     *  1. AsyncOptInActivity - Opting in on User Interaction
     *  2. TrackAndOptOutActivity - Track install and opt-out all subsequent data.
     *  3. TrackAndAnonymize - Track install and anonymize all subsequent data.
     *
     */

    String btns[] = {"opt_in_async", "track_and_opt_out", "track_and_annonimize"};

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        doDisable();
    }

    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.opt_in_async:
                startActivity(new Intent(this, OptInActivity.class));
                disableOtherButtons(0);
                break;
            case R.id.track_and_opt_out:
                startActivity(new Intent(this, TrackAndOptOut.class));
                disableOtherButtons(1);
                break;
            case R.id.track_and_annonimize:
                startActivity(new Intent(this, TrackAndAnonymize.class));
                disableOtherButtons(2);
                break;
            case R.id.reset_test_state:
                clearApplicationData(getApplicationContext());
                restartApp();
            default:
                break;
        }
    }

    private void disableOtherButtons(int currentButton) {
        SharedPrefsUtil.getInstance().saveButtonToSharedPreferences(getApplicationContext(), currentButton);
        doDisable();
    }

    private void doDisable() {
        int skipit = SharedPrefsUtil.getInstance().getButtonFromSharedPreferebces(getApplicationContext());
        if (skipit != -1) {
            for (int i = 0; i < btns.length; i++) {
                if (skipit != i) {
                    Button cButton = findViewById((getResources().getIdentifier(btns[i], "id", this.getPackageName())));
                    cButton.setEnabled(false);
                }

            }
        }
    }

    private void restartApp() {
        try {
        Intent i = getBaseContext().getPackageManager()
                .getLaunchIntentForPackage( getBaseContext().getPackageName() );
        i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        startActivity(i);
        } catch (NullPointerException ex) {
            Log.d(LOGTAG, "Exception while restarting app: " +ex.toString());
        }
    }

    private void clearApplicationData(Context context) {
        if (Build.VERSION_CODES.KITKAT <= Build.VERSION.SDK_INT) {
            try {
                ((ActivityManager) context.getSystemService(ACTIVITY_SERVICE)).clearApplicationUserData();
            } catch (NullPointerException ex) {
                Log.d(LOGTAG, "Error while clearing app data: " +ex.toString());
            }
        } else {
            File cacheDirectory = context.getCacheDir();
            File applicationDirectory = new File(cacheDirectory.getParent());
            if (applicationDirectory.exists()) {
                String[] fileNames = applicationDirectory.list();
                for (String fileName : fileNames) {
                    if (!fileName.equals("lib")) {
                        deleteFile(new File(applicationDirectory, fileName));
                    }
                }
            }
            SharedPrefsUtil.getInstance().resetSharedPrefs(context);
        }
    }

    private static boolean deleteFile(File file) {
        boolean deletedAll = true;
        if (file != null) {
            if (file.isDirectory()) {
                String[] children = file.list();
                for (String f : children) {
                    deletedAll = deleteFile(new File(file, f)) && deletedAll;
                }
            } else {
                deletedAll = file.delete();
            }
        }

        return deletedAll;
    }
}