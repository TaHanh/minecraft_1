import 'dart:async';
import 'dart:collection';

import 'BaseView.dart';

abstract class BasePresenter<V extends BaseView> {
  HashMap<String, StreamController<BlocEvent>> streamController;

  BasePresenter() {
    streamController = new HashMap();
  }
  addStreamControllerBroadcast(k) {
    streamController.putIfAbsent(k, () => StreamController<BlocEvent>.broadcast());
  }

  void addStreamController(k) {
    streamController.putIfAbsent(k, () => StreamController<BlocEvent>());
  }

  void intiView(V baseView) {}

  Sink getSink(k) {
    return streamController[k].sink;
  }

  Stream getStream(k) {
    return streamController[k].stream;
  }

  StreamController getStreamController(key) {
    return streamController[key];
  }

  void deleteStreamController(key) {
    streamController.remove(key);
  }

  void onDispose() {
    streamController.forEach((f, v) {
      v.close();
    });
    streamController.clear();
  }
}

abstract class BlocEvent {}

class BlocLoading extends BlocEvent {}

class BlocLoaded extends BlocEvent {
  dynamic value;

  BlocLoaded(this.value);
}

class BlocFailed extends BlocEvent {
  String mess;

  BlocFailed(this.mess);
}
