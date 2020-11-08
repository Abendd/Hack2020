import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schoolapp/student_screens/student.dart';
import 'package:schoolapp/teacher_screens/teacher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';

class EditSubjects extends StatefulWidget {
  final subjects;
  final schoolCode;
  final type;
  const EditSubjects(
      {Key key, this.subjects, this.schoolCode, @required this.type})
      : super(key: key);
  @override
  _EditSubjectsState createState() => _EditSubjectsState();
}

class _EditSubjectsState extends State<EditSubjects> {
  Map<String, bool> allSubjects;

  @override
  void initState() {
    initializeVariables();
    super.initState();
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
          'Change Subjects',
          style: TextStyle(color: darkpurple, fontSize: 25),
        ),
      ),
      body: allSubjects == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: h / 20,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: allSubjects.keys.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(w / 25),
                        child: Row(
                          children: <Widget>[
                            Container(
                                width: w / 2,
                                child: Text(
                                  allSubjects.keys.elementAt(index),
                                  style: style2,
                                )),
                            Checkbox(
                                activeColor: orange,
                                value: allSubjects.values.elementAt(index),
                                onChanged: (val) {
                                  setState(() {
                                    allSubjects[allSubjects.keys
                                        .elementAt(index)] = val;
                                  });
                                })
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(w / 30),
                  width: w / 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: dullpurple,
                  ),
                  child: RaisedButton(
                    padding: EdgeInsets.all(w / 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    color: Colors.transparent,
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();

                      List<String> sub = [];
                      for (int i = 0; i < allSubjects.keys.length; i++) {
                        if (allSubjects.values.elementAt(i)) {
                          sub.add(allSubjects.keys.elementAt(i));
                        }
                      }
                      pref.setStringList('subjects', sub).whenComplete(() {
                        if (widget.type == 's') {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => Student()),
                              (Route<dynamic> route) => false);
                        } else {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => TeacherHome()),
                              (Route<dynamic> route) => false);
                        }
                      });
                    },
                    child: Text(
                      'Done',
                      style: styleCard,
                    ),
                  ),
                )
              ],
            ),
    );
  }

  initializeVariables() async {
    Map<String, bool> m = {};
    var docs = await Firestore.instance
        .collection('schools')
        .document(widget.schoolCode)
        .collection('Subjects')
        .getDocuments();
    print(widget.schoolCode);
    for (int i = 0; i < docs.documents.length; i++) {
      m[docs.documents[i].documentID] = false;
    }
    for (int i = 0; i < widget.subjects.length; i++) {
      m[widget.subjects[i]] = true;
    }
    setState(() {
      allSubjects = m;
    });
  }
}
