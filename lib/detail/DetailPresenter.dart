import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:init_app/detail/DetailView.dart';
import 'package:init_app/utils/BasePresenter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/BasePresenter.dart';
import 'DetailViewModel.dart';

class DetailPresenter<V extends DetailView> extends BasePresenter<V> {
  static DetailView view;
  DetailViewModel viewModel;
  static final String IS_FAVOURITE = "IS_FAVOURITE";
  static final String LIST_DOWNLOAD = "LIST_DOWNLOAD";
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static final String DOWNLOAD = "DOWNLOAD";

  DetailPresenter(this.viewModel) : super() {
    addStreamController(IS_FAVOURITE);
    addStreamController(LIST_DOWNLOAD);
  }

  @override
  void intiView(DetailView baseView) {
    view = baseView;
  }

  void setDownload(value) async {
    dynamic data = [];
    Directory externalDir = await getExternalStorageDirectory();

    for (dynamic item in value) {
      bool isCheck = await File("${externalDir.path}/${item["url"]}").exists();

      if (isCheck) {
        item["status"] = true;
        print("status item ${item["status"]}"); // file tồn tại
      } else {
        item["status"] = false;
      }
      data.add(item);
    }

    viewModel.listDownload = data;
    getSink(LIST_DOWNLOAD).add(new BlocLoaded(data));
  }

  void checkFavourite(id) async {
    int idx;
    if (viewModel.favourite.length == 0) {
      final SharedPreferences prefs = await _prefs;
      List<String> _list = prefs.getStringList('idMaps') ?? [];
      viewModel.favourite = _list;
    }
    idx = viewModel.favourite.indexWhere((element) => element == id);
    if (idx != -1) {
      viewModel.isCheck = true; // nếu item tồn tại trong favourite thì tim đỏ
    } else {
      viewModel.isCheck = false;
    }
    getSink(IS_FAVOURITE).add(new BlocLoaded(viewModel.isCheck));
  }

  StreamController getStreamController(key) {
    return streamController[key];
  }

  void setFavorite(data) async {
    final SharedPreferences prefs = await _prefs;
    List<String> lisst = viewModel.favourite;
    if (viewModel.isCheck) {
      //  item tồn tại nên xóa nếu ấn tim đỏ
      lisst.removeWhere((element) => element == data);
    } else {
      lisst.add(data);
    }
    prefs.setStringList("idMaps", lisst).then((bool success) {
      viewModel.isCheck = !viewModel.isCheck;
      viewModel.favourite = lisst;
      getSink(IS_FAVOURITE).add(new BlocLoaded(viewModel.isCheck));
    }).catchError((onError) {});
  }

  @override
  void download(url, filename) async {
    addStreamController(DOWNLOAD);
    view.showDialogDownload();
    final status = await Permission.storage.request();

    if (status.isGranted) {
      Directory externalDir = await getExternalStorageDirectory();
      print("file  ${externalDir.path}");
      if (!externalDir.existsSync()) {
        externalDir.create();
      }
      Dio().download(url, "${externalDir.path}/${filename}",
          onReceiveProgress: (vall, valll) {
        print("Download11${((vall / valll) * 100).toStringAsFixed(0)} %");
        getSink(DOWNLOAD)
            .add(new BlocLoaded(((vall / valll) * 100).toStringAsFixed(0)));
        if (vall == valll) {
          deleteStreamController(DOWNLOAD);
          view.hideDialogDownload();
//          reload laij list download
          setDownload(viewModel.listDownload);
        }
      });
      print("object");
    } else {
      print("Permission deined");
    }
  }
}
