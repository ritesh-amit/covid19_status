import 'package:covid19_status/Animations/FadeAnimation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid19_status/Components/constants.dart';
import 'package:covid19_status/Components/Networking.dart';
import 'package:covid19_status/Screens/countryScreen.dart';
import 'package:covid19_status/Components/SearchCountry.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class CountryDataScreen extends StatefulWidget {
  @override
  _CountryDataScreenState createState() => _CountryDataScreenState();
}

class _CountryDataScreenState extends State<CountryDataScreen> {
  @override
  void initState() {
    super.initState();
    getdata();
  }

  List data;
  Future getdata() async {
    var url = 'https://corona.lmao.ninja/v2/countries?sort=cases';
    Networkhelper networkhelper = Networkhelper(url);
    var countrydata = await networkhelper.getData();
    setState(() {
      data = countrydata;
    });
  }

  dataRefreshed() {
    Fluttertoast.showToast(
        msg: 'Data Refreshed!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1);
  }

  Future onRefresh() async {
    await getdata();
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
        title: Text('World Data',style:TextStyle(color:Colors.black,fontFamily: 'MeriendaOne',)),
        backgroundColor: Colors.grey[400],
        actions: <Widget>[
          Tooltip(
            message: 'Search',
            child: IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              //iconSize: 26,
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: SearchCountry(countrydata: data));
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
              backgroundColor:Colors.grey[300],
              color: Colors.black,
              onRefresh: onRefresh,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CountryScreen(
                                    data: data,
                                    index: index,
                                  )));
                    },
                    child: Card(
                      color: Colors.grey,
                      elevation:5,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(SizeConfig.b*3.83),
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
                              width: SizeConfig.b*1.28,
                            ),
                            Center(
                              child: Text(
                                '${index + 1}.',
                                style: TextStyle(
                                    fontSize: SizeConfig.b*4.6,
                                    color:Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'MeriendaOne'),
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.b*2.55,
                            ),
                            FadeAnimation(
                              1,
                            ClipRRect(
                              borderRadius: BorderRadius.circular(SizeConfig.b*1.28),
                              child: Image.network(
                                data[index]['countryInfo']['flag'],
                                height:SizeConfig.v*4.75,
                                width: SizeConfig.b*14.8,
                              ),
                            ),
                            ),
                            SizedBox(
                              width: SizeConfig.b*2.56,
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: SizeConfig.b*3.55),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FadeAnimation(
                                        1.2,
                                        Text(
                                          data[index]['country'],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: SizeConfig.b*5.1,
                                              color:Colors.black,
                                              fontFamily:'MeriendaOne'
                                              ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                              
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    FadeAnimation(
                                        1.4,
                                        Text(
                                          data[index]['cases']
                                              .toString()
                                              .replaceAllMapped(
                                                  kreg, kmathFunc),
                                          style: TextStyle(
                                            fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: SizeConfig.b*5.62,
                                              fontFamily: 'MeriendaOne',
                                              color: Colors.red),
                                        )),
                                    SizedBox(
                                      width: SizeConfig.b*2.55,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: data == null ? 0 : data.length,
              ),
            ),
    );
  }
}
