package com.example.moreapp;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.util.Log;


public class MoreAppUtil {
    private static final String TAG = "MoreAppUtil";
    Context context;
    BroadcastReceiver broadcastReceiver;
    private boolean isAuto = true;

    public MoreAppUtil(Context context, final OnClickInstall clickInstall) {
        this.context = context;
        broadcastReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                if (intent.getAction().equals("ACTON_CLICK_ABC")) {
                    if (clickInstall != null)
                        clickInstall.onClick(intent.getStringExtra("package"));
                }
            }
        };
        IntentFilter intentFilter = new IntentFilter("ACTON_CLICK_ABC");
        context.registerReceiver(broadcastReceiver, intentFilter);
    }

    public interface OnClickInstall {
        void onClick(String packageName);
    }

    /**
     * @param data [{
     *             "logo":"link",
     *             "packageName":"String"
     *             "body":"body"
     *             "name":"name sdfsdf"
     *             "images":["sldkfjslkf", "sdfsdhfksjdhf", "sdlfhskjdhf"]
     *             }]
     * @throws Exception
     */
    public static void configMoreApp(String data) {
        try {
            MoreAppConfig.setMoreAppConfigs(data);
        } catch (Exception e) {
            Log.e(TAG, "configMoreApp: " + e.toString());
        }
    }

    public void setAutoIntent(boolean isAuto) {
        this.isAuto = isAuto;
    }

    public void show() {
        Intent intent = new Intent(context, MoreAppActivity.class);
        intent.putExtra("is_auto", isAuto);
        context.startActivity(intent);
    }
}
