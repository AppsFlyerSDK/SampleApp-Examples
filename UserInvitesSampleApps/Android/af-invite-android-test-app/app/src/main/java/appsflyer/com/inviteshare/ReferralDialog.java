package appsflyer.com.inviteshare;

import android.app.AlertDialog;
import android.app.Dialog;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.DialogFragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import java.io.InputStream;
import java.net.URL;

/**
 * Created by shacharaharon on 20/02/2017.
 */

public class ReferralDialog extends DialogFragment {
    static final String TAG = "ReferralDialog";
    private String userName;
    private String userAvatarUrlString;

    public static ReferralDialog create(String userName, String userAvatarUrlString) {
        ReferralDialog wd = new ReferralDialog();
        wd.setReferralDetails(userName, userAvatarUrlString);
        return wd;
    }

    private void setReferralDetails(String userName, String userAvatarUrlString) {
        this.userName = userName;
        this.userAvatarUrlString = userAvatarUrlString;
    }

    @NonNull
    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        // Use the Builder class for convenient dialog construction
        LayoutInflater inflater = getActivity().getLayoutInflater();
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        View view = inflater.inflate(R.layout.dialog, null);
        TextView userNameView = (TextView) view.findViewById(R.id.userName);
        final ImageView avatarView = (ImageView) view.findViewById(R.id.userAvatar);
        Log.d(TAG, "onViewCreated: updating username(" + userName + ") and avatar(" + userAvatarUrlString + ")");
        if (userName != null && userAvatarUrlString != null) {
            userNameView.setText(userName);
            new AsyncTask<Object, Object, Bitmap>() {

                @Override
                protected Bitmap doInBackground(Object... params) {
                    try {
//                        InputStream is = new URL(userAvatarUrlString).openStream();
                        return BitmapFactory.decodeStream((InputStream) new URL(userAvatarUrlString).getContent());
                    } catch (Throwable e) {
                        e.printStackTrace();
                    }
                    return null;
                }

                @Override
                protected void onPostExecute(Bitmap bitmap) {
                    super.onPostExecute(bitmap);
                    if (bitmap == null) {
                        Log.d(TAG, "onPostExecute: null bitmap");
                        return;
                    }
                    avatarView.setImageBitmap(bitmap);
                }

            }.execute();
        }
        builder.setView(view);
        // Create the AlertDialog object and return it
        AlertDialog alertDialog = builder.setTitle("Referral Info").create();
        alertDialog.setCanceledOnTouchOutside(true);
        return alertDialog;
    }
}
