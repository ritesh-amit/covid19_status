import 'dart:async';
import 'package:covid19_status/Components/SearchDistrict.dart';
import 'package:covid19_status/Screens/districtscreen.dart';
import 'package:flutter/material.dart';
import 'package:covid19_status/Components/constants.dart';
import 'package:covid19_status/Animations/FadeAnimation.dart';
import 'package:covid19_status/Components/DistrictModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

class DistrictData extends StatefulWidget {
  final name;
  DistrictData({this.name});

  @override
  _DistrictDataState createState() => _DistrictDataState();
}

class _DistrictDataState extends State<DistrictData> {
  String dname;
  List name = [];
  List<CityData> listOfCityData;
  @override
  void initState() {
    super.initState();
    getname(widget.name);
    _fetchData();
    Timer(new Duration(seconds: 5), () {
      connectivity();
    });
  }

  connectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("connected");
      }
    } on SocketException catch (_) {
      noConnectionAvailable();
    }
  }

  noConnectionAvailable() {
    Fluttertoast.showToast(
        msg: 'Slow Internet/Not Available',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1);
  }

  getname(name) {
    dname = name;
  }

  Future<List<DistrictModel>> _fetchData() async {
    var response = await http
        .get('https://api.covid19india.org/v2/state_district_wise.json');

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<DistrictModel> listOfCovidData = items.map<DistrictModel>((json) {
        return DistrictModel.fromJson(json);
      }).toList();
      return listOfCovidData;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  dataRefreshed() {
    Fluttertoast.showToast(
        msg: 'Data Refreshed!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1);
  }

  Future onRefresh() async {
    await _fetchData();
    dataRefreshed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(
      icon: Icon(Icons.arrow_back),
      color: Colors.black,
      onPressed: () {
        Navigator.pop(context);
      },
    ), 
        backgroundColor: Colors.grey[400],
        title: Row(
          children: <Widget>[
            Flexible(
                child: Container(
                    child: Text(       
              dname,
              overflow: TextOverflow.ellipsis,
               style:TextStyle(color:Colors.black,fontFamily: 'MeriendaOne',),
            ))),
            Flexible(
                child: Container(
                    child: Text(
              ' (Districts)',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black,fontFamily: 'MeriendaOne',),
            ))),
          ],
        ),
        actions: <Widget>[
          Tooltip(
            message: 'Search',
            child: IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              iconSize: kIconsize,
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: SearchDistrict(listofCityData: listOfCityData));
              },
            ),
          ),
        ],
      ),
      backgroundColor:Colors.white,
      body: FutureBuilder<List<DistrictModel>>(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for (int j = 0; j < snapshot.data.length; j++) {
              DistrictModel covidDataModel = snapshot.data[j];
              if (covidDataModel.state == dname) {
                listOfCityData = covidDataModel.districtData;
                listOfCityData.sort((a, b) =>
                    int.parse(b.confirmed).compareTo(int.parse(a.confirmed)));

                return listOfCityData == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : RefreshIndicator(
                        backgroundColor:Colors.grey[400],
                        color: Colors.black,
                        onRefresh: onRefresh,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DistrictScreen(
                                              distdata: listOfCityData,
                                              dname: listOfCityData[index]
                                                  .district,
                                            )));
                              },
                              child: Card(
                                elevation:5,
                                color: Colors.grey,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(SizeConfig.b*3.56),
                                     gradient: LinearGradient(
                                       begin:Alignment.topLeft,
                                       end:Alignment.topRight,
                                       colors:[
                                       Colors.grey[500],
                                       Colors.grey[300],
                                      ]   
                                      ),
                                  ),
                                  height: kListContainerHeight,
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: SizeConfig.b*2.55,
                                      ),
                                      Text(
                                        '${index + 1} .',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                  fontSize: SizeConfig.b*5.63,
                                  color:Colors.black,
                                            fontFamily: 'MeriendaOne'),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        width: SizeConfig.b*43.37,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: SizeConfig.b*2.55),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            FadeAnimation(
                                                1,
                                                Text(
                                                  listOfCityData[index]
                                                      .district,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                            fontSize: SizeConfig.b*5.63,
                                            color:Colors.black,
                                                      fontFamily:
                                                          'MeriendaOne'),
                                                )),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              width: SizeConfig.b*7.653,
                                            ),
                                            FadeAnimation(
                                                1.2,
                                                Text(
                                                  listOfCityData[index]
                                                      .confirmed
                                                      .replaceAllMapped(
                                                          kreg, kmathFunc),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: SizeConfig.b*5.7,
                                                      fontFamily:
                                                          'MeriendaOne',
                                                      color: Colors.red),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: listOfCityData == null
                              ? 0
                              : listOfCityData.length,
                        ),
                      );
              }
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
