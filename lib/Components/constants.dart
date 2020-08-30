import 'package:flutter/material.dart';
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
    //print(screenHeight);
  }
}

const kContainerColor = Color(0xff1e1d2f);
const kBackgroundColor = Color(0xff171624);
var kIconsize = SizeConfig.b*7.653;
const kSizedboxheight = 8.0;
var kHeadcontSize = SizeConfig.b*5.1;
var kTailContSize = SizeConfig.b*4.6;
var kListContainerHeight = SizeConfig.v*9.8;

const kPiechartactivecolor = Color(0xff007afe);
const kPiechartrecoveredcolor = Color(0xff08a045);
const kPiechartdeathcolor = Color(0xfff6404f);

const Color primaryColor = Color(0xff6c757d);
const Color deseasedColor = Color(0xff6d7c7e);
const Color increaseInDeseasedColor = Colors.black54;
const Color backgroundDeseasedColor = Color(0xfff6f6f7);
const Color confirmedCasescolor = Colors.red;
const Color increaseInConfirmedCasescolor = Color(0xfffa5b82);
const Color backgroundConfirmedCasesColor = Color(0xfffddfe7);
const Color activeCasesColor = Color(0xff177cff);
const Color backgroundActiveCasesColor = Color(0xffd2e7ff);
const Color recoveredColor = Color(0xff28a744);
Color increaseInRecoveryColor =Colors.green[500];
const Color backgroundRecoverevColor = Color(0xffe1f4e8);
const Color testedColor = Color(0xff4d21aa);
const Color increaseInTestedColor = Color(0xff706fc5);
const Color backgroundTestedColor = Color(0xffe3e3f4);

const kConfirmedcolor = Colors.red;
const kActivecolor = Color(0xff177cff);
//const kRecoveredcolor = Colors.green[500];
const kDeceasedcolor = Color(0xff6d7c7e);
const kTestscolor = Color(0xff4d21aa);
const kLastupdatedcolor = Color(0xffff7100);
const kSaffronColor = Color(0xffff9933);

RegExp kreg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
Function kmathFunc = (Match match) => '${match[1]},';

String bullet = "\u2022 ";
