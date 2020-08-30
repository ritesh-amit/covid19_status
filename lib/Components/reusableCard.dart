import 'package:covid19_status/Animations/FadeAnimation.dart';
import 'package:covid19_status/Components/constants.dart';
import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  ReusableCard({this.l1,this.l2,this.l3,this.color,this.backgroundColor,this.backgroundColor1,this.mainTextColor, 
  this.sideTextColor,});


  final String l1;
  final String l2;
  final String l3;
  final Color color;
  final Color backgroundColor;
  final Color backgroundColor1;
  final Color mainTextColor;
  final Color sideTextColor;
  
    @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
           FadeAnimation(1,Text(l1,
            style: TextStyle(
              color:color,
              fontSize: kHeadcontSize,
              fontWeight: FontWeight.w700,
              fontFamily: 'MeriendaOne',
            ),
          )),
          SizedBox(
            height: kSizedboxheight,
          ),
          FadeAnimation(1.3,Text(
            l2,
            style: TextStyle(fontWeight: FontWeight.w800,
            fontSize:SizeConfig.b*5.36,
            color:this.mainTextColor,
            fontFamily: 'MeriendaOne',
            )          
          )),
          SizedBox(
            height: kSizedboxheight,
          ),
          FadeAnimation(1.5,Text(
            l3,
            style: TextStyle(
              fontSize: kTailContSize,
              color:this.sideTextColor,
              fontWeight: FontWeight.w700,
              fontFamily: 'MeriendaOne',
            ),
          )),
        ],
      ),
      margin: EdgeInsets.all(SizeConfig.b*1),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin:Alignment.topLeft,
            end:Alignment.topRight,
            colors:[
            backgroundColor,
            backgroundColor1
            ]  
            ),
        borderRadius: BorderRadius.circular(SizeConfig.b*2.55),
      ),
    );
  }
}
