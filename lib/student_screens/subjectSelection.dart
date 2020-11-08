import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schoolapp/student_screens/student.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';

class SetSubjects extends StatefulWidget {
  String id;
  String schoolCode;
  String name;
  SetSubjects({this.id, this.schoolCode, this.name});
  @override
  _SetSubjectsState createState() => _SetSubjectsState();
}

class _SetSubjectsState extends State<SetSubjects> {
  List<String> subjectsList;
  List<bool> selectedSubjects = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeVariables();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Select Subjects",
          style: TextStyle(
              color: darkblue, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: darkblue,
            ),
            onPressed: () => Navigator.pop(context)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: subjectsList == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                      itemCount: subjectsList.length,
                      itemBuilder: (context, index) {
                        return Container(
                            margin: EdgeInsets.only(
                                top: w / 20, left: w / 20, right: w / 20),
                            child: Row(children: <Widget>[
                              Container(
                                width: w / 2,
                                child: Text(
                                  subjectsList.elementAt(index),
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              Checkbox(
                                  activeColor: orange,
                                  value: selectedSubjects.elementAt(index),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedSubjects[index] = val;
                                    });
                                  })
                            ]));
                      }),
                ),
                Container(
                  width: w / 2,
                  child: RaisedButton(
                    padding: EdgeInsets.all(w / 25),
                    color: orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      List<String> finalSub = [];
                      for (int i = 0; i < subjectsList.length; i++) {
                        if (selectedSubjects[i]) {
                          finalSub.add(subjectsList[i]);
                        }
                      }
                      pref.setStringList('subjects', finalSub);

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Student()));
                    },
                    child: Text(
                      'Done',
                      style: style,
                    ),
                  ),
                )
              ],
            ),
    );
  }

  void initializeVariables() async {
    var db = await Firestore.instance
        .collection('schools')
        .document(widget.schoolCode)
        .collection('Subjects')
        .getDocuments();

    List<String> a = [];
    List<bool> b = [];
    for (int i = 0; i < db.documents.length; i++) {
      a.add(db.documents.elementAt(i).documentID);
      b.add(false);
    }
    setState(() {
      subjectsList = a;
      selectedSubjects = b;
    });
  }
}
