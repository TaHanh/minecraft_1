import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:init_app/Premium/PremiumScreen.dart';
import 'package:init_app/home/HomeScreen.dart';
import 'package:init_app/plash/PlashPresenter.dart';
import 'package:init_app/plash/PlashView.dart';
import 'package:init_app/plash/PlashViewModel.dart';
import 'package:init_app/utils/BasePresenter.dart';
import 'package:init_app/utils/IntentAnimation.dart';

import '../config.dart';

class PlashScreen extends StatefulWidget {
  PlashScreen({Key key}) : super(key: key);

  @override
  _PlashScreenState createState() => _PlashScreenState();
}

class _PlashScreenState extends State<PlashScreen> implements PlashView {
  PlashPresenter _presenter;
  PlashViewModel viewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = new PlashViewModel();
    _presenter = new PlashPresenter(viewModel);
    _presenter.intiView(this);
    _presenter.getMods();
    // _presenter.getAds();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new ExactAssetImage('assets/images/background1.png'),
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(1), BlendMode.dstATop),
          ),
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFF00345c),
              Color(0xFF203f6e),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Container(),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 50.0),
              child: StreamBuilder(
                  stream: _presenter.getStream(PlashPresenter.DATA),
                  builder: (ctx, snap) {
                    return snap.data is BlocFailed
                        ? Center(
                            child: Column(
                              children: [
                                Text(
                                  "Loading failed !",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20.0),
                                  decoration: new BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color(0xFFF05F57),
                                        Color(0xFFF05F57),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                  ),
                                  child: FlatButton(
                                    onPressed: () {
                                      _presenter.getMods();
                                    },
                                    child: Text(
                                      "Try again",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: Column(
                              children: [
                                CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.blue),
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 20.0),
                                    child: Text(
                                      "Loading data...",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.0),
                                    )),
                              ],
                            ),
                          );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void nextScreen() {
    // TODO: implement nextScreen
    if (Config.isPremium) {
      IntentAnimation.intentPushReplacement(
          context: context,
          screen: HomeScreen(),
          option: IntentAnimationOption.BOTTOM_TO_TOP,
          duration: Duration(seconds: 1));
    } else {
      IntentAnimation.intentPushReplacement(
          context: context,
          screen: PremiumScreen(
            type: "HOME",
          ),
          option: IntentAnimationOption.BOTTOM_TO_TOP,
          duration: Duration(seconds: 1));
    }
  }

  @override
  void showMess(String mess) {
    // TODO: implement showMess
    print("loadDDDDDDDD${mess}");
  }
}
