import 'package:covid19_status/Animations/FadeAnimation.dart';
import 'package:covid19_status/Components/constants.dart';
import 'package:flutter/material.dart';
import 'package:covid19_status/Components/reusableCard.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:covid19_status/Screens/districtdata.dart';
import 'package:intl/intl.dart';

class StateScreen extends StatefulWidget {
  final data;
  final statecode;
  StateScreen({this.data, this.statecode});
  @override
  _StateScreenState createState() => _StateScreenState();
}

class _StateScreenState extends State<StateScreen> {
  Map sdata;
  String scode;

  @override
  void initState() {
    super.initState();
    getdata(widget.data, widget.statecode);
  }

  DateTime mdate;
  String dateFormat;
  String timeFormat;
  getdata(data, statecode) {
    sdata = data;
    scode = statecode;
    formatTime();
    getIndex();
  }

  int acode = 0;
  getIndex() {
    for (int i = 0; i < sdata['statewise'].length; i++) {
      if (scode == sdata['statewise'][i]['statecode']) {
        acode = i;
      }
    }
  }

  formatTime() {
    mdate = DateFormat('dd/MM/yyyy HH:mm')
        .parse(sdata['statewise'][acode]['lastupdatedtime']);
    dateFormat = DateFormat("dd MMM yyyy").format(mdate);
    timeFormat = DateFormat("hh:mm a").format(mdate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading:IconButton(
      icon: Icon(Icons.arrow_back),
      color: Colors.black,
      onPressed: () {
        Navigator.pop(context);
      },
    ), 
        backgroundColor:Colors.grey[400],
        title: Text(
          sdata['statewise'][acode]['state'].toString().toUpperCase(),
          style:TextStyle(color:Colors.black,fontWeight:FontWeight.w700,fontFamily: 'MeriendaOne',),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal:SizeConfig.b*2.55, vertical: SizeConfig.v*1.356),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.all(SizeConfig.b*1.28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                              begin:Alignment.bottomRight,
                              end:Alignment.bottomLeft,
                              colors:[
                                      Colors.grey[400],
                                      Colors.grey[300]
                                      ]  
                                      ),
                  borderRadius: BorderRadius.circular(SizeConfig.b*2.55),
                ),
                child: PieChart(
                  dataMap: {
                    'Active': double.parse(sdata['statewise'][acode]['active']),
                    'Recovered':
                        double.parse(sdata['statewise'][acode]['recovered']),
                    'Deceased':
                        double.parse(sdata['statewise'][acode]['deaths'])
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
                      l2: sdata['statewise'][acode]['confirmed']
                          .replaceAllMapped(kreg, kmathFunc),
                      l3: '+ ${sdata['statewise'][acode]['deltaconfirmed']}'
                          .replaceAllMapped(kreg, kmathFunc),
                      //color: kConfirmedcolor,
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
                      l2: sdata['statewise'][acode]['active']
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
                      l2: sdata['statewise'][acode]['recovered']
                          .replaceAllMapped(kreg, kmathFunc),
                      l3: '+ ${sdata['statewise'][acode]['deltarecovered']}'
                          .replaceAllMapped(kreg, kmathFunc),
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
                      l2: sdata['statewise'][acode]['deaths']
                          .replaceAllMapped(kreg, kmathFunc),
                      l3: '+ ${sdata['statewise'][acode]['deltadeaths']}'
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
              height: SizeConfig.b*30.61,
              child: Row(
                children: <Widget>[
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
                                builder: (context) => DistrictData(
                                      name: sdata['statewise'][acode]['state'],
                                    )));
                      },
                      child: Container(
                        height:SizeConfig.v*7.5,
                        margin: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin:Alignment.topLeft,
                              end:Alignment.topRight,
                              colors:[
                                      Colors.black38,
                                      Colors.black12,
                                      ]  
                                      ),
                          borderRadius: BorderRadius.circular(SizeConfig.b*2.55),
                        ),
                        child: Center(
                          child: FadeAnimation(
                              1.4,
                              Text(
                                'District data' +
                                    ' of ' +
                                    sdata['statewise'][acode]['state']
                                        .toString(),
                                style: TextStyle(
                                  fontSize: kHeadcontSize,
                                  fontWeight: FontWeight.w500,
                                  color:Colors.black,
                                  fontFamily: 'MeriendaOne',
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
    );
  }
}
