package com.example.moreapp;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;

import com.example.moreapp.adapter.ItemAppAdapter;
import com.example.ratedialog.R;

public class MoreAppActivity extends Activity {
    RecyclerView recyclerView;
    ImageView imgCancel;
    boolean isAuto = true;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.activity_more_app);
        isAuto = getIntent().getBooleanExtra("is_auto", true);
        initView();
        initRecyclerView();
    }

    private void initView() {
        recyclerView = (RecyclerView) findViewById(R.id.recyclerView);
        imgCancel = (ImageView) findViewById(R.id.imgCancel);
        imgCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });
    }

    private void initRecyclerView() {
        LinearLayoutManager manager = new LinearLayoutManager(this);
        recyclerView.setLayoutManager(manager);
        ItemAppAdapter adapter = new ItemAppAdapter(MoreAppConfig.getMoreAppConfigs());
        adapter.setAdapterClickLinstener(new ItemAppAdapter.OnAdapterClickLinstener() {
            @Override
            public void onClick(int index) {
                Intent i = new Intent();
                i.setAction("ACTON_CLICK_ABC");
                i.putExtra("package", MoreAppConfig.getMoreAppConfigs().get(index).packageName);
                sendBroadcast(i);
                if (isAuto) {
                    if (!checkInstalledApp(MoreAppActivity.this, MoreAppConfig.getMoreAppConfigs().get(index).getPackageName())) {
                        Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=" + MoreAppConfig.getMoreAppConfigs().get(index).getPackageName()));
                        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                        startActivity(intent);
                        finish();
                    } else {
                        Intent launchIntent = getPackageManager().getLaunchIntentForPackage(MoreAppConfig.getMoreAppConfigs().get(index).getPackageName());
                        if (launchIntent != null) {
                            launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                            startActivity(launchIntent);
                            finish();
                        }
                    }
                }
            }
        });
        recyclerView.setAdapter(adapter);
    }

    private boolean checkInstalledApp(Context context, String packageName) {
        PackageManager packageManager = context.getPackageManager();
        try {
            packageManager.getPackageInfo(packageName, 0);
            return true;
        } catch (PackageManager.NameNotFoundException e) {
            return false;
        }
    }
}