import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:init_app/config.dart';
import 'package:init_app/detail/DetailPresenter.dart';
import 'package:init_app/detail/DetailViewModel.dart';
import 'package:init_app/utils/AdmobEvent.dart';
import 'package:init_app/utils/Ads.dart';
import 'package:init_app/utils/BasePresenter.dart';
import 'package:init_app/utils/CallNativeUtils.dart';

import '../utils/BasePresenter.dart';
import 'DetailPresenter.dart';
import 'DetailView.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({Key key, this.data, this.screen}) : super(key: key);
  dynamic data;
  String screen;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> implements DetailView {
  DetailViewModel viewModel;
  DetailPresenter _presenter;
  bool _isChange = false;

  bool downloading = false;
  var progressString = "";
  int progress = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    viewModel = new DetailViewModel();
    _presenter = new DetailPresenter(viewModel);
    _presenter.intiView(this);
    _presenter.setDownload(widget.data["downloads"]);
    _presenter.checkFavourite(widget.data["id"]);
  }

  @override
  void dispose() {
    super.dispose();
    if (_presenter != null) {
      _presenter.onDispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Color(0xFF1a1913),
        appBar: AppBar(
          backgroundColor: Color(0xFF333399),
          // 161c4a
          title: Text(widget.data["title"]),
          leading: IconButton(
            onPressed: () {
              if (widget.screen == "FAVOURITE" && _isChange) {
                Navigator.pop(context, widget.screen);
              } else {
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.arrow_back_ios_rounded),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                _isChange = true;
                _presenter.setFavorite(widget.data["id"]);
              },
              child: Container(
                padding: EdgeInsets.all(12.0),
                height: 50.0,
                child: StreamBuilder(
                    stream: _presenter.getStream(DetailPresenter.IS_FAVOURITE),
                    builder: (ctx, snap) {
                      return snap.data is BlocLoaded
                          ? snap.data.value
                              ? Image.asset(
                                  "assets/images/ic_heart_active.png",
                                  fit: BoxFit.contain,
                                )
                              : Image.asset(
                                  "assets/images/ic_heart.png",
                                  fit: BoxFit.contain,
                                )
                          : Container();
                    }),
              ),
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CarouselSlider.builder(
                      options: CarouselOptions(
                          height: 250,
                          // aspectRatio: 16 / 9,
                          viewportFraction: 1,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 5),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 1000),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          aspectRatio: 2.0,
                          onPageChanged: (index, reason) {}),
                      itemCount: widget.data["images"].length,
                      itemBuilder: (BuildContext context, int index) =>
                          Image.network(
                        Config.host +
                            "/addons/" +
                            widget.data["id"] +
                            "/" +
                            widget.data["images"][index]["url"],
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                      child: Text(
                        widget.data["title"],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 15.0),
                      child: Text(
                        widget.data["text"],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    StreamBuilder(
                        stream:
                            _presenter.getStream(DetailPresenter.LIST_DOWNLOAD),
                        builder: (ctx, snap) {
                          return snap.data is BlocLoaded
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: snap.data.value.map<Widget>((item) {
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 20.0),
                                      padding: EdgeInsets.all(0.0),
                                      child: FlatButton(
                                        onPressed: () {
                                          clickAdmob(context, () {
                                            if (item["status"]) {
                                              // install file exists
                                              print("// install file exists");
                                              CallNativeUtils.invokeMethod(
                                                  method: "install",
                                                  aguments: {
                                                    "fileName": item["url"]
                                                  });
                                            } else {
                                              String url = Config.download +
                                                  widget.data["id"] +
                                                  "/" +
                                                  item["url"];
                                              _presenter.download(
                                                  url, item["url"]);
                                            }
                                          });
                                        },
                                        padding: EdgeInsets.fromLTRB(
                                            10.0, 0, 15.0, 0),
                                        color: Color(0xFF4e54c8),
                                        // 161c4a
                                        height: 50.0,
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(50)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding:
                                                  EdgeInsets.only(right: 10.0),
                                              child: Image.asset(
                                                "assets/images/ic_download.png",
                                                width: 40.0,
                                              ),
                                            ),
                                            Text(
                                              item["status"]
                                                  ? "Install"
                                                  : "Download",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : Container();
                        }),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ),
            // bannerWidgetWith(context, BannerAdsSize.BANNER, true),
          ],
        ));
  }

  @override
  void showAlertDialog() {
    // TODO: implement showDialog
  }

  @override
  void showMess(String mess) {
    print("object");
    // TODO: implement showMess
  }

  @override
  void showDialogDownload() {
    // TODO: implement showDialogDownload
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
              child: StreamBuilder(
                stream: _presenter.getStream(DetailPresenter.DOWNLOAD),
                builder: (ctx, snap) => new Row(
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
                    new Text.rich(
                      TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: 'Downloading ', style: TextStyle()),
                          TextSpan(
                              text:
                                  '${snap.data is BlocLoaded ? " ${snap.data.value} %" : ""}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0)),
                        ],
                        style: TextStyle(fontSize: 15.0),
                      ),
                    )
                    // new Text(
                    //   '${snap.data is BlocLoaded ? "Downloading ${snap.data.value} %" : "Downloading"}',
                    //   style: TextStyle(fontSize: 16.0),
                    // ),
                  ],
                ),
              ),
            )));
  }

  @override
  void hideDialogDownload() {
    // TODO: implement hideDialogDownload
    Navigator.pop(context);
    // _presenter.getStreamController(DetailPresenter.DOWNLOAD).close();
  }
}
