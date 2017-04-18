package appsflyer.com.inviteshare;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.LabeledIntent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.app.FragmentManager;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Toast;

import com.appsflyer.AppsFlyerConversionListener;
import com.appsflyer.AppsFlyerLib;
import com.appsflyer.share.CrossPromotionHelper;
import com.appsflyer.share.LinkGenerator;
import com.appsflyer.share.ShareInviteHelper;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static android.R.id.message;

// adb shell am start -a android.intent.action.VIEW -d https://app.appsflyer.com/appsflyer.com.inviteshare?pid=af_invite\&af_channel=Twitter\&af_referral_name=Shachar\&af_referral_avatar_url=URLTEST\&advertising_id=889f905f-58e6-4336-ac6a-68c5b83dd7f0

public class MainActivity extends AppCompatActivity implements View.OnClickListener {

    private static final String TAG = "MainActivity";

    private static final String GMAIL_CHANNEL = "gmail";
    private static final String FACEBOOK_CHANNEL = "facebook";
    private static final String WHATSAPP_CHANNEL = "whatsapp";
    private static final String GMAIL_PACKAGE_NAME = "com.google.android.gm";
    private static final String FACEBOOK_PACKAGE_NAME = "com.facebook.katana";
    private static final String WHATSAPP_PACKAGE_NAME = "com.whatsapp";

    private static final String AF_REFERRAL_NAME = "af_referral_name";
    private static final String AF_REFERRAL_AVATAR_URL = "af_referral_avatar_url";

    private static final String ONE_LINK_ID = "2310578617";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        AppsFlyerLib.getInstance().setAppInviteOneLink(ONE_LINK_ID);
        AppsFlyerLib.getInstance().startTracking(this.getApplication(), "udqj9oVC22BQdWPoQQWMsN");
        registerConversionListener();

        findViewById(R.id.gmail_invite).setOnClickListener(this);
        findViewById(R.id.facebook_invite).setOnClickListener(this);
        findViewById(R.id.whatsapp_invite).setOnClickListener(this);

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        CrossPromotionHelper.trackCrossPromoteImpression(this, "com.mygosoftware.android.loginbox", null);

        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(this);

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == 10) {
            if (resultCode == Activity.RESULT_OK) {
//                String result=data.getStringExtra("result");
                Log.d(TAG, "onActivityResult: " + data.toString());
            }
            /*if (resultCode == Activity.RESULT_CANCELED) {
                //Write your code if there's no result
            }*/
        }
    }//onActivityResul

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    public void onDownloadLoginBox(View button) {
        CrossPromotionHelper.trackAndOpenStore(this, "com.mygosoftware.android.loginbox", null);
    }

    public void onDownloadAdNetTest(View button) {
        CrossPromotionHelper.trackAndOpenStore(this, "com.appsflyer.adNetworkTest", null);
    }

    private void registerConversionListener() {
        AppsFlyerLib.getInstance().registerConversionListener(this, new AppsFlyerConversionListener() {
            @Override
            public void onInstallConversionDataLoaded(final Map<String, String> conversionData) {
                for (String attrName : conversionData.keySet()) {
                    Log.d(TAG, "attribute: " + attrName + " = " +
                            conversionData.get(attrName));
                }

//                conversionData.put(AF_REFERRAL_NAME, "Shachar Aharon");
//                conversionData.put(AF_REFERRAL_AVATAR_URL, "https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mm&f=y");
//                conversionData.put(AF_REFERRAL_AVATAR_URL, "https://fb-s-a-a.akamaihd.net/h-ak-xtf1/v/t1.0-9/10254039_158292347891770_5463903483238234152_n.jpg?oh=f331313c8fde39c39043b43b7044ce58&oe=593EC841&__gda__=1500513177_47981dab03482f944a9818ec88158a56");

                if (conversionData.containsKey(AF_REFERRAL_NAME) && conversionData.containsKey(AF_REFERRAL_AVATAR_URL)) {
                    runOnUiThread(new Runnable() {
                        public void run() {
                            String userName = conversionData.get(AF_REFERRAL_NAME);
                            String avatarUrl = conversionData.get(AF_REFERRAL_AVATAR_URL);
//                            showReferralDialog(getApplicationContext(),userName,avatarUrl);
                            showReferralDialog(userName, avatarUrl);
//                            Intent intent = new Intent(getApplicationContext(), AlertDialog.class);
//                            intent.putExtra(AF_REFERRAL_NAME, userName);
//                            intent.putExtra(AF_REFERRAL_AVATAR_URL, avatarUrl);
//                            startActivity(intent);
                        }
                    });
                }
            }

            @Override
            public void onInstallConversionFailure(String errorMessage) {
                Log.d(TAG, "Error getting conversion data: " + errorMessage);
            }

            @Override
            public void onAppOpenAttribution(Map<String, String> conversionData) {
                Log.d(TAG, "DEEP LINK WORKING");
            }

            @Override
            public void onAttributionFailure(String errorMessage) {
                Log.d(TAG, "Attribution error: " + errorMessage);
            }
        });
    }

    private void shareToApp(Context context, String channel, String packageName, String link) {
        Intent intent = context.getPackageManager().getLaunchIntentForPackage(packageName);
        if (intent != null) {
            // The application exists
            Intent shareIntent = new Intent();
            shareIntent.setAction(Intent.ACTION_SEND);
            shareIntent.setPackage(packageName);
            shareIntent.setType("text/plain");

            shareIntent.putExtra(android.content.Intent.EXTRA_TITLE, "Share to: " + packageName);
            shareIntent.putExtra(Intent.EXTRA_TEXT, "Please install this app: " + link);
            // Start the specific social application
            context.startActivity(shareIntent);
            ShareInviteHelper.trackInvite(getApplicationContext(), channel, null);
        } else {
            // The application does not exist
            // Open GooglePlay or use the default system picker
            Toast.makeText(context, "App " + packageName + " doesn't exist.", Toast.LENGTH_SHORT).show();
        }
    }

    private void showReferralDialog(String userName, String avatarUrl) {
        FragmentManager manager = getSupportFragmentManager();
        ReferralDialog referralDialog = ReferralDialog.create(userName, avatarUrl);
        referralDialog.show(manager, "fragment_edit_name");
    }

    @Override
    public void onClick(View v) {
        LinkGenerator linkGenerator = ShareInviteHelper.generateInviteUrl(MainActivity.this);
        switch (v.getId()) {
            case R.id.gmail_invite:
                String urlStringGmail = linkGenerator.setChannel(GMAIL_CHANNEL).generateLink();
                shareToApp(v.getContext(), GMAIL_CHANNEL, GMAIL_PACKAGE_NAME, urlStringGmail);
                break;
            case R.id.facebook_invite:
                String urlStringFacebook = linkGenerator.setChannel(FACEBOOK_CHANNEL).generateLink();
                shareToApp(v.getContext(), FACEBOOK_CHANNEL, FACEBOOK_PACKAGE_NAME, urlStringFacebook);
                break;
            case R.id.whatsapp_invite:
                String urlStringWhatsapp = linkGenerator.setChannel(WHATSAPP_CHANNEL).generateLink();
                shareToApp(v.getContext(), WHATSAPP_CHANNEL, WHATSAPP_PACKAGE_NAME, urlStringWhatsapp);
                break;
            case R.id.fab:
                shareNativeApps();
                break;
            default:
                break;
        }
    }

    private void shareNativeApps() {
        // Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
        //         .setAction("Action", null).show();


//                String shareBody = "Please install this app: "+ ShareInviteHelper.createInviteLink(MainActivity.this).generateLink();
//                Intent sendIntent = new Intent(android.content.Intent.ACTION_SEND);
//                sendIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//                sendIntent.setType("text/plain");
//                sendIntent.putExtra(android.content.Intent.EXTRA_SUBJECT, "Recommended app");
//                sendIntent.putExtra(android.content.Intent.EXTRA_TEXT, shareBody);
//
//                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP_MR1) {
//                    Log.d("INFORMATION", "The current android version allow us to know what app is chosen by the user.");
//
//                    Intent receiverIntent =
//                            new Intent(MainActivity.this,ShareBroadcastReceiver.class);
//                    PendingIntent pendingIntent = PendingIntent.getBroadcast(MainActivity.this, 0, receiverIntent, PendingIntent.FLAG_CANCEL_CURRENT);
//                    sendIntent = Intent.createChooser(sendIntent,"Share via...", pendingIntent.getIntentSender());
//                }
//                startActivity(sendIntent);SEND_MSG_REQUEST = 10;

        //Create primary intent to be used for chooser intent
        Intent smsIntent = new Intent();
        smsIntent.setAction(Intent.ACTION_SEND);
        smsIntent.setType("text/plain");
        //need to limit the scope of this intent to SMS app only. If we don't set the
        //package here, it will target apps like bluetooth, clipboard etc also.
        smsIntent.setPackage("com.android.mms");
        smsIntent.putExtra("sms_body", message);

        //intent for adding other apps
        Intent queryIntent = new Intent(Intent.ACTION_SEND);
        queryIntent.setType("text/plain");

        PackageManager pm = getPackageManager();
        List<ResolveInfo> resolveInfos = pm.queryIntentActivities(queryIntent, 0);

        List<LabeledIntent> otherAppIntentList = new ArrayList<>();
        //filter out all the other intents which we want to keep
        for (int i = 0; i < resolveInfos.size(); i++) {
            ResolveInfo appInfo = resolveInfos.get(i);
            String packageName = appInfo.activityInfo.packageName;
            Intent intentToAdd = new Intent();
            //     if (packageName.contains("com.whatsapp")) {
            //this is the intent we are interested in
            intentToAdd.setComponent(new ComponentName(packageName, appInfo.activityInfo.name));
            intentToAdd.setAction(Intent.ACTION_SEND);
            intentToAdd.setType("text/plain");
            intentToAdd.setPackage(packageName);
            String channel = null;
            try {
                channel = pm.getApplicationLabel(pm.getApplicationInfo(packageName, 0)).toString();
            } catch (PackageManager.NameNotFoundException e) {
                // do nothing
            }
            String url = ShareInviteHelper.generateInviteUrl(MainActivity.this).setChannel(channel).generateLink();
            String shareBody;
            if (appInfo.activityInfo.name.startsWith("com.facebook.katana")) {
                shareBody = url;
            } else {
                shareBody = "Please install this app: " + url;
            }
//
            intentToAdd.putExtra(Intent.EXTRA_TEXT, shareBody);
            intentToAdd.putExtra(Intent.EXTRA_SUBJECT, "Recommended app");

            //add this intent to the list
            otherAppIntentList.add(new LabeledIntent(intentToAdd, packageName,
                    appInfo.loadLabel(pm), appInfo.icon));
            //   }
        }

        // convert intentList to array
        LabeledIntent[] extraIntents = otherAppIntentList.toArray(
                new LabeledIntent[otherAppIntentList.size()]);

        //create and add all the intents to chooser
        Intent chooserIntent = Intent.createChooser(smsIntent, "Share With");

        //add all the extra intents that we have created
        chooserIntent.putExtra(Intent.EXTRA_INITIAL_INTENTS, extraIntents);
        startActivityForResult(chooserIntent, 10);
    }
}
