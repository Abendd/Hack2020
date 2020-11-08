import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'middlering.dart';
import 'progressring.dart';


class NeumorphicPie extends StatelessWidget {
   double x;

   NeumorphicPie(this.x);
  @override
  Widget build(BuildContext context) {
    double p = x/100;
   
    // Outer white circle
    return Container(
      height: 290.0,
      width: 290.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white24,
      ),
      child: Center(
        // Container of the pie chart
        child: Container(
          height: 200.0,
          width: 200.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                spreadRadius: 10,
                blurRadius: 25,
                offset: Offset(0, 7), // changes position of shadow
              ),
            ],
          ),
          child: Stack(
            children: <Widget>[
              Center(child: MiddleRing(width: 300.0)),
              // Transform.rotate(
              //   angle: pi * 1.6,
              //   child: CustomPaint(
              //     child: Center(),
              //     painter: ProgressRings(
              //       completedPercentage: 0.65,
              //       circleWidth: 50.0,
              //       gradient: greenGradient,
              //       gradientStartAngle: 0.0,
              //       gradientEndAngle: pi / 3,
              //       progressStartAngle: 1.85,
              //       lengthToRemove: 3,
              //     ),
              //   ),
              // ),
              // Transform.rotate(
              //   angle: pi / 1.8,
              //   child: CustomPaint(
              //     child: Center(),
              //     painter: ProgressRings(
              //       completedPercentage: 0.20,
              //       circleWidth: 50.0,
              //       gradient: turqoiseGradient,
              //     ),
              //   ),
              // ),
              Transform.rotate(
                angle: pi / 2.6,
                child: CustomPaint(
                  child: Center(),
                  painter: ProgressRings(
                    completedPercentage: 1,
                    circleWidth: 50.0,
                    gradient: turqoiseGradient,
                    gradientStartAngle: 0,
                    gradientEndAngle: pi / 2,
                    progressStartAngle: 1.85,
                  ),
                ),
              ),
              Transform.rotate(
                angle: pi * 1.1,
                child: CustomPaint(
                  child: Center(),
                  painter: ProgressRings(
                    completedPercentage: p,
                    circleWidth: 25.0,
                    gradient: turqoiseGradient,
                    gradientStartAngle: .6,
                    gradientEndAngle: pi / 0.9,
                    progressStartAngle: 1.8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final innerColor = Color.fromRGBO(233, 242, 249, 1);
final shadowColor = Color.fromRGBO(220, 227, 234, 1);

const greenGradient = [
  Color.fromRGBO(223, 250, 92, 1),
  Color.fromRGBO(223, 250, 92, 1),
];
const turqoiseGradient = [
  Color.fromRGBO(129, 182, 215, 1),
  Color.fromRGBO(129, 182, 205, 1)
];

const redGradient = [
  Color.fromRGBO(255, 93, 91, 1),
  Color.fromRGBO(254, 154, 92, 1),
];
const orangeGradient = [
  Color.fromRGBO(251, 173, 86, 1),
  Color.fromRGBO(253, 255, 93, 1),
];