import 'dart:convert';
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schoolapp/main.dart';
import 'package:schoolapp/colors.dart';
import 'package:schoolapp/student_screens/student.dart';
import 'package:schoolapp/teacher_screens/teacher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Attendance extends StatefulWidget {
  final currentlass;
  final section;
  final schoolCode;
  final id;
  const Attendance(
      {Key key, this.currentlass, this.section, this.schoolCode, this.id})
      : super(key: key);

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  //Defining variables
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<List<String>> students;

  DateTime date = DateTime.now();

  //Initiallizing database refrence to fetch students details

  @override
  void initState() {
    super.initState();
    //funtion to get all values
    initialiseVariables();
  }

  //funtion to get all details from firebase
  void initialiseVariables() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var setDate = pref.getString('attDate');
    if (setDate != null && DateTime.now().day.toString() == setDate) {
      Flushbar(
        title: "Success",
        message: "Attendance Already Uploaded",
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(8),
        borderRadius: 8,
      )..show(context);
      List<String> attendanceDetails = pref.getStringList('attendanceDetails');
      final _parentDb = Firestore.instance
          .collection('schools')
          .document(widget.schoolCode)
          .collection("parent");
      // final SharedPreferences prefs = await _prefs;
      //  if (prefs.getBool('FirstTime') == null) {
      QuerySnapshot d = await _parentDb.getDocuments();
      List<List<String>> st = [];
      Map<String, List<List<String>>> content = {};
      for (int i = 0; i < d.documents.length; i++) {
        if (d.documents[i]['class'] == widget.currentlass &&
            d.documents[i]['section'] == widget.section) {
          bool found = false;
          for (int j = 0; j < attendanceDetails.length; j++) {
            if (attendanceDetails[j] == d.documents.elementAt(i).documentID) {
              found = true;
              break;
            }
          }
          if (found) {
            st.add([
              d.documents.elementAt(i).documentID,
              d.documents.elementAt(i)['name'],
              'Present'
            ]);
          } else {
            st.add([
              d.documents.elementAt(i).documentID,
              d.documents.elementAt(i)['name'],
              'Absent'
            ]);
          }
        }
      }
      setState(() {
        students = st;
      });
      content['students'] = st;
    } else {
      final _parentDb = Firestore.instance
          .collection('schools')
          .document(widget.schoolCode)
          .collection("parent");
      // final SharedPreferences prefs = await _prefs;
      //  if (prefs.getBool('FirstTime') == null) {
      QuerySnapshot d = await _parentDb.getDocuments();
      List<List<String>> st = [];
      Map<String, List<List<String>>> content = {};
      for (int i = 0; i < d.documents.length; i++) {
        if (d.documents[i]['class'] == widget.currentlass &&
            d.documents[i]['section'] == widget.section) {
          st.add([
            d.documents.elementAt(i).documentID,
            d.documents.elementAt(i)['name'],
            'Present'
          ]);
        }
      }
      print('---------------');
      print(st);
      setState(() {
        students = st;
      });
      content['students'] = st;
    }

    //    writeContent('studentDetails', content);
    //    prefs.setBool('FirstTime', false);
    // } else {
    //    readcontent('studentDetails');
    // }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // For your reference print the AppDoc directory
    print(directory.path);
    return directory.path;
  }

  Future<File> _localFile(String filename) async {
    final path = await _localPath;
    return File('$path/' + filename);
  }

  writeContent(filename, content) async {
    final file = await _localFile(filename + '.json');
    // Write the file
    print('1');
    file.writeAsStringSync(json.encode(content));
  }

  readcontent(filename) async {
    final file = await _localFile(filename + '.json');

    // Read the file
    file.readAsString().then((value) {
      Map<String, dynamic> a = json.decode(value);
      List<List<String>> l = [];
      var vals = a.values.toList()[0];
      for (int i = 0; i < vals.length; i++) {
        l.add([vals[i][0], vals[i][1], vals[i][2]]);
      }
      setState(() {
        students = l;
      });
      print('---------------');
      print(l);
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return students == null
        ? SafeArea(
            child: Scaffold(
              backgroundColor: offwhite,
              body: Center(child: CircularProgressIndicator()),
            ),
          )
        : Stack(
            children: <Widget>[
              Scaffold(
                  key: _scaffoldKey,
                  backgroundColor: offwhite,
                  //   drawer: drawer,
                  appBar: AppBar(
                    centerTitle: true,
                    title: Text(
                      "Attendance",
                      style: TextStyle(
                          color: darkblue,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
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
                  body: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: h / 3.5,
                              width: h / 3.5,
                              child: RaisedButton(
                                  elevation: 0,
                                  color: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  onPressed: () {},
                                  child: Image.asset('assets/at.png')),
                            ),
                            Container(
                              height: h / 7,
                              width: h / 7,
                              child: RaisedButton(
                                elevation: 0,
                                color: orange,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                onPressed: () {},
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Total",
                                      style: style,
                                    ),
                                    Text(
                                      students.length.toString(),
                                      style: TextStyle(
                                          fontSize: 26, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          //wrap with column
                          children: <Widget>[
                            Container(
                              height: h / 1.8,
                              child: ListView.builder(
                                itemCount: students.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: checkbox(
                                      students.elementAt(index),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              Container(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  padding: EdgeInsets.all(w / 40),
                  color: orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onPressed: () async {
                    List<List<String>> absentees = [];
                    for (int i = 0; i < students.length; i++) {
                      if (students[i][2] == 'Absent') {
                        absentees.add(students[i]);
                      }
                    }
                    showAlertDialog(context, absentees);
                  },
                  child: Text("Confirm",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              )
            ],
          );
  }

  //CheckBox widget For marking Attendence
  checkbox(List<String> details) {
    return CheckboxListTile(
      title: Text(
        details[1],
        style: TextStyle(
            color: darkblue, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      activeColor: darkblue,
      value: details[2] == 'Present' ? true : false,
      onChanged: (newValue) {
        setState(() {
          if (newValue) {
            details[2] = 'Present';
          } else {
            details[2] = 'Absent';
          }
        });
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );
  }

  //Alert Dialog box to show the attendence marked by the teacher
  showAlertDialog(BuildContext context, List<List<String>> details) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    AlertDialog alert = AlertDialog(
      scrollable: true,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text("Absentees",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      content: GestureDetector(
        onTap: () {},
        child: Column(
          children: <Widget>[
            Container(
              height: h * 0.7,
              width: w,
              child: details.length == 0
                  ? Container(
                      //     color: Colors.blue,
                      height: 40,
                      width: 30,
                      child: Text(
                        'No One Absent',
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ))
                  : ListView.builder(
                      itemCount: details.length,
                      itemBuilder: (context, index) {
                        return Container(
                            //     color: Colors.blue,
                            height: 40,
                            width: 30,
                            child: Text(
                              details[index][1],
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ));
                      }),
            ),
            Container(
              //  margin: EdgeInsets.only(top:400),
              child: RaisedButton(
                color: orange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onPressed: () async {
                  //funciton to set all values at firebase database
                  //storing present date
                  var date = DateTime.now().day.toString() +
                      '-' +
                      DateTime.now().month.toString() +
                      '-' +
                      DateTime.now().year.toString();

                  //looping through all the details and creating a map to store if student is present or not
                  //and then uploading values to firebase
                  for (int i = 0; i < students.length; i++) {
                    Map<String, bool> att = {
                      'att': students[i][2] == 'Present' ? true : false
                    };
                    final _parentDb = Firestore.instance
                        .collection('schools')
                        .document(widget.schoolCode)
                        .collection("parent");
                    _parentDb
                        .document(students[i][0])
                        .collection('attendance')
                        .document(date.toString())
                        .setData(att);
                  }
                  //Setting the variable attDate so that next time when we try to mark attendance it shows already marked
                  final SharedPreferences prefs = await _prefs;
                  prefs.setString('attDate', DateTime.now().day.toString());
                  List<String> details = [];
                  for (int i = 0; i < students.length; i++) {
                    if (students[i][2] == 'Present') {
                      details.add(students[i][0]);
                    }
                  }
                  prefs.setStringList('attendanceDetails', details);
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => TeacherHome()),
                      (Route<dynamic> route) => false);
                },
                child: Text("Submit",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
      actions: [
        // okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
