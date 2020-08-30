import 'dart:async';
import 'package:covid19_status/Animations/FadeAnimation.dart';
import 'package:covid19_status/Screens/history.dart';
import 'package:covid19_status/Screens/worlddata.dart';
import 'package:covid19_status/Components/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid19_status/Components/reusableCard.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:covid19_status/Screens/State_Data.dart';
import 'package:covid19_status/Components/Networking.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

class Homescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List abc;
  DateTime currentBackPressTime;
  Map data;
  String dateFormat;
  var deltaconfirmed;
  var deltadeceased;
  var deltarecovered;
  DateTime mdate;
  String timeFormat;

  @override
  void initState() {
    super.initState();
    getdata();
    Timer(new Duration(seconds: 5), () {
      connectivity();
    });
  }

  noConnectionAvailable() {
    Fluttertoast.showToast(
        msg: 'Check your INTERNET then press HISTORY button to Refresh',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1);
  }

  Future getdata() async {
    var url = 'https://api.covid19india.org/data.json';
    Networkhelper networkhelper = Networkhelper(url);
    var countrydata = await networkhelper.getData();
    setState(() {
      data = countrydata;
    });
    mdate = DateFormat('dd/MM/yyyy HH:mm')
        .parse(data['statewise'][0]['lastupdatedtime']);
    dateFormat = DateFormat("dd MMM yyyy").format(mdate);
    timeFormat = DateFormat("hh:mm a").format(mdate);
    deltaconfirmed = int.parse(data['statewise'][0]['deltaconfirmed']) <= 0
        ? '♥'
        : data['statewise'][0]['deltaconfirmed'];
    deltarecovered = int.parse(data['statewise'][0]['deltarecovered']) <= 0
        ? '♥'
        : data['statewise'][0]['deltarecovered'];
    deltadeceased = int.parse(data['statewise'][0]['deltadeaths']) <= 0
        ? '♥'
        : data['statewise'][0]['deltadeaths'];
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

  onRefreshed() {
    getdata();
    connectivity();
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Press back again to EXIT');
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
     SizeConfig().init(context); 
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Row(
          children: <Widget>[
            Text('Covid-19 Status',style: TextStyle(color:Colors.black,fontFamily: 'MeriendaOne',),),
            Text(
              ' (INDIA)',
              style: TextStyle(color:Colors.blue,fontSize:SizeConfig.b*5.6,fontWeight: FontWeight.w800,fontFamily: 'MeriendaOne',),
            ),
          ],
        ),
        actions: <Widget>[
          Tooltip(
            message: 'History',
            child: IconButton(
              icon: Icon(Icons.history, color: Colors.black),
              onPressed: () {
                data == null
                    ? onRefreshed()
                    : Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                        return History(
                          history: data,
                        );
                      }));
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: data == null
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : WillPopScope(
              onWillPop: onWillPop,
              child: RefreshIndicator(
                onRefresh: getdata,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.b*2.51, vertical: SizeConfig.v*0.67),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.all(SizeConfig.b*1.26),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                              begin:Alignment.topLeft,
                              end:Alignment.topRight,
                              colors:[
                                      Colors.black26,
                                      Colors.black12,
                                      ]  
                                      ),
                              borderRadius: BorderRadius.circular(SizeConfig.b*2.51),
                            ),
                            child: PieChart(
                              dataMap: {
                                'Active': double.parse(
                                    data['statewise'][0]['active']),
                                'Recovered': double.parse(
                                    data['statewise'][0]['recovered']),
                                'Deceased':
                                    double.parse(data['statewise'][0]['deaths'])
                              },
                              colorList: [
                                kPiechartactivecolor,
                                kPiechartrecoveredcolor,
                                kPiechartdeathcolor,
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: ReusableCard(
                                  l1: 'Confirmed',
                                  l2: "${data['statewise'][0]['confirmed']}"
                                      .replaceAllMapped(kreg, kmathFunc),
                                  l3: '+ ' +
                                      deltaconfirmed.replaceAllMapped(
                                          kreg, kmathFunc),
                                  color:confirmedCasescolor,
                                  backgroundColor: Colors.red[200],
                                  backgroundColor1: Colors.red[100],
                                  mainTextColor:confirmedCasescolor,
                                  sideTextColor: increaseInConfirmedCasescolor,
                                ),
                              ),
                              Expanded(
                                child: ReusableCard(
                                  l1: 'Active',
                                  l2: data['statewise'][0]['active']
                                      .replaceAllMapped(kreg, kmathFunc),
                                  l3: '',
                                  color: Color(0xff177cff),
                                  backgroundColor: Colors.blue[300],
                                  backgroundColor1: Colors.blue[100],
                                  mainTextColor: activeCasesColor,
                                  sideTextColor: activeCasesColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: ReusableCard(
                                  l1: 'Recovered',
                                  l2: data['statewise'][0]['recovered']
                                      .replaceAllMapped(kreg, kmathFunc),
                                  l3: '+ ' +
                                      deltarecovered.replaceAllMapped(
                                          kreg, kmathFunc),
                                  color:Colors.green[500],
                                  backgroundColor: Colors.green[200],
                                  backgroundColor1: Colors.green[100],
                                  mainTextColor: recoveredColor,
                                  sideTextColor: increaseInRecoveryColor,
                                ),
                              ),
                              Expanded(
                                child: ReusableCard(
                                  l1: 'Deceased',
                                  l2: data['statewise'][0]['deaths']
                                      .replaceAllMapped(kreg, kmathFunc),
                                  l3: '+ ' +
                                      deltadeceased.replaceAllMapped(
                                          kreg, kmathFunc),
                                  color: kDeceasedcolor,
                                  backgroundColor: Colors.grey[400],
                                  backgroundColor1: Colors.grey[300],
                                  mainTextColor: deseasedColor,
                                  sideTextColor: increaseInDeseasedColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: ReusableCard(
                                  l1: 'Samples Tested',
                                  l2: data['tested']
                                      .last['totalsamplestested']
                                      .replaceAllMapped(kreg, kmathFunc),
                                  l3: "+ ${data['tested'].last['samplereportedtoday']}"
                                      .replaceAllMapped(kreg, kmathFunc),
                                  color: kTestscolor,
                                  backgroundColor: Colors.purple[200],
                                  backgroundColor1: Colors.purple[100],
                                  mainTextColor: testedColor,
                                  sideTextColor: increaseInTestedColor,
                                ),
                              ),
                              Expanded(
                                child: ReusableCard(
                                  l1: 'Last Updated',
                                  l2: timeFormat,
                                  l3: dateFormat,
                                  color: Colors.cyan[700],
                                  backgroundColor: Colors.cyan[200],
                                  backgroundColor1: Colors.cyan[100],
                                   mainTextColor: Colors.cyan[600],
                                  sideTextColor: Colors.cyan[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => WorldData()));
                                  },
                                  child: Container(
                                    height: SizeConfig.v*8.13,
                                    margin: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                       begin:Alignment.topLeft,
                                       end:Alignment.topRight,
                                       colors:[
                                       Colors.black45,
                                       Colors.black12
                                      ]   
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Center(
                                      child: FadeAnimation(
                                          1.4,
                                          Text(
                                            'WORLD DATA ',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color:Colors.black,
                                              fontFamily: 'MeriendaOne',
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                StateDataScreen(
                                                  statedata: data,
                                                )));
                                  },
                                  child: Container(
                                    height: SizeConfig.v*8.13,
                                    margin: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                       gradient: LinearGradient(
                                       begin:Alignment.topLeft,
                                       end:Alignment.topRight,
                                       colors:[
                                       Colors.black45,
                                       Colors.black12
                                      ]   
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Center(
                                      child: FadeAnimation(
                                          1.5,
                                          Text(
                                            'STATE DATA',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'MeriendaOne',
                                              color: Colors.black,
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
