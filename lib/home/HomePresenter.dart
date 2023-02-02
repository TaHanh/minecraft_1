//class to handle event of user from screen and excution
import 'package:init_app/common/Common.dart';
import 'package:init_app/home/HomeView.dart';
import 'package:init_app/utils/BasePresenter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/BasePresenter.dart';
import 'HomeViewModel.dart';

String NAV1 = "NAV1";
String NAV2 = "NAV2";
String NAV3 = "NAV3";

class HomePresenter<V extends HomeView> extends BasePresenter<V> {
  HomeView view;
  HomeViewModel viewModel;
  static final String MENU = "MENU";
  static final String MAPS = "MAPS";
  int currentIndex = 0;
  int limitData = 200;
  bool isLoadData = false;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  HomePresenter(this.viewModel) : super() {
    addStreamController(MENU);
    addStreamController(MAPS);
  }

  @override
  void intiView(HomeView baseView) {
    this.view = baseView;
    // view.showMess(mess)
  }

  getKeyList(index) {
    return index == 0
        ? NAV1
        : index == 1
            ? NAV2
            : index == 2
                ? NAV3
                : "key";
  }

  void getMods() {
    getSink(MENU).add(new BlocLoaded(currentIndex));
    getSink(MAPS).add(new BlocLoading());
    viewModel.data = Common.dataMaps;
    // fetchModsAPI().then((value) {
    //   if (value["maps"].length > 500) {
    //     viewModel.data = value["maps"].sublist(0, 500);
    //   } else {
    //     viewModel.data = value["maps"];
    //   }
    //   for (var item in viewModel.data) {
    //     item["status"] = false; // trạng thái khoá
    //   }
    //   for (var i = 0; i < 5; i++) {
    //     viewModel.data[i]["status"] = true; // 5 phần từ đầu trạng thái mở khoá
    //   }
    getSink(MAPS).add(new BlocLoaded(
        {"key": getKeyList(currentIndex), "value": viewModel.data}));
    isLoadData = true;
    // }).catchError((onError) => {getSink(MAPS).add(new BlocFailed(""))});
  }

  Future<List<String>> getFavorite() async {
    final SharedPreferences prefs = await _prefs;
    List<String> _list = prefs.getStringList('idMaps') ?? [];
    dynamic lf = [];
    for (var item in _list) {
      dynamic data = viewModel.data.firstWhere((itm) => itm["id"] == item);
      lf.add(data);
    }
    getSink(MAPS)
        .add(new BlocLoaded({"key": getKeyList(currentIndex), "value": lf}));
  }

  void setFavorite(listMaps) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList("idMaps", listMaps).then((bool success) {
      return listMaps;
    }).catchError((onError) {
      return [];
    });
  }

  void setMenu(value) {
    currentIndex = value;
    switch (currentIndex) {
      case 0:
        getSink(MENU).add(new BlocLoaded(currentIndex));
        getSink(MAPS).add(new BlocLoaded(
            {"key": getKeyList(currentIndex), "value": viewModel.data}));
        break;
      case 1:
        if (isLoadData) {
          getSink(MENU).add(new BlocLoaded(currentIndex));
          getFavorite();
        }
        break;
      case 2:
        getSink(MENU).add(new BlocLoaded(currentIndex));
        getSink(MAPS).add(
            new BlocLoaded({"key": getKeyList(currentIndex), "value": []}));
        break;
      case 3:
        view.share();
        break;
      default:
    }
  }

  void updateMods() {
    Common.dataMaps.forEach((e) => e["status"] = true);
  }
}
