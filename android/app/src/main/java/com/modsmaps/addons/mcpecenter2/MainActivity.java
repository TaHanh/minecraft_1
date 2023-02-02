package com.modsmaps.addons.mcpecenter2;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.core.content.FileProvider;

import com.android.billingclient.api.BillingClient;
import com.android.billingclient.api.BillingResult;
import com.android.billingclient.api.Purchase;
import com.android.billingclient.api.PurchasesUpdatedListener;
import com.example.moreapp.MoreAppConfig;
import com.example.ratedialog.RatingDialog;
import com.modsmaps.addons.mcpecenter2.in_app.InAppUtil;
import com.modsmaps.addons.mcpecenter2.utils.SharedPrefsUtils;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.util.List;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity
        implements
        RatingDialog.RatingDialogInterFace,
        PurchasesUpdatedListener {
    private static final String CHANNEL = "com.modsmaps.addons.mcpecenter2pp";
    private static final String EVENT_CHANNEL = "EVENT_CHANNEL";
    EventChannel.EventSink events;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {

                switch (methodCall.method) {
                    case "rateManual": {
                        String data = methodCall.argument("data");
                        if (data != null) {
                            MoreAppConfig.setMoreAppConfigs(data);
                        }
                        rateManual();
                        break;
                    }
                    case "install": {
                        if (checkPackage()) {
                            String fileName = methodCall.argument("fileName");
                            String path = Environment.getExternalStorageDirectory().getPath();
                            Log.e("TAG", "onMethodCall: " + path + "/Android/data/" + BuildConfig.APPLICATION_ID);
                            open_file(path + "/" + fileName);
                        } else {
                            Toast.makeText(MainActivity.this, "You must installed Minecraft", Toast.LENGTH_SHORT).show();
                        }
                        break;
                    }
                    case "configInapp": {
//                        Log.d(TAG, "onMethodCall: ");
                        List<String> skus = methodCall.argument("skus");
                        InAppUtil.configPurchase(MainActivity.this, new InAppUtil.ConnectSuccessListener() {
                            @Override
                            public void onSuccess() {
                                result.success("ok");
                            }
                            @Override
                            public void disConnected() {
//                                result.error("0", "", "");
                            }
                        }, skus);
                        InAppUtil.setPurchaseUpdatedListener(MainActivity.this::onPurchasesUpdated);
                        break;
                    }
                    case "checkPremium": {
                        result.success(InAppUtil.isRegisted);
                        break;
                    }
                    case "buy": {
                        String sku = methodCall.argument("sku");
                        InAppUtil.subscription(MainActivity.this, sku);
                        break;
                    }
                    case "rateAuto": {
                        rateAuto();
                        break;
                    }
                    case "sendMess": {
                        Intent sendIntent = new Intent();
                        sendIntent.setAction(Intent.ACTION_SEND);
                        sendIntent.putExtra(Intent.EXTRA_TEXT, "This is my text to send.");
                        sendIntent.setType("text/plain");
                        startActivity(sendIntent);
                    }
                }
            }
        });
        new EventChannel(getFlutterView(), EVENT_CHANNEL).setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                MainActivity.this.events = events;
            }

            @Override
            public void onCancel(Object arguments) {
                events = null;
            }
        });
    }

    private void open_file(String filePath) {
        File file = new File(filePath);
        // Get URI and MIME type of file
        Uri uri = FileProvider.getUriForFile(this, BuildConfig.APPLICATION_ID, file);
        String mime = this.getContentResolver().getType(uri);
        // Open file with user selected app
        Intent intent = new Intent();
        intent.setAction(Intent.ACTION_VIEW);
        intent.setDataAndType(uri, mime);
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        this.startActivity(intent);
    }

    private boolean checkPackage(String packageName) {
        PackageManager packageManager = getPackageManager();
        try {
            packageManager.getPackageInfo(packageName, 0);
            return true;
        } catch (PackageManager.NameNotFoundException e) {
            return false;
        }
    }

    private boolean checkPackage() {
        String minecraft_pack = "com.mojang.minecraftpe";
        String minecraft_pack_try = "com.mojang.minecrafttrialpe";
        return checkPackage(minecraft_pack) || checkPackage(minecraft_pack_try);
    }

    public static void rateApp(Context context) {
        Intent intent = new Intent(new Intent(Intent.ACTION_VIEW,
                Uri.parse("http://play.google.com/store/apps/details?id=" + context.getPackageName())));
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(intent);
    }

    //Rate
    private void rateAuto() {
        int rate = SharedPrefsUtils.getInstance(this).getInt("rate");
        if (rate < 1) {
            RatingDialog ratingDialog = new RatingDialog(this);
            ratingDialog.setRatingDialogListener(this);
            ratingDialog.showDialog();
        }
    }

    private void rateManual() {
        RatingDialog ratingDialog = new RatingDialog(this);
        ratingDialog.setRatingDialogListener(this);
        ratingDialog.showDialog();
    }

    @Override
    public void onDismiss() {

    }

    @Override
    public void onSubmit(float rating) {
        if (rating > 3) {
            rateApp(this);
            SharedPrefsUtils.getInstance(this).putInt("rate", 5);
        }
    }

    @Override
    public void onRatingChanged(float rating) {
    }

    @Override
    public void onPurchasesUpdated(BillingResult billingResult, @Nullable List<Purchase> list) {
        switch (billingResult.getResponseCode()) {
            case BillingClient.BillingResponseCode.OK: {
//                Toast.makeText(this, "OK", Toast.LENGTH_SHORT).show();
                Log.d("TAG", "onPurchasesUpdated: " + "OK");
                if (list != null)
                    for (Purchase purchase : list) {
                        if (purchase.getPurchaseState() == Purchase.PurchaseState.PURCHASED) {
                            InAppUtil.isRegisted = true;
                            JSONObject event = new JSONObject();
                            try {
                                event.put("event", "purchase");
                                event.put("value", "purchased");
                                if (events != null) events.success(event.toString());
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                            Toast.makeText(this, "Now, have enjoy with your app", Toast.LENGTH_SHORT).show();
                        } else {
                            if (purchase.getPurchaseState() == Purchase.PurchaseState.PENDING) {
                                Toast.makeText(this, "Verify your bill...", Toast.LENGTH_SHORT).show();
                            }
                        }
                    }
                break;
            }
            case BillingClient.BillingResponseCode.ITEM_ALREADY_OWNED: {
//                Toast.makeText(this, "ITEM_ALREADY_OWNED", Toast.LENGTH_SHORT).show();
                break;
            }
            case BillingClient.BillingResponseCode.USER_CANCELED: {
//                Toast.makeText(this, "USER_CANCELED", Toast.LENGTH_SHORT).show();
                break;
            }
        }
    }
}
