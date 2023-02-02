import 'dart:async';
import 'dart:convert';

import "package:http/http.dart" as http;

import '../config.dart';

Future fetchModsAPI() {
  Completer completer = new Completer();
  http.get("${Config.host}${Config.maps}").then((value) {
    if (value.statusCode == 200) {
      print(value.body);
      completer.complete(jsonDecode(value.body));
    } else
      completer.completeError("err");
  }).catchError((err) => {completer.completeError(err)});
  return completer.future;
}

Future getAdsData() {
  Completer completer = new Completer();
  http.get(Config.apiAds).then((value) {
    if (value.statusCode == 200) {
      completer.complete(jsonDecode(value.body)["configs"]);
    } else
      completer.completeError("fail data");
  }).catchError((err) {
    completer.completeError(err);
  });
  return completer.future;
}
