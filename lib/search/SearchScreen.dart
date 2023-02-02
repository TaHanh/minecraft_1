import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:init_app/Premium/PremiumScreen.dart';
import 'package:init_app/config.dart';
import 'package:init_app/detail/DetailScreen.dart';
import 'package:init_app/home/HomeScreen.dart';
import 'package:init_app/utils/BasePresenter.dart';
import 'package:init_app/utils/IntentAnimation.dart';
import 'SearchPresenter.dart';
import 'SearchPresenter.dart';
import 'SearchView.dart';
import 'SearchViewModel.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key, this.data, this.value}) : super(key: key);

  String value;
  dynamic data;
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> implements SearchView {
  SearchViewModel viewModel;
  SearchPresenter _presenter;
  TextEditingController controllerInput;
  @override
  void initState() {
    super.initState();
    viewModel = new SearchViewModel();
    _presenter = new SearchPresenter(viewModel);
    _presenter.intiView(this);
    _presenter.filterMods(widget.data, widget.value);
    controllerInput = new TextEditingController(text: widget.value);
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
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                decoration: new BoxDecoration(
                  color: Colors.white54,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        "assets/images/ic_back.png",
                        width: 45.0,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: TextField(
                          controller: controllerInput,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) {
                            _presenter.filterMods(widget.data, value);
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            // prefixIcon: Icon(Icons.search),
                            hintText: 'Search',
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _presenter.getStream(SearchPresenter.FILTER_MAPS),
                  builder: (ctx, snap) {
                    return snap.data is BlocLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : snap.data is BlocLoaded && snap.data.value.length > 0
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemCount: snap.data.value.length,
                                padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
                                itemBuilder: (BuildContext context, int index) {
                                  var item = snap.data.value[index];
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                                    padding: EdgeInsets.all(0),
                                    child: GestureDetector(
                                      onTap: () {
                                        pushNavigator(context, DetailScreen(data: item), () {});
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: size.width - 30.0,
                                            child: FadeInImage.assetNetwork(
                                              placeholder: "assets/images/img_not_found.png",
                                              image: Config.host +
                                                  "/addons/" +
                                                  item["id"] +
                                                  "/" +
                                                  item["images"][0]["url"],
                                              height: 200,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0.0,
                                            right: 0.0,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                                              alignment: Alignment.centerRight,
                                              color: Colors.black45,
                                              width: size.width - 30.0,
                                              child: Text(
                                                item["title"],
                                                style: TextStyle(fontSize: 18.0, color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                            : Center(
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 50.0),
                                  child: Image.asset(
                                    "assets/images/data_not_found.png",
                                    // height: 200,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void showDialog() {
    // TODO: implement showDialog
  }

  @override
  void showMess(String mess) {
    print("object");
    // TODO: implement showMess
  }

  void _search() {}
}
