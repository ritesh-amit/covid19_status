import 'package:covid19_status/Animations/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:covid19_status/Components/constants.dart';
import 'package:covid19_status/Screens/Statescreen.dart';
import 'package:covid19_status/Components/SearchState.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StateDataScreen extends StatefulWidget {
  StateDataScreen({this.statedata});
  final statedata;

  @override
  _StateDataScreenState createState() => _StateDataScreenState();
}

class _StateDataScreenState extends State<StateDataScreen> {
  Map data;
  List statelist = [];
  @override
  void initState() {
    super.initState();
    getdata(widget.statedata);
  }

  getdata(statedata) {
    data = statedata;
    for (int i = 1; i < data['statewise'].length; i++) {
      statelist.add(data['statewise'][i]['state'].toString() +
          '  ' +
          data['statewise'][i]['confirmed'].toString() +
          '  ' +
          data['statewise'][i]['statecode']);
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
    dataRefreshed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading:IconButton(
      icon: Icon(Icons.arrow_back),
      color: Colors.black,
      onPressed: () {
        Navigator.pop(context);
      },
    ), 
        title: Text('State Data',style:TextStyle(color:Colors.black,fontFamily: 'MeriendaOne',)),
        backgroundColor: Colors.grey[400],
        actions: <Widget>[
          Tooltip(
            message: 'Search',
            child: IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              iconSize: kIconsize,
              onPressed: () {
                showSearch(
                    context: context,
                    delegate:
                        SearchState(statedata: data, searchState: statelist));
              },
            ),
          ),
        ],
      ),
      body: data == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              backgroundColor: Colors.grey[300],
              color: Colors.black,
              onRefresh: onRefresh,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StateScreen(
                                  data: data,
                                  statecode: statelist[index]
                                      .toString()
                                      .split('  ')[2])));
                    },
                    child: Card(
                      color: Colors.grey,
                      elevation: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(SizeConfig.b*2.55),
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
                                  fontSize: SizeConfig.b*6.1,
                                  color:Colors.black,
                                  fontFamily: 'MeriendaOne'),
                            ),
                            SizedBox(
                              width: SizeConfig.b*2.55,
                            ),
                            Container(
                              width: SizeConfig.b*43.37,
                              margin: EdgeInsets.symmetric(horizontal:SizeConfig.b*2.55),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FadeAnimation(
                                      1,
                                      Text(
                                        statelist[index]
                                            .toString()
                                            .split('  ')[0],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: SizeConfig.b*5.4,
                                            color:Colors.black,
                                            fontFamily: 'MeriendaOne'),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: SizeConfig.b*7.653,
                                  ),
                                  FadeAnimation(
                                      1.2,
                                      Text(
                                        statelist[index]
                                            .toString()
                                            .split('  ')[1]
                                            .replaceAllMapped(kreg, kmathFunc),
                                            style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: SizeConfig.b*5.62,
                                            fontFamily: 'MeriendaOne',
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
                itemCount: data == null ? 0 : statelist.length,
              ),
            ),
    );
  }
}
