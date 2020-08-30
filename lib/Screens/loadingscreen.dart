import 'dart:async';
import 'package:covid19_status/Components/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid19_status/Screens/homescreen.dart';

class SizeConfig 
{
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double b;
  static double v;

  void init(BuildContext context){
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    b=screenWidth/100;
    v=screenHeight/100;
  }
}

class Loadingscreen extends StatefulWidget {
  @override
  _LoadingscreenState createState() => _LoadingscreenState();
}

class _LoadingscreenState extends State<Loadingscreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds:4);

    return Timer(duration, route);
  }

  void route() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Homescreen()));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); 
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 3,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Container(
                      child: Image.asset(
                        'images/ab2.jpg',
                        height: SizeConfig.v*23.1,
                        width:SizeConfig.b*51.1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.b*3.83,
                  ),
                  Text(
                    'Covid-19 INDIA',
                    style: TextStyle(
                      fontSize: SizeConfig.b*7.56,
                      color: Colors.white,
                      fontFamily: 'MeriendaOne',
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: SizeConfig.v*1.36),
                  ),
                 
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Developed With Basics',
                    style: TextStyle(
                      fontSize: SizeConfig.b*4.6,
                      fontFamily: 'MeriendaOne',
                    ),
                  ),
                  SizedBox(
                    height:SizeConfig.v*0.677,
                  ),
                  Text(
                    'By Lucifer',
                    style: TextStyle(
                      fontSize: SizeConfig.b*6.4,
                      fontFamily: 'MeriendaOne',
                      fontWeight:FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: SizeConfig.v*4.065),
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
