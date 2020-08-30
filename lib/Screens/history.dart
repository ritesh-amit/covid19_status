import 'package:covid19_status/Components/SearchDate.dart';
import 'package:flutter/material.dart';
import 'package:covid19_status/Animations/FadeAnimation.dart';
import 'package:covid19_status/Components/constants.dart';

class History extends StatefulWidget {
  History({this.history});

  final history;

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<String> cases = [];
  Map data;

  @override
  void initState() {
    getdata(widget.history);
    super.initState();
  }

  getdata(history) {
    data = history;
    for (int i = data['cases_time_series'].length - 1; i >= 0; i--) {
      cases.add(data['cases_time_series'][i]['date'].toString() +
          '  ' +
          data['cases_time_series'][i]['totalconfirmed'].toString() +
          '  (' +
          data['cases_time_series'][i]['dailyconfirmed'].toString() +
          ')');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading:IconButton(
      icon: Icon(Icons.arrow_back),
      color: Colors.black,
      onPressed: () {
        Navigator.pop(context);
      },
    ), 
        title: Text('History',style:TextStyle(color: Colors.black,fontFamily: 'MeriendaOne',)),
        backgroundColor: Colors.grey[400],
        actions: <Widget>[
          Tooltip(
            message: 'Search',
            child: IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {
                showSearch(
                    context: context, delegate: Search(dateSearch: cases));
              },
            ),
          ),
        ],
      ),
      body: data == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  elevation:10,
                  color: Colors.grey,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SizeConfig.b*3.8),
                      gradient: LinearGradient(
                                       begin:Alignment.topLeft,
                                       end:Alignment.topRight,
                                       colors:[
                                       Colors.grey[500],
                                       Colors.grey[200],
                                      ]   
                                      ),
                      ),
                    height: kListContainerHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          '${index + 1}.',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: SizeConfig.b*5,
                              fontFamily: 'MeriendaOne',
                              color:Colors.black,
                              ),
                        ),
                        SizedBox(
                          width: SizeConfig.b*0,
                        ),
                                FadeAnimation(
                                    1,
                                    Text(
                                      cases[index].toString().split('  ')[0],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: SizeConfig.b*5.2,
                                        fontFamily: 'MeriendaOne',
                                        color: Colors.black,
                                      ),
                                    )),
                         SizedBox(
                          width: SizeConfig.b*7,
                        ), 
                         
                                    FadeAnimation(
                                        1.3,
                                        Text(
                                          cases[index]
                                              .toString()
                                              .split('  ')[1]
                                              .replaceAllMapped(
                                                  kreg, kmathFunc),
                                              style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: SizeConfig.b*5.8,
                                              fontFamily: 'MeriendaOne',
                                              color: Colors.black
                                              ),
                                        )),
                                     SizedBox(
                                      width: SizeConfig.b*0,
                                     ),   
                                    FadeAnimation(
                                        1.2,
                                        Text(
                                          ' ' +
                                              cases[index]
                                                  .toString()
                                                  .split('  ')[2]
                                                  .replaceAllMapped(
                                                      kreg, kmathFunc),
                                              style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: SizeConfig.b*4.5,
                                              fontFamily: 'MeriendaOne',
                                              color: Colors.red),
                                        )),
                      ],
                    ),
                  ),
                );
              },
              itemCount: data == null ? 0 : data['cases_time_series'].length,
            ),
    );
  }
}
