import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(65.0, 15.0, 15.0, 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Instructions for using the application",
              style: TextStyle(fontSize: 22.0, color: Colors.white),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "1. Select your favourite card or map",
                style: TextStyle(color: Color(0xFFbf8b42)),
              ),
            ),
            Image.asset("assets/images/info_1.png"),
            Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Jump League",
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                )),
            Container(
              child: Text(
                "This is a simple parkour map that overcomes obstacles using command blocks and must defeat the final boss",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "2. Press the download button and wait for the map or mod to download to your device.",
                style: TextStyle(color: Color(0xFFbf8b42)),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 0, 15.0, 0),
              height: 50.0,
              decoration: new BoxDecoration(
                color: Color(0xFF492a18),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Image.asset(
                      "assets/images/ic_download.png",
                      width: 40.0,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Download",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              padding: EdgeInsets.fromLTRB(10.0, 0, 15.0, 0),
              height: 50.0,
              decoration: new BoxDecoration(
                color: Color(0xFF492a18),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Image.asset(
                      "assets/images/ic_downloading.png",
                      width: 40.0,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Downloading",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Text(
                "3. Click the install button, Minecraft will open and import into the game will begin. Wait for the import to finish.",
                style: TextStyle(color: Color(0xFFbf8b42)),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 15.0, 5.0),
              margin: EdgeInsets.symmetric(vertical: 10.0),
              height: 50.0,
              decoration: new BoxDecoration(
                color: Color(0xFF492a18),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Install",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )
                ],
              ),
            ),
            Image.asset("assets/images/info_2.png"),

            //
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "4. The downloaded map will appear in the Worlds section.",
                style: TextStyle(color: Color(0xFFbf8b42)),
              ),
            ),
            Image.asset("assets/images/info_3.png"),

            //
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "5. Enjoy the game!",
                style: TextStyle(color: Color(0xFFbf8b42)),
              ),
            ),
            Image.asset("assets/images/info_4.png"),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "If you have installed mods then they will appear in the appropriate section in the map settings.",
                style: TextStyle(color: Color(0xFFbf8b42)),
              ),
            ),
            Image.asset("assets/images/info_5.png"),
          ],
        ),
      ),
    );
  }
}
