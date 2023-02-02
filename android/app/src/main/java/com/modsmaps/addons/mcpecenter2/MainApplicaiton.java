package com.modsmaps.addons.mcpecenter2;

import com.flurry.android.FlurryAgent;

import io.flutter.app.FlutterApplication;

public class MainApplicaiton extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        new FlurryAgent.Builder()
                .withLogEnabled(true)
                .build(this, "NXP76QV9RMPHV7T7JGGP");
    }
}
