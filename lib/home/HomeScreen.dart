import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:init_app/Premium/PremiumScreen.dart';
import 'package:init_app/config.dart';
import 'package:init_app/detail/DetailScreen.dart';
import 'package:init_app/info/InfoScreen.dart';
import 'package:init_app/main.dart';
import 'package:init_app/search/SearchScreen.dart';
import 'package:init_app/utils/Ads.dart';
import 'package:init_app/utils/BasePresenter.dart';
import 'package:init_app/utils/CallNativeUtils.dart';
import 'package:init_app/utils/IntentAnimation.dart';
import 'package:share/share.dart';

import '../utils/AdmobEvent.dart';
import 'HomePresenter.dart';
import 'HomeView.dart';
import 'HomeViewModel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> implements HomeView {
  HomeViewModel viewModel;
  HomePresenter _presenter;
  List<Map<String, dynamic>> menu = [
    {"name": "Mods", "icon": "assets/images/ic_menu_1.png"},
    {"name": "Favourite", "icon": "assets/images/ic_menu_2.png"},
    {"name": "Info", "icon": "assets/images/ic_menu_3.png"},
    {"name": "Share", "icon": "assets/images/ic_menu_4.png"},
  ];
  final _formKey = GlobalKey<FormState>();
  String nextFavourite = "FAVOURITE";
  TextEditingController controllerInput = TextEditingController();
  FocusNode _focus = new FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CallNativeUtils.invokeMethod(
        method: "rateManual", aguments: {"data": jsonEncode(Config.moreApp)});
    viewModel = new HomeViewModel();
    _presenter = new HomePresenter(viewModel);
    _presenter.intiView(this);
    _presenter.getMods();
    _focus.addListener(() {
      if (_focus.hasFocus && false) {
        FocusScope.of(context).unfocus();
        IntentAnimation.intentNomal(
            context: context,
            screen: PremiumScreen(),
            option: IntentAnimationOption.LEFT_TO_RIGHT,
            duration: Duration(milliseconds: 500));
        // pushNavigator(context, PremiumScreen(), () {});
      }
    });
    if (evChannel != null) {
      evChannel.receiveBroadcastStream().listen((event) {
        event = jsonDecode(event);
        if (event["event"] == "purchase") {
          if (event["value"] == "purchased") {
            Config.isPremium = true;
            if (mounted) {
              _presenter.updateMods();
            }
          }
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _focus.dispose();
    if (_presenter != null) {
      _presenter.onDispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double menuSize = 50.0;

    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      backgroundColor: Color(0xFF1a1913),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                children: [
                  StreamBuilder(
                    stream: _presenter.getStream(HomePresenter.MAPS),
                    builder: (ctx, snap) {
                      return snap.data is BlocLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : snap.data is BlocLoaded
                              ? snap.data.value["key"] == NAV1
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            decoration: new BoxDecoration(
                                              color: Colors.white54,
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: TextField(
                                              autofocus: false,
                                              // focusNode: _focus,
                                              controller: controllerInput,
                                              textInputAction:
                                                  TextInputAction.search,
                                              onSubmitted: (value) {
                                                // if (Config.isPremium) {
                                                  pushNavigator(
                                                      context,
                                                      SearchScreen(
                                                          data: snap.data
                                                              .value["value"],
                                                          value: value),
                                                      () {});
                                                // } else {
                                                //   pushNavigator(context,
                                                //       PremiumScreen(), () {});
                                                // }
                                              },
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                prefixIcon: Icon(Icons.search),
                                                hintText: 'Search',
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        20.0, 15.0, 20.0, 15.0),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: snap.data.value["value"]
                                                        .length >
                                                    0
                                                ? ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    itemCount: snap.data
                                                        .value["value"].length,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 0.0,
                                                            vertical: 5.0),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      var item = snap.data
                                                              .value["value"]
                                                          [index];
                                                      return itemWidget(
                                                          item, size, () {
                                                        print(
                                                            "objectobjectobjectobjectobjectobject ${item["status"]}");
                                                        if (item["status"]) {
                                                          // item open lock
                                                          clickAdmob(context,
                                                              () {
                                                            pushNavigator(
                                                                context,
                                                                DetailScreen(
                                                                    data: item),
                                                                () {});
                                                          });
                                                        } else {
                                                          // item lock
                                                          pushNavigator(
                                                              context,
                                                              PremiumScreen(
                                                                  type: "BACK"),
                                                              () {});
                                                        }
                                                      });
                                                      return Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 10.0,
                                                            top: 10.0),
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            if (item[
                                                                "status"]) {
                                                              // item open lock
                                                              clickAdmob(
                                                                  context, () {
                                                                pushNavigator(
                                                                    context,
                                                                    DetailScreen(
                                                                        data:
                                                                            item),
                                                                    () {});
                                                              });
                                                            } else {
                                                              // item lock
                                                              pushNavigator(
                                                                  context,
                                                                  PremiumScreen(
                                                                      type:
                                                                          "BACK"),
                                                                  () {});
                                                            }
                                                          },
                                                          child: Stack(
                                                            children: [
                                                              Container(
                                                                width:
                                                                    size.width -
                                                                        30.0,
                                                                child: FadeInImage
                                                                    .assetNetwork(
                                                                  placeholder:
                                                                      "assets/images/img_not_found.png",
                                                                  image: Config
                                                                          .host +
                                                                      "/addons/" +
                                                                      item[
                                                                          "id"] +
                                                                      "/" +
                                                                      item["images"]
                                                                              [
                                                                              0]
                                                                          [
                                                                          "url"],
                                                                  height: 200,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                              Positioned(
                                                                bottom: 0.0,
                                                                right: 0.0,
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          15.0,
                                                                      horizontal:
                                                                          5.0),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  color: Colors
                                                                      .black45,
                                                                  width:
                                                                      size.width -
                                                                          30.0,
                                                                  child: Text(
                                                                    item[
                                                                        "title"],
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18.0,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                              true // item lock
                                                                  ? Container(
                                                                      width: size
                                                                              .width -
                                                                          30.0,
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/images/ic_locked.png",
                                                                        height:
                                                                            200,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    })
                                                : Center(
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 50.0),
                                                      child: Image.asset(
                                                        "assets/images/data_not_found.png",
                                                        // height: 200,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : snap.data.value["key"] == NAV2
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 20.0, 0, 10.0),
                                                child: Text(
                                                  "FAVOURITE",
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Expanded(
                                                child: snap.data.value["value"]
                                                            .length >
                                                        0
                                                    ? ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            BouncingScrollPhysics(),
                                                        itemCount: snap
                                                            .data
                                                            .value["value"]
                                                            .length,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 0.0,
                                                                vertical: 5.0),
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          var item = snap
                                                                  .data.value[
                                                              "value"][index];
                                                          return itemWidget(
                                                              item, size, () {
                                                            pushNavigator(
                                                                context,
                                                                DetailScreen(
                                                                  data: item,
                                                                  screen:
                                                                      nextFavourite,
                                                                ), (key) {
                                                              if (key != null &&
                                                                  key ==
                                                                      nextFavourite) {
                                                                _presenter
                                                                    .getFavorite();
                                                              }
                                                            });
                                                          });
                                                          return Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        10.0,
                                                                    top: 10.0),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                pushNavigator(
                                                                    context,
                                                                    DetailScreen(
                                                                      data:
                                                                          item,
                                                                      screen:
                                                                          nextFavourite,
                                                                    ), (key) {
                                                                  if (key !=
                                                                          null &&
                                                                      key ==
                                                                          nextFavourite) {
                                                                    _presenter
                                                                        .getFavorite();
                                                                  }
                                                                });
                                                              },
                                                              child: Stack(
                                                                children: [
                                                                  Container(
                                                                    width: size
                                                                            .width -
                                                                        30.0,
                                                                    child: FadeInImage
                                                                        .assetNetwork(
                                                                      placeholder:
                                                                          "assets/images/img_not_found.png",
                                                                      image: Config
                                                                              .host +
                                                                          "/addons/" +
                                                                          item[
                                                                              "id"] +
                                                                          "/" +
                                                                          item["images"][0]
                                                                              [
                                                                              "url"],
                                                                      height:
                                                                          200,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    bottom: 0.0,
                                                                    right: 0.0,
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              15.0,
                                                                          horizontal:
                                                                              5.0),
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      color: Colors
                                                                          .black45,
                                                                      width: size
                                                                              .width -
                                                                          30.0,
                                                                      child:
                                                                          Text(
                                                                        item[
                                                                            "title"],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18.0,
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        })
                                                    : Center(
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 50.0),
                                                          child: Image.asset(
                                                            "assets/images/data_not_found.png",
                                                            // height: 200,
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                            ],
                                          ))
                                      : snap.data.value["key"] == NAV3
                                          ? InfoScreen()
                                          : Container()
                              : Container();
                    },
                  ),
                  Positioned(
                    left: 0,
                    top: (size.height - (menuSize + 30) * menu.length) / 2 -
                        35.0,
                    child: Container(
                      alignment: Alignment.center,
                      height: (menuSize + 30) * menu.length,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0)),
                        color: Color(0xFF2b190d),
                      ),
                      width: menuSize + 10,
                      child: StreamBuilder(
                        stream: _presenter.getStream(HomePresenter.MENU),
                        builder: (ctx, snap) => ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: menu.length,
                          itemBuilder: (BuildContext context, int index) =>
                              GestureDetector(
                            onTap: () => _presenter.setMenu(index),
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10.0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: menuSize - 5.0,
                                      height: menuSize - 5.0,
                                      decoration: new BoxDecoration(
                                        color: snap.data is BlocLoaded
                                            ? snap.data.value == index
                                                ? Color(0xFFbf8b42)
                                                : Color(0xFFa0a0a0)
                                            : Color(0xFFa0a0a0),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 8.0),
                                      margin: EdgeInsets.only(bottom: 5.0),
                                      child: Image.asset(menu[index]["icon"]),
                                    ),
                                    Text(
                                      menu[index]["name"],
                                      style: TextStyle(
                                        fontSize: 10.0,
                                        color: snap.data is BlocLoaded
                                            ? snap.data.value == index
                                                ? Color(0xFFbf8b42)
                                                : Color(0xFF7a7a7a)
                                            : Color(0xFF7a7a7a),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // bannerWidget(context, BannerAdsSize.BANNER)
          ],
        ),
      ),
    );
  }

  @override
  void showDialog() {
    // TODO: implement showDialog
  }

  @override
  void showMess(String mess) {
    print("object");
    // TODO: implement showMess
  }

  @override
  void share() {
    Share.share(Config.playstore);
  }

  @override
  Widget itemWidget(item, size, callBack) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
      padding: EdgeInsets.all(0),
      child: GestureDetector(
        onTap: () {
          callBack();
        },
        child: Stack(
          children: [
            Container(
              width: size.width - 30.0,
              child: FadeInImage.assetNetwork(
                placeholder: "assets/images/img_not_found.png",
                image: Config.host +
                    "/addons/" +
                    item["id"] +
                    "/" +
                    item["images"][0]["url"],
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                alignment: Alignment.centerRight,
                color: Colors.black45,
                width: size.width - 30.0,
                child: Text(
                  item["title"],
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ),
            item["status"] // true => mở khoá
                ? Container()
                : Container(
                    width: size.width - 30.0,
                    child: Image.asset(
                      "assets/images/ic_locked.png",
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
