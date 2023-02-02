//class to handle event of user from screen and excution
import 'package:init_app/api/mods.dart';
import 'package:init_app/search/SearchView.dart';
import 'package:init_app/utils/BasePresenter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/BasePresenter.dart';
import 'SearchViewModel.dart';

class SearchPresenter<V extends SearchView> extends BasePresenter<V> {
  SearchView view;
  SearchViewModel viewModel;
  static final String FILTER_MAPS = "FILTER_MAPS";
  int currentIndex = 0;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  SearchPresenter(this.viewModel) : super() {
    addStreamController(FILTER_MAPS);
  }

  @override
  void intiView(SearchView baseView) {
    this.view = baseView;
  }

  void filterMods(data, value) {
    getSink(FILTER_MAPS).add(new BlocLoading());
    dynamic list = [];
    print(data.length.toString());
    if (value != "")
      for (var item in data) {
        if (item["title"].toLowerCase().contains(value.toLowerCase())) {
          list.add(item);
        }
      }
    // dynamic a = data.where((x) => x["title"].toLowerCase().contains(value.toLowerCase())).toList();
    // print(a.length);

    getSink(FILTER_MAPS).add(new BlocLoaded(list));
  }

  Future<List<String>> getFavorite() async {
    final SharedPreferences prefs = await _prefs;
    List<String> _list = prefs.getStringList('idMaps') ?? [];
    return _list;
  }

  void setFavorite(listMaps) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList("idMaps", listMaps).then((bool success) {
      return listMaps;
    }).catchError((onError) {
      return [];
    });
  }
}
