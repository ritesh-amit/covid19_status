import 'package:covid19_status/Components/DistrictModel.dart';
import 'package:flutter/material.dart';
import 'package:covid19_status/Components/constants.dart';
import 'package:covid19_status/Components/reusableCard.dart';
import 'package:pie_chart/pie_chart.dart';


class DistrictScreen extends StatefulWidget {
  final distdata;
  final dname;
  DistrictScreen({this.distdata,this.dname});

  @override
  _DistrictScreenState createState() => _DistrictScreenState();
}

class _DistrictScreenState extends State<DistrictScreen> {

  List<CityData> listOfCityData = [];

  @override
  void initState() {
    super.initState();
  getdata(widget.distdata,widget.dname);
  }
int dindex;
  getdata(distdata,dname){
    listOfCityData = distdata;
    for(int a = 0;a< listOfCityData.length;a++){
      if(listOfCityData[a].district == dname){
      
        dindex = a;
        
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.grey[50],
      appBar: AppBar(
        leading:IconButton(
      icon: Icon(Icons.arrow_back),
      color: Colors.black,
      onPressed: () {
        Navigator.pop(context);
      },
    ), 
        backgroundColor:Colors.grey[400],
        title: Text(listOfCityData[dindex].district.toUpperCase(),
        style:TextStyle(color:Colors.black,fontFamily: 'MeriendaOne',)
          ),
        actions: <Widget>[
          Tooltip(message: 'Home',
          child: IconButton(
              icon: Icon(Icons.home,
                  color: Colors.black),
              onPressed: (){
                Navigator.popUntil(context, (route) => route.isFirst);
                },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.b*2.55,vertical:SizeConfig.v*1.36),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.all(SizeConfig.b*1.28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                              begin:Alignment.topCenter,
                              end:Alignment.bottomCenter,
                              colors:[
                                      Colors.blueGrey[200],
                                      Colors.blueGrey[50]
                                      ]  
                                      ),
                  borderRadius: BorderRadius.circular(SizeConfig.b*4.1),
                ),
                child: PieChart(
                  dataMap: {
                    'Active': double.parse(listOfCityData[dindex].active),
                    'Recovered': double.parse(listOfCityData[dindex].recovered),
                    'Deceased':double.parse(listOfCityData[dindex].deceased)
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
                      l2: listOfCityData[dindex].confirmed.replaceAllMapped(kreg, kmathFunc),
                      l3: '+ '+listOfCityData[dindex].delta.confirmed.toString().replaceAllMapped(kreg, kmathFunc),
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
                      l2: listOfCityData[dindex].active.replaceAllMapped(kreg, kmathFunc),
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
                      l2: listOfCityData[dindex].recovered.replaceAllMapped(kreg, kmathFunc),
                      l3: '+ '+listOfCityData[dindex].delta.recovered.toString().replaceAllMapped(kreg, kmathFunc),
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
                      l2: listOfCityData[dindex].deceased.replaceAllMapped(kreg, kmathFunc),
                      l3: '+ '+listOfCityData[dindex].delta.deceased.toString().replaceAllMapped(kreg, kmathFunc),
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

    

          ],
        ),
      ),
    );
  }
}