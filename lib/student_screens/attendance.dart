import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:schoolapp/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentAttendance extends StatefulWidget {
  final String schoolcode;
  final String id;
  StudentAttendance({this.id, this.schoolcode});
  @override
  _StudentAttendanceState createState() => _StudentAttendanceState();
}

class _StudentAttendanceState extends State<StudentAttendance>
    with SingleTickerProviderStateMixin {
  String enrollno;
  Map<DateTime, bool> data;
  List<DateTime> sortedDates;
  AnimationController progressController;
  Animation<double> animation;
  int currentCount;

  void initialiseVariables() async {
    print('-------------');
    print(widget.id);
    print(widget.schoolcode);
    final _parentDb = Firestore.instance
        .collection('schools')
        .document(widget.schoolcode)
        .collection("parent")
        .document(widget.id)
        .collection('attendance');
    QuerySnapshot d = await _parentDb.getDocuments();
    Map<DateTime, bool> m = {};
    int percent = 0;
    for (int i = 0; i < d.documents.length; i++) {
      var a = d.documents.elementAt(i).documentID.split('-');
      DateTime date =
          DateTime(int.parse(a[2]), int.parse(a[1]), int.parse(a[0]));
      m[date] = d.documents.elementAt(i)['att'];
      if (m[date]) {
        percent++;
      }
    }
    List<DateTime> keys = m.keys.toList();
    keys.sort((a, b) {
      return -a.compareTo(b);
    });
    progressController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animation = Tween<double>(begin: 0, end: (percent * 100 / keys.length))
        .animate(progressController)
          ..addListener(() {
            setState(() {});
          });
    progressController.forward();
    setState(() {
      data = m;
      sortedDates = keys;
      currentCount = percent;
    });
    print(sortedDates);
  }

  @override
  void initState() {
    super.initState();
    initialiseVariables();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: darkblue,
            ),
            onPressed: () => Navigator.pop(context)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Attendance',
          style: TextStyle(color: darkpurple, fontSize: 25),
        ),
      ),
      backgroundColor: offwhite,
      body: sortedDates == null
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: h / 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: h / 4,
                        width: w / 2,
                        child: RaisedButton(
                            elevation: 0,
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            onPressed: () {},
                            child: Container(
                                height: h / 3,
                                child: Image.asset(
                                  'assets/at.png',
                                  fit: BoxFit.cover,
                                ))),
                      ),
                      Container(
                        height: h / 5,
                        width: h / 5,
                        child: RaisedButton(
                          elevation: 0,
                          color: orange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          onPressed: () {},
                          child: CustomPaint(
                              foregroundPainter: CircleProgress(
                                animation.value,
                              ),
                              child: Container(
                                width: w,
                                height: w,
                                child: GestureDetector(
                                    onTap: () {
                                      if (animation.value == 80) {
                                        progressController.reverse();
                                      } else {
                                        progressController.forward();
                                      }
                                    },
                                    child: Center(
                                        child: Text(
                                      animation.value.isNaN
                                          ? '0 %'
                                          : "${animation.value.toInt()} %",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ))),
                              )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: h / 35,
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    height: h / 10,
                    width: w / 1.09,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: deepblue,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Missing Next',
                              style: style,
                            ),
                            Text(
                              (currentCount * 100 / (sortedDates.length + 1))
                                      .toInt()
                                      .toString() +
                                  "%",
                              style: style,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Attending Next', style: style),
                            Text(
                                ((currentCount + 1) *
                                            100 /
                                            (sortedDates.length + 1))
                                        .toInt()
                                        .toString() +
                                    "%",
                                style: style),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: h / 35,
                  ),
                  Expanded(
                    // draggable sheet lagani hai yaha...
                    //   height: h / 2.5,
                    //  width: w / 1.2,
                    // decoration: new BoxDecoration(
                    //     color: Colors.white,
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.grey,
                    //         blurRadius: 13.0, // soften the shadow
                    //         spreadRadius: 0.2, //extend the shadow

                    //         offset: Offset(
                    //           5.0,
                    //           5.0,
                    //         ),
                    //       ),
                    //     ],
                    //     border: Border.all(color: Colors.grey[300], width: 2),
                    //     borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            child: Text(
                              'Past Records',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        Flexible(
                          child: ListView.builder(
                              itemCount: sortedDates.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Text(
                                          sortedDates[index].day.toString() +
                                              '-' +
                                              sortedDates[index]
                                                  .month
                                                  .toString() +
                                              '-' +
                                              sortedDates[index]
                                                  .year
                                                  .toString(),
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        data[sortedDates[index]] == true
                                            ? Text(
                                                "Present",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.green),
                                              )
                                            : Text(
                                                "Absent",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.red),
                                              )
                                      ],
                                    ),
                                  ),
                                );
                              }),
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

// Container(
//                     decoration: BoxDecoration(

//                     ) ,
//                     child: Column(
//                       children: <Widget>[
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: <Widget>[
//                             Text(students[index][0]),
//                             Text(students[index][1] == "true"
//                                 ? "Present"
//                                 : "Absent")
//                           ],
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                       ],
//                     ),
//                   );

class CircleProgress extends CustomPainter {
  double currentProgress;

  CircleProgress(this.currentProgress);

  @override
  void paint(Canvas canvas, Size size) {
    //this is base circle
    Paint outerCircle = Paint()
      ..strokeWidth = 10
      ..color = Colors.grey[200]
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = 10
      ..color = dullpurple
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2.2, size.height / 2.2) - 10;

    canvas.drawCircle(
        center, radius, outerCircle); // this draws main outer circle

    double angle = 2 * pi * (currentProgress / 100);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
