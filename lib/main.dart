import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:init_app/plash/PlashScreen.dart';
import 'package:init_app/utils/CallNativeUtils.dart';

import 'utils/Ads.dart';

EventChannel evChannel;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  CallNativeUtils.setChannel("com.modsmaps.addons.mcpecenter2pp");
  evChannel = new EventChannel("EVENT_CHANNEL");
  // Ads.init();
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlashScreen(),
    );
  }
}
