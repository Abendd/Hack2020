import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../colors.dart';
import 'barChart.dart';

class Analytics extends StatefulWidget {
  final List<String> subjectsList;
  final String id;
  final String currentClass;
  final String schoolCode;
  const Analytics(
      {Key key, this.subjectsList, this.id, this.currentClass, this.schoolCode})
      : super(key: key);

  @override
  _AnalyticsState createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  List<bool> selectedSubjects = [];
  List<String> _test;
  String currentTest;
  List<String> subjectsList;
  double mean;
  bool classwise;
  String percentile;
  double p = 0;
  int individial;
  AnimationController progressController;
  Animation<double> animation;
//  List<String> subjects = ['English'];
  void initializeVariables() async {
    List<bool> b = [];
    for (int i = 0; i < widget.subjectsList.length; i++) {
      b.add(false);
    }
    var d = await Firestore.instance
        .collection('schools')
        .document(widget.schoolCode)
        .collection("testTypes")
        .getDocuments();
    List<String> t = [];
    for (int i = 0; i < d.documents.length; i++) {
      t.add(d.documents.elementAt(i).documentID);
    }
    setState(() {
      _test = t;
      currentTest = t[0];
      subjectsList = widget.subjectsList;
      selectedSubjects = b;
    });
    print(subjectsList);
  }

  changeSelectedTest(String val) {
    setState(() {
      currentTest = val;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeVariables();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: offwhite,
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
          'Analytics',
          style: TextStyle(color: darkpurple, fontSize: 25),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(w / 15),
            child: Image.asset("assets/any.png"),
          ),
          Container(
            height: h / 8,
//color: Colors.pink,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: subjectsList.length,
                itemBuilder: (context, index) {
                  return Container(
                //    width: w / 2.5,
                    padding: EdgeInsets.only(right:w/35),
                    margin: EdgeInsets.all(w / 35),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: dullpurple,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Checkbox(
                              value: selectedSubjects.elementAt(index),
                              activeColor: orange,
                              onChanged: (val) {
                                setState(() {
                                  selectedSubjects[index]
                                      ? selectedSubjects[index] = false
                                      : selectedSubjects[index] = true;
                                });
                              }),
                          Text(
                            subjectsList.elementAt(index),
                            style: style,
                          ),
                        ]),
                  );
                }),
          ),
          SizedBox(
            height: w / 14,
          ),
          Container(
            //  color: Colors.pink,

            //   margin: EdgeInsets.only(left: w / 25,right: w/25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  width: w / 4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.transparent),
                  child: Column(
                    children: [
                      Container(
                          child: Text("Test",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500))),
                      new DropdownButton<String>(
                        items: _test.map((String value) {
                          print(currentTest);
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(
                              value,
                            ),
                          );
                        }).toList(),
                        value: currentTest,
                        onChanged: changeSelectedTest,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: w / 1.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: orange,
                  ),
                  child: RadioButtonGroup(
                    activeColor: dullpurple,
                    labelStyle: style,
                    labels: <String>[
                      "Standard-Wise",
                      "Class-Wise",
                    ],
                    onSelected: (String selected) {
                      setState(() {
                        if (selected == "Standard-Wise") {
                          classwise = true;
                        } else {
                          classwise = false;
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: w / 14,
          ),
          Container(
            height: h / 15,
            margin: EdgeInsets.only(left: w / 4, right: w / 4),
            child: RaisedButton(
              elevation: 0,
              color: dullpurple,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              onPressed: () async {
                var db = await Firestore.instance
                    .collection('schools')
                    .document(widget.schoolCode)
                    .collection('parent')
                    .getDocuments();
                double mymarks = 0;
                int percentileCount = 0;
                Firestore.instance
                    .collection('schools')
                    .document(widget.schoolCode)
                    .collection('parent')
                    .document(widget.id)
                    .collection('marks')
                    .document(currentTest)
                    .get()
                    .then((value) {
                  for (int j = 0; j < subjectsList.length; j++) {
                    if (selectedSubjects[j]) {
                      mymarks += double.parse(value.data[subjectsList[j]]);
                    }
                  }
                });
                double total = 0;
                int count = 0;
                var docs = db.documents;

                for (int i = 0; i < docs.length; i++) {
                  if (!classwise &&
                      docs.elementAt(i)['class'] ==
                          widget.currentClass.split(' ')[0] &&
                      docs.elementAt(i)['section'] ==
                          widget.currentClass.split(' ')[1].toUpperCase()) {
                    var marks = await Firestore.instance
                        .collection('schools')
                        .document(widget.schoolCode)
                        .collection('parent')
                        .document(docs.elementAt(i).documentID)
                        .collection('marks')
                        .document(currentTest)
                        .get();
                    double curr = 0;
                    if (marks.data != null) {
                      for (int j = 0; j < subjectsList.length; j++) {
                        if (selectedSubjects[j] &&
                            marks.data[subjectsList.elementAt(j)] != null) {
                          total += double.parse(
                              marks.data[subjectsList.elementAt(j)]);

                          curr += double.parse(
                              marks.data[subjectsList.elementAt(j)]);
                        }
                      }
                      count += 1;
                      if (curr < mymarks) {
                        percentileCount += 1;
                      }
                    }
                  } else if (classwise &&
                      docs.elementAt(i)['class'] ==
                          widget.currentClass.split(' ')[0]) {
                    var marks = await Firestore.instance
                        .collection('schools')
                        .document(widget.schoolCode)
                        .collection('parent')
                        .document(docs.elementAt(i).documentID)
                        .collection('marks')
                        .document(currentTest)
                        .get();

                    double curr = 0;
                    count += 1;
                    if (marks.data != null) {
                      for (int j = 0; j < subjectsList.length; j++) {
                        if (selectedSubjects[j] &&
                            marks.data[subjectsList.elementAt(j)] != null) {
                          total += double.parse(
                              marks.data[subjectsList.elementAt(j)]);

                          curr += double.parse(
                              marks.data[subjectsList.elementAt(j)]);
                        }
                      }
                      if (curr < mymarks) {
                        percentileCount += 1;
                      }
                    }
                  }
                }
                print('-----');
                print(count);

                print((percentileCount / (count - 1)).toString());

                setState(() {
                  mean = total / (count);
                  if (count == 0 || count == 1) {
                    percentile = '100';
                    p = 100;
                    print('-=');
                  } else {
                    percentile = (percentileCount * 100 / (count - 1))
                        .toInt()
                        .toString();
                    p = double.parse(percentile);
                  }

                  individial = mymarks.toInt();
                });
              },
              child: Text(
                'Get Result',
                style: style,
              ),
            ),
          ),
          percentile == null
              ? SizedBox()
              : Column(
             
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Container(
                    
                      height: h / 4,
                      width: h / 4,
                      child: CircularPercentIndicator(
                        animation: true,
                        animationDuration: 1,
                        footer:  Text("Percentile", style: style2,),
                        radius: 150.0,
                        lineWidth: 10.0,
                        percent: p / 100,
                        center: new Text(percentile + "%"),
                        progressColor: Colors.blue,
                      ),
                    ),
                 
                ],
              ),
          mean != null
              ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: h / 3,
                      width: w / 1.5,
                      child: barChart(
                        average: mean.toInt(),
                        individual: individial,

                      ),
                    ),
                    
                ],
              )
              : SizedBox(),
        ],
      ),
    );
  }
}
