import 'dart:async';
import 'package:covid19_status/Animations/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:covid19_status/Components/Networking.dart';
import 'package:covid19_status/Components/reusableCard.dart';
import 'package:covid19_status/Components/constants.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:covid19_status/Screens/Country_Data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

class WorldData extends StatefulWidget {
  @override
  _WorldDataState createState() => _WorldDataState();
}

class _WorldDataState extends State<WorldData> {
  @override
  void initState() {
    super.initState();
    getdata();
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

  Map worldData;
  Future getdata() async {
    var url = 'https://corona.lmao.ninja/v2/all';
    Networkhelper networkhelper = Networkhelper(url);
    var worlddata = await networkhelper.getData();
    setState(() {
      worldData = worlddata;
    });
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
            Text('Covid-19 Status',style: TextStyle(color: Colors.black,fontFamily: 'MeriendaOne',),),
            Text(
              '  (WORLD)',
              style: TextStyle(color: Colors.black,fontFamily: 'MeriendaOne',),
            ),
          ],
        ),
        ),
      backgroundColor: Colors.grey[100],
      body: worldData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.b*2.55, vertical:SizeConfig.v*0.68),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                                       begin:Alignment.topLeft,
                                       end:Alignment.topRight,
                                       colors:[
                                       Colors.grey[500],
                                       Colors.grey[300],
                                      ]   
                                      ),
                          borderRadius: BorderRadius.circular(SizeConfig.b*2.55),
                        ),
                        child: PieChart(
                          dataMap: {
                            'Active':
                                double.parse(worldData['active'].toString()),
                            'Recovered':
                                double.parse(worldData['recovered'].toString()),
                            'Deceased':
                                double.parse(worldData['deaths'].toString())
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
                              l2: worldData['cases']
                                  .toString()
                                  .replaceAllMapped(kreg, kmathFunc),
                              l3: '+ ${worldData['todayCases']}'
                                  .toString()
                                  .replaceAllMapped(kreg, kmathFunc),
                              color: kConfirmedcolor,
                              backgroundColor: Colors.red[200],
                                  backgroundColor1: Colors.red[100],
                                  mainTextColor:confirmedCasescolor,
                                  sideTextColor: increaseInConfirmedCasescolor,
                            ),
                          ),
                          Expanded(
                            child: ReusableCard(
                              l1: 'Active',
                              l2: worldData['active']
                                  .toString()
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
                              l2: worldData['recovered']
                                  .toString()
                                  .replaceAllMapped(kreg, kmathFunc),
                              l3: '+ ${worldData['todayRecovered']}'
                                  .toString()
                                  .replaceAllMapped(kreg, kmathFunc),
                               color:Color(0xff28a744),
                                  backgroundColor: Colors.green[200],
                                  backgroundColor1: Colors.green[100],
                                  mainTextColor: recoveredColor,
                                  sideTextColor: increaseInRecoveryColor,
                            ),
                          ),
                          Expanded(
                            child: ReusableCard(
                              l1: 'Deceased',
                              l2: worldData['deaths']
                                  .toString()
                                  .replaceAllMapped(kreg, kmathFunc),
                              l3: '+ ${worldData['todayDeaths']}'
                                  .toString()
                                  .replaceAllMapped(kreg, kmathFunc),
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
                    Container(
                      height: SizeConfig.v*14.8,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: ReusableCard(
                              l1: 'Total Tests',
                              l2: worldData['tests']
                                  .toString()
                                  .replaceAllMapped(kreg, kmathFunc),
                              l3:'',
                              color: kTestscolor,
                                  backgroundColor: Colors.purple[200],
                                  backgroundColor1: Colors.purple[100],
                                  mainTextColor: testedColor,
                                  sideTextColor: increaseInTestedColor,
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
                                        builder: (context) =>
                                            CountryDataScreen()));
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
                                  borderRadius: BorderRadius.circular(SizeConfig.b*2.55),
                                ),
                                child: Center(
                                  child: FadeAnimation(
                                    1.4,
                                    Text(
                                      'COUNTRY DATA',
                                      style: TextStyle(
                                        fontSize: kHeadcontSize,
                                        color:Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'MeriendaOne',
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
                  ],
                ),
              ),
            ),
    );
  }
}
