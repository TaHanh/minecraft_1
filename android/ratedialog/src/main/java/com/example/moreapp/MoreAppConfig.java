package com.example.moreapp;

import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class MoreAppConfig {
    private static List<MoreAppModel> moreAppConfigs;

    public static void demoMoreAppConfig() {
        moreAppConfigs = null;
        moreAppConfigs = new ArrayList<>();
        List<String> list = new ArrayList<>();
        list.addAll(Arrays.asList(new String[]{"https://lh3.googleusercontent.com/UqAlVRg7Q8aOI80g52-HAaxudykfCn096zvCcGjqV43CWCesdzaYn_L1Ji7ITuQR22FL=w9999-h1336",
                "https://lh3.googleusercontent.com/5E2hbTq3DntNeQeYti-JNKyVdd-uz5yCFdirAHEIpoAZcUBlj5iDt0tSrsThYk6z7A=w2880-h1336",
                "https://lh3.googleusercontent.com/Y8d5PCePA0ALbc1tEXSTGStffdN9uPC0AfUz2mEJYeFfP0NW5twpmqyg5s-S4wl9HPk=w2880-h1336",
                "https://lh3.googleusercontent.com/P5wFxGybMYn5wbys6kmGG1rtk2HRe2Xvj2RusUAqFmRMWO_j4MZ8ylbXzYhD46DPIjk=w2880-h1336",
                "https://lh3.googleusercontent.com/r8DI6P4jG05Qpt7Ummtx6OKhRQQ_apYNu99OFt08dyziO3j6DxZs6nEchsBzgHN5lQ=w2880-h1336",
                "https://lh3.googleusercontent.com/f9Sv-qO8jgZ1gruwUn_FyTPYDQfBRTOHDoPGMNjfn6ZKCrQwCmzPcTwmy05EVUpe5w=w2880-h1336"}));
        moreAppConfigs.add(new MoreAppModel("AddOns Maker for Minecraft PE", "https://lh3.googleusercontent.com/oHleq4koJ90R4VuodVZEfqUoDxQ-DE7SaXmE0Uxu8dWwqhNnp2kHHkfHbMJWcg6ySek=s999", "com.mojang.minecraftpe", "Đây là một ứng dụng không chính thức cho Minecraft Pocket Edition. Ứng dụng này không liên quan dưới bất kỳ hình thức nào với Mojang AB. Tên Minecraft, Thương hiệu Minecraft và Tài sản Minecraft đều là tài sản của Mojang AB hoặc chủ sở hữu của họ", list));
        moreAppConfigs.add(new MoreAppModel("AddOns Maker for Minecraft PE", "https://lh3.googleusercontent.com/oHleq4koJ90R4VuodVZEfqUoDxQ-DE7SaXmE0Uxu8dWwqhNnp2kHHkfHbMJWcg6ySek=s999", "co.pamobile.minecraft.addonsmake", "Đây là một ứng dụng không chính thức cho Minecraft Pocket Edition. Ứng dụng này không liên quan dưới bất kỳ hình thức nào với Mojang AB. Tên Minecraft, Thương hiệu Minecraft và Tài sản Minecraft đều là tài sản của Mojang AB hoặc chủ sở hữu của họ", list));
        moreAppConfigs.add(new MoreAppModel("AddOns Maker for Minecraft PE", "https://lh3.googleusercontent.com/oHleq4koJ90R4VuodVZEfqUoDxQ-DE7SaXmE0Uxu8dWwqhNnp2kHHkfHbMJWcg6ySek=s999", "co.pamobile.minecraft.addonsmake", "Đây là một ứng dụng không chính thức cho Minecraft Pocket Edition.Ứng dụng này không liên quan dưới bất kỳ hình thức nào với Mojang AB.Tên Minecraft, Thương hiệu Minecraft và Tài sản Minecraft đều là tài sản của Mojang AB hoặc chủ sở hữu của họ", list));
        moreAppConfigs.add(new MoreAppModel("AddOns Maker for Minecraft PE", "https://lh3.googleusercontent.com/oHleq4koJ90R4VuodVZEfqUoDxQ-DE7SaXmE0Uxu8dWwqhNnp2kHHkfHbMJWcg6ySek=s999", "co.pamobile.minecraft.addonsmake", "Đây là một ứng dụng không chính thức cho Minecraft Pocket Edition.Ứng dụng này không liên quan dưới bất kỳ hình thức nào với Mojang AB.Tên Minecraft, Thương hiệu Minecraft và Tài sản Minecraft đều là tài sản của Mojang AB hoặc chủ sở hữu của họ", list));
    }

    public static List<MoreAppModel> getMoreAppConfigs() {
        return moreAppConfigs;
    }

    public static void setMoreAppConfigs(String data){
        List<MoreAppModel> moreAppModels = new ArrayList<>();
        try {
            JSONArray jsonArray = new JSONArray(data);
//            Log.e("TAGGGG", "setMoreAppConfigs: " + jsonArray.length() );
            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject jsonObject = jsonArray.getJSONObject(i);
//                Log.e("GGGGGGG", "setMoreAppConfigs: " + jsonObject.toString() );
                List<String> images = new ArrayList<>();
                JSONArray ar = jsonObject.getJSONArray("images");
                for (int j = 0; j < ar.length(); j++) {
                    images.add(ar.getString(j));
                }
                String imgLogo, packageName, body, name;
                imgLogo = jsonObject.getString("logo");
                packageName = jsonObject.getString("packageName");
                body = jsonObject.getString("body");
                name = jsonObject.getString("name");
                MoreAppModel model = new MoreAppModel(name, imgLogo, packageName, body, images);
                moreAppModels.add(model);
            }
            MoreAppConfig.moreAppConfigs = moreAppModels;
        } catch (JSONException e) {
            e.printStackTrace();
            MoreAppConfig.moreAppConfigs = null;
        }
    }

    public static class MoreAppModel {
        String name, packageName, title, logoApp;
        List<String> imagesLink;

        public MoreAppModel(String name, String logoApp, String packageName, String title, List<String> imagesLink) {
            this.name = name;
            this.packageName = packageName;
            this.title = title;
            this.imagesLink = imagesLink;
            this.logoApp = logoApp;
        }

        public String getLogoApp() {
            return logoApp;
        }

        public void setLogoApp(String logoApp) {
            this.logoApp = logoApp;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getPackageName() {
            return packageName;
        }

        public void setPackageName(String packageName) {
            this.packageName = packageName;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public List<String> getImagesLink() {
            return imagesLink;
        }

        public void setImagesLink(List<String> imagesLink) {
            this.imagesLink = imagesLink;
        }
    }
}
