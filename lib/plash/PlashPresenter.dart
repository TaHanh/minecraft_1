//class to handle event of user from screen and excution

import 'package:init_app/api/mods.dart';
import 'package:init_app/common/Common.dart';
import 'package:init_app/plash/PlashView.dart';
import 'package:init_app/utils/Ads.dart';
import 'package:init_app/utils/BasePresenter.dart';
import 'package:init_app/utils/CallNativeUtils.dart';

import '../config.dart';
import '../utils/BasePresenter.dart';
import 'PlashViewModel.dart';

class PlashPresenter<V extends PlashView> extends BasePresenter<V> {
  PlashView view;
  PlashViewModel viewModel;

  static final String DATA = "DATA";

  bool isLoadAdsSuccess = false;

  bool isLoadDataSuccess = false;

  PlashPresenter(this.viewModel) : super() {
    addStreamController(DATA);
  }

  @override
  void intiView(PlashView baseView) {
    this.view = baseView;
  }

  void getMods() {
    getSink(DATA).add(new BlocLoading());
    fetchModsAPI().then((value) {
      isLoadDataSuccess = true;
      if (value["maps"].length > 500) {
        Common.dataMaps = value["maps"].sublist(0, 500);
      } else {
        Common.dataMaps = value["maps"];
      }
      for (var item in Common.dataMaps) {
        item["status"] = false; // trạng thái khoá
      }
      for (var i = 0; i < 5; i++) {
        Common.dataMaps[i]["status"] = true; // 5 phần từ đầu trạng thái mở khoá
      }
      getSink(DATA).add(new BlocLoaded(Common.dataMaps));
      nextScreen();
    }).catchError((onError) {
      print("object ${onError}");
      getSink(DATA).add(new BlocFailed(""));
    });
  }

  void getAds() {
    print("adsSSSSSSS");
    getAdsData().then((value) {
      print("adsSSSSSSS$value");

      Common.product_id = value["in_app"][0]["product_id"];
      if (!Config.isDebug) {
        Ads.admobBannerID = value["ad_banner_id"];
        Ads.admobInterstitialID = value["ad_inter_id"];
        Ads.fanBannerID = value["ad_banner_fan_id"];
        Ads.fanInterstitialID = value["ad_inter_fan_id"];
      }
      Ads.percents = value["percents_inter"];
      Ads.isShowAdmob = value["isAdmob"];
      Ads.isLoadFailled = value["is_load_failed"];
      Config.moreApp = value["more_app"];
      dynamic skus = value["in_app"].map((e) => e["product_id"]).toList();

      CallNativeUtils.invokeMethod(
          method: "configInapp", aguments: {"skus": skus}).then((value) {
        isLoadAdsSuccess = true;
        print("aksjdlkajsdasdasdasd$value");
        CallNativeUtils.invokeMethod(method: "checkPremium").then((value) {
          Config.isPremium = value;
        });
        nextScreen();
      }).catchError((err) {
        print("akldjlkajdlkasjdl load in app failed$err");
        view.showMess("Load inapp Failed");
      });
    }).catchError((err) {
      print("errrrrr$err");
    });
  }

  void nextScreen() {
    if (isLoadDataSuccess && isLoadAdsSuccess) view.nextScreen();
  }
}
