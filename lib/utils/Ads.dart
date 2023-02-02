import 'package:admob_flutter/admob_flutter.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:init_app/config.dart';
import 'package:init_app/utils/AdmobEvent.dart';

class Ads {
  static String admobAppID = Config.admobAppID;
  static String admobBannerID = Config.admobBannerID;
  static String admobInterstitialID = Config.admobInterstitialID;
  static String fanBannerID = Config.fanBannerID;
  static String fanInterstitialID = Config.fanInterstitialID;
  static bool isShowAdmob = false;
  static bool isLoadFailled = true;

  static int percents = 50;

  static void init() {
    FacebookAudienceNetwork.init();
    Admob.initialize();
  }

  static void inter(callBackInter) {
    if (isShowAdmob) {
      AdsUtils.interAdMob(
          idInter: admobInterstitialID, callback: callBackInter);
    } else {
      AdsUtils.interFan(
          idFan: fanInterstitialID,
          callBackInter: (event) {
            if (event == InterEvent.LOAD_FAILED) {
              print("${event}");
              if (isLoadFailled) {
                AdsUtils.interAdMob(
                    idInter: admobInterstitialID, callback: callBackInter);
              } else {
                callBackInter(event);
                return;
              }
            } else {
              callBackInter(event);
            }
          });
    }
  }

  static Widget banner({@required BannerAdsSize adsSize}) {
    return Container();
    return BannerWidget(isShowAdmob, isLoadFailled, adsSize,
        admobId: admobBannerID, fanId: fanBannerID);
  }

  static Widget bannerWith({@required BannerAdsSize adsSize, isShowAdmob}) {
    return Container();
    return BannerWidget(isShowAdmob, isLoadFailled, adsSize,
        admobId: admobBannerID, fanId: fanBannerID);
  }
}

class AdsUtils {
  static void interAdMob({idInter, callback}) {
    AdmobInterstitial interstitial;
    interstitial = new AdmobInterstitial(
        adUnitId: idInter,
        listener: (event, args) {
          switch (event) {
            case AdmobAdEvent.failedToLoad:
              {
                if (callback != null) callback(InterEvent.LOAD_FAILED);
                break;
              }
            case AdmobAdEvent.closed:
              {
                if (callback != null) callback(InterEvent.CLOSED);
                break;
              }
            case AdmobAdEvent.loaded:
              {
                interstitial.show();
                if (callback != null) callback(InterEvent.LOADED);
                break;
              }
          }
        });
    interstitial.load();
  }

  static void interFan({@required idFan, callBackInter}) {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: idFan,
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED) {
          if (callBackInter != null) callBackInter(InterEvent.LOADED);
          FacebookInterstitialAd.showInterstitialAd();
        }
        if (result == InterstitialAdResult.DISMISSED) {
          if (callBackInter != null) callBackInter(InterEvent.CLOSED);
        }
        if (result == InterstitialAdResult.ERROR) {
          print("valueeeee${value}");
          if (callBackInter != null) callBackInter(InterEvent.LOAD_FAILED);
        }
      },
    );
  }
}

enum BannerAdsSize { BANNER, LARGE, MEDIUM }

class BannerWidget extends StatefulWidget {
  var isShowAdmob = true;
  var isLoadDataFailed = false;
  var admobId, fanId;
  BannerAdsSize bannerSize;

  BannerWidget(this.isShowAdmob, this.isLoadDataFailed, this.bannerSize,
      {this.admobId, this.fanId}) {
    if (isShowAdmob && admobId == null)
      throw ("BannerWidget Admob Id must not be null");
    if (!isShowAdmob && fanId == null)
      throw ("BannerWidget Fan Id Id must not be null");
    print("asdlkjasldkjlskajldasd${bannerSize}");
  }

  @override
  _BannerWidgetState createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  var isFanLoadFailed = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFanLoadFailed = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    return widget.isShowAdmob || isFanLoadFailed
        ? AdmobBanner(
            adUnitId: widget.admobId,
            adSize:
                widget.bannerSize.toString() == BannerAdsSize.BANNER.toString()
                    ? AdmobBannerSize.BANNER
                    : widget.bannerSize == BannerAdsSize.LARGE
                        ? AdmobBannerSize.LARGE_BANNER
                        : AdmobBannerSize.MEDIUM_RECTANGLE,
            listener: (AdmobAdEvent event, Map<String, dynamic> args) {
              handleEventBanner(event, args, 'Banner');
            },
          )
        : FacebookBannerAd(
            placementId: widget.fanId,
            bannerSize: widget.bannerSize == BannerAdsSize.BANNER
                ? BannerSize.STANDARD
                : widget.bannerSize == BannerAdsSize.LARGE
                    ? BannerSize.LARGE
                    : BannerSize.MEDIUM_RECTANGLE,
            listener: (result, value) {
              if (result == BannerAdResult.ERROR) {
                if (widget.isLoadDataFailed)
                  setState(() {
                    isFanLoadFailed = true;
                  });
                // isFanLoadFailed = false;
              }
            },
          );
  }
}

enum InterEvent { LOADED, CLOSED, LOAD_FAILED }
