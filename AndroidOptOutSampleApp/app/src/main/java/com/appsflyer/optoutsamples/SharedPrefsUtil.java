package com.appsflyer.optoutsamples;

import android.content.Context;
import android.content.SharedPreferences;

public class SharedPrefsUtil {

    /**
     * SharedPreferences Utility, used to save data between app launches
     * Any SharedPreferences logic in the provided examples can be replaced with any other logic that can save data between app launches
     * For opt-out examples see:
     *  1. AsyncOptInActivity - Opting in on User Interaction
     *  2. TrackAndOptOutActivity - Track install and opt-out all subsequent data.
     *  3. TrackAndAnonymize - Track install and anonymize all subsequent data.
     *
     */

    public static final String ENABLE_TRACKING = "enableTracking";
    public static final String ENABLE_TRACKING_FOROPT = "enableTrackingForOpt";
    public static final String WAS_TRACKING_INITIALIZED = "trackingInitialized";
    public static final String TRACKING_ANONYMIZED = "trackingAnonymized";
    private static final String ENABLED_BUTTON = "enButton";

    private static SharedPrefsUtil instance = new SharedPrefsUtil();
    public static SharedPrefsUtil getInstance() {
        return instance;
    }


    public boolean getBooleanFromSharedPreferences(Context context, String key, boolean value) {
        SharedPreferences sharedPreferences = getSharedPreferences(context);
        return sharedPreferences.getBoolean(key,value);
    }

    public void saveBooleanToSharedPreferences(Context context, String key, boolean value) {
        SharedPreferences sharedPreferences = getSharedPreferences(context);
        android.content.SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putBoolean(key, value);
        editorCommit(editor);
    }

    private SharedPreferences getSharedPreferences(Context context) {
        return context.getSharedPreferences("AFSampleAppPrefs", Context.MODE_PRIVATE);
    }

    void editorCommit(SharedPreferences.Editor editor) {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.GINGERBREAD) {
            editor.apply();
        } else {
            editor.commit();
        }
    }

    // Sample app logic - used to disable buttons per use case.

    public void saveButtonToSharedPreferences(Context context, int value) {
        SharedPreferences sharedPreferences = getSharedPreferences(context);
        android.content.SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putInt(ENABLED_BUTTON, value);
        editorCommit(editor);
    }

    public int getButtonFromSharedPreferebces(Context context) {
        SharedPreferences sharedPreferences =  getSharedPreferences(context);
        return sharedPreferences.getInt(ENABLED_BUTTON, -1);
    }

    public void resetSharedPrefs(Context context) {
        SharedPreferences sharedPreferences = getSharedPreferences(context);
        android.content.SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.clear();
        editorCommit(editor);
    }
}
