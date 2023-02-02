import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:init_app/common/Common.dart';
import 'package:init_app/config.dart';
import 'package:init_app/home/HomeScreen.dart';
import 'package:init_app/utils/CallNativeUtils.dart';
import 'package:init_app/utils/IntentAnimation.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumScreen extends StatefulWidget {
  PremiumScreen({Key key, this.type}) : super(key: key);
  String type;
  @override
  _PremiumScreenState createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(
          msg: "Could not launch $url",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xFFFD6E6A),
          textColor: Colors.white,
          webBgColor: "linear-gradient(to right, #FEB692, #EA5455)",
          fontSize: 15.0);
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new ExactAssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(Colors.black.withOpacity(1), BlendMode.dstATop),
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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  // child: Container(),
                  child: Image.asset("assets/images/img.png"),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                  child: Text(
                    "Spend time playing the game, not looking for mods, maps",
                    style: TextStyle(fontSize: 25.0, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  child: Text(
                    "After the offer exprires the subcription will automatically become paid and you will be charged 29.99\$ once a week until you cancel. You can unsubscribe at any time. See our privacy policy and terms of use",
                    style: TextStyle(fontSize: 13.0, color: Colors.white60),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: GestureDetector(
                    onTap: () => _launchURL(Config.policy),
                    child: Text(
                      "Privacy Policy & Terms of use",
                      style: TextStyle(fontSize: 18.0, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
                    width: size.width,
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFFf12711),
                          Color(0xFFf5af19),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: FlatButton(
                      onPressed: () {
                        CallNativeUtils.invokeMethod(method: "buy", aguments: {"sku": Common.product_id});
                      },
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        "Start your free 3-day trial",
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ))
              ],
            ),
            Positioned(
              top: 35.0,
              left: 0.0,
              child: IconButton(
                onPressed: () {
                  if (widget.type != null && widget.type == "HOME") {
                    IntentAnimation.intentPushReplacement(
                        context: context,
                        screen: HomeScreen(),
                        option: IntentAnimationOption.TOP_TO_BOTTOM,
                        duration: Duration(seconds: 1));
                  } else {
                    Navigator.pop(context);
                  }
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.white60,
                  size: 35.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
