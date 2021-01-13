import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter_app/Screen/fabbottom.dart';
// import 'package:flutter_app/Screen/hotel_details/hotel_details_screen.dart';
import 'package:flutter_app/Screen/nearby_place.dart';
import 'package:flutter_app/Screen/searchScreen.dart';
import 'package:flutter_app/Utils/AppConfig.dart';
// import 'package:flutter_app/Screen/theme.dart' as Theme;
import 'package:flutter_app/Screen/category_screen.dart';
import 'package:flutter_app/Utils/CarouselWithIndicator.dart';
import 'package:flutter_app/fetchdataapi/Model/Getcategory.dart';
import 'package:flutter_app/fetchdataapi/Model/Getsinglecategory.dart';
import 'package:flutter_app/fetchdataapi/Model/searchcity.dart';
import 'package:flutter_app/fetchdataapi/NetwrokUtils.dart';
import 'package:geocoding/geocoding.dart';
// import 'package:search_widget/search_widget.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

class home extends StatefulWidget {
  // BuildContext context;

  // home(@required this.context);

  @override
  _homeState createState() => _homeState();
}

AppConfig _appConfig;

class _homeState extends State<home> {
  final Geolocator geolocator = Geolocator();
  Position _currentPosition;
  String _currentAddress;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    networkUtil = new NetworkUtil();
    getcatdaata();
    getsearchdaata();
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress = "${place.locality}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  final fabc = 0xFFffb3b3;

  String _lastSelected = 'TAB: 0';
  final myController = TextEditingController();
  void _selectedTab(int index) {
    setState(() {
      _lastSelected = 'TAB: $index';
    });
  }

  GetsingleCatItem getsingleCatItem;

  // Main_screen({Key key}) : super(key: key);
  NetworkUtil networkUtil;
  List<GetSearchList> searchlist = new List();
  void getsearchdaata() async {
    searchlist.clear();

    await networkUtil.searchlist();

    searchlist = SearchList.searchlist;
    setState(() {});
  }

  GetSearchList _selectedItem;

  void getsubcatdaata(String pos) async {
//    print("cvcfcfcfc" + widget.index.toString());
    await networkUtil.viewplacesingle(AppConfig.userid, pos);

    getsingleCatItem = GetsingleCat.getsingleCatItem[0];
    setState(() {});
  }

  List<GetCatItem> catgorylist = new List();

  void getcatdaata() async {
    await networkUtil.homegetcat();

    catgorylist = GetCat.homeGetCatlist;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _appConfig = new AppConfig(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        // physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: _appConfig.rH(100),
          width: _appConfig.rW(100),
          child: Stack(
            // fit: StackFit.expand,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: _appConfig.rHP(30),
                  child: Stack(
                    children: <Widget>[
                      Container(
                          height: _appConfig.rHP(30),
                          width: double.infinity,
                          child: Image.asset(
                            "assets/header_bali.png",
                            fit: BoxFit.cover,
                          )),
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                margin:
                                    prefix0.EdgeInsets.fromLTRB(30, 70, 10, 0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      ' You are in ',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    if (_currentPosition != null &&
                                        _currentAddress != null)
                                      Text(_currentAddress,
                                          style:
                                              TextStyle(color: Colors.white)),
                                  ],

                                  // "You are in Denpasar,Bali",

                                  // style: prefix0.TextStyle(
                                  //     fontSize: 18, color: Colors.white),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin:
                                    prefix0.EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: Text(
                                  "Discovery",
                                  style: prefix0.TextStyle(
                                    fontSize: 40,
                                    fontFamily: 'Righteous',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _appConfig.rHP(5),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: _appConfig.rH(25),
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: _appConfig.rWP(70),
                    height: _appConfig.rHP(8),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                        child: Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            width: _appConfig.rWP(60),
                            child: new GestureDetector(
                              child: new TextField(
                                enabled: false,
                                controller: myController,

                                // textInputAction: TextInputAction.search,

                                decoration: new InputDecoration(
                                    hintText: "Search ..",
                                    border: InputBorder.none),
                              ),
                              onTap: () {
                                //Data

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => nearby_place()));
                              },
                            ),
                          ),
                        ],
                      ),
                    )),
                  ),
                ),
              ),
              Positioned(
                top: _appConfig.rH(33),
                left: 10,
                right: 10,
                child: Column(
                  children: <Widget>[
                    //Headline

                    //Grid Cinatiner
                    Container(
                      height: _appConfig.rHP(70),
                      width: double.infinity,
                      child: catgorylist.length == 0
                          ? Container(
                              child: Center(
                                  child: CircularProgressIndicator(
                                backgroundColor: Colors.tealAccent,
                                strokeWidth: 2.0,
                              )),
                            )
                          : GridView.builder(
                              /* physics: NeverScrollableScrollPhysics(),*/
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      childAspectRatio: 1.3,
                                      mainAxisSpacing: 4,
                                      crossAxisSpacing: 0.0),
                              shrinkWrap: true,
                              itemCount: catgorylist.length,
                              itemBuilder: (context, index) => Container(
                                child: Container(
                                  child: Card(
                                    elevation: 1,
                                    child: Container(
                                      height: _appConfig.rHP(10),
                                      child: GestureDetector(
                                        onTap: () => Navigator.of(context).push(
                                          PageRouteBuilder<Null>(
                                            pageBuilder: (BuildContext context,
                                                Animation<double> animation,
                                                Animation<double>
                                                    secondaryAnimation) {
                                              return AnimatedBuilder(
                                                  animation: animation,
                                                  builder:
                                                      (BuildContext context,
                                                          Widget child) {
                                                    return category_screen(
                                                        ImageWithLabel(
                                                            index, catgorylist),
                                                        catgorylist[index]
                                                            .category_id);
                                                  });
                                            },
                                          ),
                                        ),
                                        child:
                                            ImageWithLabel(index, catgorylist),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              // Positioned(
              //   top: _appConfig.rH(65),
              //   left: 10,
              //   right: 10,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: <Widget>[
              //       //Headline
              //       Padding(
              //         padding: EdgeInsets.only(left: 20),
              //         child: Text(
              //           'Special Offers',
              //           textAlign: TextAlign.left,
              //         ),
              //       ),

              //       //Scroll horizontal
              //       Container(
              //         height: _appConfig.rHP(20),
              //         width: double.infinity,
              //         child: catgorylist.length == 0
              //             ? Container(
              //                 // child: Center(
              //                 //     child: CircularProgressIndicator(
              //                 //   backgroundColor: Colors.tealAccent,
              //                 //   strokeWidth: 2.0,
              //                 // )),
              //                 )
              //             : ListView.builder(
              //                 /* physics: NeverScrollableScrollPhysics(),*/
              //                 scrollDirection: Axis.horizontal,
              //                 shrinkWrap: true,
              //                 itemCount: catgorylist.length,
              //                 itemBuilder: (context, index) => Container(
              //                   child: Container(
              //                     width: _appConfig.rWP(40),
              //                     child: Card(
              //                       elevation: 1,
              //                       child: Container(
              //                         height: _appConfig.rHP(10),
              //                         child: GestureDetector(
              //                           onTap: () => Navigator.of(context).push(
              //                             PageRouteBuilder<Null>(
              //                               pageBuilder: (BuildContext context,
              //                                   Animation<double> animation,
              //                                   Animation<double>
              //                                       secondaryAnimation) {
              //                                 return AnimatedBuilder(
              //                                     animation: animation,
              //                                     builder:
              //                                         (BuildContext context,
              //                                             Widget child) {
              //                                       return category_screen(
              //                                           ImageWithLabel(
              //                                               index, catgorylist),
              //                                           catgorylist[index]
              //                                               .category_id);
              //                                     });
              //                               },
              //                             ),
              //                           ),
              //                           child:
              //                               ImageWithLabel(index, catgorylist),
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  cardImageAsset() {}
}

class SearchLabel extends StatelessWidget {
  SearchLabel(this.index);
  final int index;
  @override
  Widget build(BuildContext context) => TextField();
}

class ImageWithLabel extends StatelessWidget {
  ImageWithLabel(this.index, this.catgorylist);

  final int index;
  List<GetCatItem> catgorylist = new List();

  @override
  Widget build(BuildContext context) => Container(
        height: _appConfig.rHP(18),
        width: _appConfig.rWP(30),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.network(
                      NetworkUtil.BASE_URL1 + catgorylist[index].category_image,
                      height: 30,
                    ),
                    // Image.network(
                    //   'https://api.travaapps.com/uploads/category/ATM.png',
                    //   height: 40.0,
                    // ),
                    SizedBox(
                      height: _appConfig.rHP(1),
                    ),
                    Text(catgorylist[index].category_name,
                        style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Lato')),
                  ],
                )),
          ),
        ),
      );

/* void searchOperation(String searchText) {
    catgorylist.clear();

    if (_isSearching != null) {
      for (int i = 0; i < _list.length; i++) {
        String data = _list[i];
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          searchresult.add(data);
        }
      }
    }
  }*/

  cardImageAsset() {}
}

class SelectedItemWidget extends StatelessWidget {
  const SelectedItemWidget(this.selectedItem, this.deleteSelectedItem);

  final GetSearchList selectedItem;
  final VoidCallback deleteSelectedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 4,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: 8,
              ),
              child: Text(
                selectedItem.place_name,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, size: 22),
            color: Colors.grey[700],
            onPressed: deleteSelectedItem,
          ),
        ],
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField(this.controller, this.focusNode);

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.search),
          border: InputBorder.none,
          hintText: "Search here...",
          contentPadding: const EdgeInsets.only(
            left: 16,
            right: 20,
            top: 14,
            bottom: 14,
          ),
        ),
      ),
    );
  }
}

class NoItemsFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.folder_open,
          size: 24,
          color: Colors.grey[900].withOpacity(0.7),
        ),
        const SizedBox(width: 10),
        Text(
          "No Items FoundS",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[900].withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class PopupListItemWidget extends StatelessWidget {
  const PopupListItemWidget(this.item);

  final GetSearchList item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(
        item.place_name,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
