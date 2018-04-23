package appsflyer.com.inviteshare;

import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.util.Log;

import com.appsflyer.share.ShareInviteHelper;

// see http://stackoverflow.com/questions/39406073/broadcastreceiver-is-not-called-after-createchoosercontext-intent-intentsender
public class ShareBroadcastReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        Log.d("INFORMATION", "Received intent after selection: "+intent.getExtras().get(Intent.EXTRA_CHOSEN_COMPONENT));
        ComponentName componentName = (ComponentName) intent.getExtras().get(Intent.EXTRA_CHOSEN_COMPONENT);

        String channel = null;
        if (componentName != null && componentName.getPackageName() != null){
            final PackageManager pm = context.getApplicationContext().getPackageManager();
            ApplicationInfo appInfo;
            try {
                appInfo = pm.getApplicationInfo( componentName.getPackageName(), 0);
                if (appInfo != null) {
                    channel = (String) pm.getApplicationLabel(appInfo);
                }
            } catch (final PackageManager.NameNotFoundException e) {
                // do nothing
            }
        }
        ShareInviteHelper.trackInvite(context, channel, null);
    }
}