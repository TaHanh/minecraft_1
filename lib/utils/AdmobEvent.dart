import 'dart:math';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Ads.dart';

AdmobInterstitial interstitialAd;
AdmobBannerSize bannerSize;

void handleEventBanner(
    AdmobAdEvent event, Map<String, dynamic> args, String adType) async {
  switch (event) {
    case AdmobAdEvent.loaded:
      break;
    case AdmobAdEvent.opened:
      break;
    case AdmobAdEvent.closed:
      break;
    case AdmobAdEvent.failedToLoad:
      break;
    case AdmobAdEvent.rewarded:
      break;
    default:
  }
}

void clickAdmob(context, void callBack()) {
  // var rng = new Random();
  // if (rng.nextInt(100) <= Ads.percents) {
  //   loadingAds(context);
  //   Ads.inter((event) {
  //     if (event == InterEvent.LOAD_FAILED) {
  //       Navigator.pop(context);
  //       callBack();
  //     }
  //     if (event == InterEvent.CLOSED) {
  //       Navigator.pop(context);
  //       callBack();
  //     }
  //   });
  // } else {
    callBack();
  // }
}

void handleEventAdmob(AdmobAdEvent event, Map<String, dynamic> args,
    String adType, Function callBack) async {
  switch (event) {
    case AdmobAdEvent.loaded:
      interstitialAd.show();
      break;
    case AdmobAdEvent.opened:
      break;
    case AdmobAdEvent.closed:
      callBack();
      break;
    case AdmobAdEvent.failedToLoad:
      callBack();
      break;
    case AdmobAdEvent.rewarded:
      break;
    default:
  }
}

void loadingAds(context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
          decoration: new BoxDecoration(),
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Image.asset(
                    "assets/images/ic_downloading.png",
                    width: 40.0,
                    height: 40.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 20.0),
                    child: SizedBox(
                      width: 40.0,
                      height: 40.0,
                      child: new CircularProgressIndicator(
                        strokeWidth: 3.0,
                      ),
                    ),
                  ),
                ],
              ),
              new Text(
                "Loading...",
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget bannerWidget(context, BannerAdsSize adsSize) {
  return Container(
    width: MediaQuery.of(context).size.width,
    alignment: Alignment.bottomCenter,
    decoration: BoxDecoration(
        border: Border.all(
      color: Color(0xFF333399),
    )),
    // child: Ads.banner(adsSize: adsSize),
  );
}

Widget bannerWidgetWith(context, BannerAdsSize adsSize, isShowAdmob) {
  return Container(
    width: MediaQuery.of(context).size.width,
    alignment: Alignment.bottomCenter,
    decoration: BoxDecoration(
        border: Border.all(
      color: Color(0xFF333399),
    )),
    // child: Ads.bannerWith(adsSize: adsSize, isShowAdmob: isShowAdmob),
  );
}
