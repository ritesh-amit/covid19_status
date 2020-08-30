import 'package:flutter/material.dart';
import 'package:covid19_status/Components/constants.dart';
import 'package:covid19_status/Components/reusableCard.dart';
import 'package:pie_chart/pie_chart.dart';

class CountryScreen extends StatefulWidget {
  final data;
  final index;
  CountryScreen({this.data,this.index});

  @override
  _CountryScreenState createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  List cdata;
  int cindex;

  @override
  void initState() {
    super.initState();
    getdata(widget.data,widget.index);
  }

  getdata(data,index){
    cdata = data;
    cindex = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        leading:IconButton(
      icon: Icon(Icons.arrow_back),
      color: Colors.black,
      onPressed: () {
        Navigator.pop(context);
      },
    ), 
        backgroundColor:Colors.grey[400],
        title: Text(cdata[cindex]['country'].toString().toUpperCase(),textAlign: TextAlign.center,style: 
        TextStyle(color:Colors.black,fontWeight: FontWeight.w800,fontSize: SizeConfig.b*5.62,fontFamily: 'MeriendaOne',),),
        actions: <Widget>[
          Tooltip(message: 'Home',
          child: IconButton(
              icon: Icon(Icons.home,
                  color: Colors.black),
                  iconSize: kIconsize,
              onPressed: (){
                Navigator.popUntil(context, (route) => route.isFirst);
                },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal:SizeConfig.b*2.55,vertical:SizeConfig.v*1.36),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.all(SizeConfig.b*1.28),
                decoration: BoxDecoration(
                   gradient: LinearGradient(
                              begin:Alignment.bottomCenter,
                              end:Alignment.topCenter,
                              colors:[
                                      Colors.black26,
                                      Colors.black12,
                                    ]  
                                  ),
                  borderRadius: BorderRadius.circular(SizeConfig.b*2.55),
                ),
                child: PieChart(
                  dataMap: {
                    'Active': double.parse(cdata[cindex]['active'].toString()),
                    'Recovered': double.parse(cdata[cindex]['recovered'].toString()),
                    'Deceased':double.parse(cdata[cindex]['deaths'].toString())
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
                      l2: cdata[cindex]['cases'].toString().replaceAllMapped(kreg, kmathFunc),
                      l3: '+ ${cdata[cindex]['todayCases']}'.toString().replaceAllMapped(kreg, kmathFunc),
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
                      l2: cdata[cindex]['active'].toString().replaceAllMapped(kreg, kmathFunc),
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
                      l2: cdata[cindex]['recovered'].toString().replaceAllMapped(kreg, kmathFunc),
                      l3: '+ ${cdata[cindex]['todayRecovered']}'.toString().replaceAllMapped(kreg, kmathFunc),
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
                      l2: cdata[cindex]['deaths'].toString().replaceAllMapped(kreg, kmathFunc),
                      l3: '+ ' + cdata[cindex]['deltadeaths'].toString().replaceAllMapped(kreg, kmathFunc),
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
                mainAxisAlignment:MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: ReusableCard(
                      l1: 'Total Tests',
                      l2: cdata[cindex]['tests'].toString().replaceAllMapped(kreg, kmathFunc),
                      l3: '',
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
          ],
        ),
      ),
    );
  }
}
