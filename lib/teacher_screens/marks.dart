import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:schoolapp/classes/studentClass.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';

class Marks extends StatefulWidget {
  final schoolCode;
  final id;

  const Marks({Key key, this.schoolCode, this.id}) : super(key: key);

  @override
  _MarksState createState() => _MarksState();
}

class _MarksState extends State<Marks> {
  String currentClass = "10 A";
  String currentSubject = "";
  String currentTest;

  TextEditingController notice = TextEditingController();

  List<String> _class = [];
  List<String> _subject = [];
  List<String> _test;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<StudentClass> students;
  int x = 0;
  Map<String, String> studentMarks;

  void initialiseSubjects() async {
    final SharedPreferences pref = await _prefs;
    List<String> sub = pref.getStringList('subjects');
    setState(() {
      _subject = sub;
      currentSubject = sub[0];
      print(_subject);
    });
  }

  List<DropdownMenuItem<String>> subjectDropdown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < _subject.length; i++) {}
    return items;
  }

  void initialiseVariables() async {
    final _classDb = Firestore.instance
        .collection('schools')
        .document(widget.schoolCode)
        .collection("classes");
    QuerySnapshot d = await _classDb.getDocuments();
    List<String> st = [];
    for (int i = 0; i < d.documents.length; i++) {
      st.add(d.documents.elementAt(i).documentID);
    }
    d = await Firestore.instance
        .collection('schools')
        .document(widget.schoolCode)
        .collection("testTypes")
        .getDocuments();
    List<String> t = [];
    for (int i = 0; i < d.documents.length; i++) {
      t.add(d.documents.elementAt(i).documentID);
    }

    print('----');
    print(widget.schoolCode);
    setState(() {
      _class = st;
      currentClass = st[0];
      _test = t;
      currentTest = t[0];
    });
  }

  List<DropdownMenuItem<String>> classDropdown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < _class.length; i++) {
      print(_class.length);
    }
    return items;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialiseSubjects();
    initialiseVariables();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return _class.length == 0
        ? Scaffold(
            body: Center(
            child: CircularProgressIndicator(),
          ))
        : Scaffold(
            backgroundColor: offwhite,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Marks",
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
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                      width: w,
                      height: h / 3.5,
                      child: Image.asset(
                        'assets/marks.png',
                        fit: BoxFit.contain,
                      )),
                  Container(
                    margin: EdgeInsets.all(w / 20),
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          //    margin: EdgeInsets.only(top: h / 10, left: w / 10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  child: Text(
                                "Class",
                                style: style3,
                              )),
                              new DropdownButton<String>(
                                items: _class.map((String value) {
                                  print(currentClass);
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                                value: currentClass,
                                onChanged: changeSelectedClass,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          //  margin: EdgeInsets.only(top: h / 10, left: w / 10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  child: Text(
                                "Subject",
                                style: style3,
                              )),
                              new DropdownButton<String>(
                                items: _subject.map((String value) {
                                  print(currentSubject);
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                                value: currentSubject,
                                onChanged: changeSelectedSubject,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          //    margin: EdgeInsets.only(top: h / 10, left: w / 10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  child: Text(
                                "Test",
                                style: style3,
                              )),
                              new DropdownButton<String>(
                                items: _test.map((String value) {
                                  print(currentTest);
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                                value: currentTest,
                                onChanged: changeSelectedTest,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(w / 15),
                    width: w / 3,
                    child: RaisedButton(
                      padding: EdgeInsets.all(w / 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: orange,
                      onPressed: loading ? (){}:() {
                        initialiseMarks();

                        setState(() {
                          x = 1;
                        });
                      },
                      child: Text(
                     loading ?  "Loading..." : "Test" ,
                        style: style,
                      ),
                    ),
                  ),
                   
                  
                     
                ],
              ),
            ),
          );
  }

  changeSelectedSubject(String val) {
    setState(() {
      currentSubject = val;
    });
  }

  changeSelectedClass(String val) {
    setState(() {
      currentClass = val;
    });
  }

  changeSelectedTest(String val) {
    setState(() {
      currentTest = val;
    });
  }
  bool loading = false;

  void initialiseMarks() async {
    setState(() {
      loading = true;
    });
    print('--');
    final _parentDb = Firestore.instance
        .collection('schools')
        .document(widget.schoolCode)
        .collection("parent")
        .getDocuments();
    QuerySnapshot d = await _parentDb;
    List<StudentClass> st = [];
    Map<String, String> m = {};

    for (int i = 0; i < d.documents.length; i++) {
      var doc = d.documents.elementAt(i);
      if (doc['class'] == currentClass.split(' ')[0] &&
          doc['section'] == currentClass.split(' ')[1]) {
        st.add(StudentClass(enrollment: doc.documentID, name: doc['name']));

        final subMarks = await Firestore.instance
            .collection('schools')
            .document(widget.schoolCode)
            .collection("parent")
            .document(doc.documentID)
            .collection('marks')
            .document(currentTest)
            .get();

        if (subMarks.exists && subMarks[currentSubject] != null) {
          m[doc.documentID] = subMarks[currentSubject];
        } else {
          m[doc.documentID] = '0';
        }
        print('----------=========');
        print(m.keys.toList());
      }
    }
      setState(() {
      loading = false;
    });

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EnterMarks(
              currentClass: currentClass,
              test: currentTest,
              studentMarks: m,
              schoolCode: widget.schoolCode,
              currentSubject: currentSubject,
              currentTest: currentTest,
              details: st),
        ));
    print('----------=======');
    print(studentMarks);
  }

  showStudents(BuildContext context, List<StudentClass> details, String subject,
      String test, Map<String, String> studentMarks) {
    print('-------------------]]]]');
    print(details);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  subject + " " + test,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: orange),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: RaisedButton(
                      padding: EdgeInsets.all(w / 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: dullpurple,
                      onPressed: () async {
                        List<String> marksToBeUploaded =
                            studentMarks.keys.toList();
                        for (int i = 0; i < marksToBeUploaded.length; i++) {
                          var a = await Firestore.instance
                              .collection('schools')
                              .document(widget.schoolCode)
                              .collection("parent")
                              .document(marksToBeUploaded[i])
                              .collection('marks')
                              .document(currentTest)
                              .get();
                          if (a.exists) {
                            Firestore.instance
                                .collection('schools')
                                .document(widget.schoolCode)
                                .collection("parent")
                                .document(marksToBeUploaded[i])
                                .collection('marks')
                                .document(currentTest)
                                .updateData({
                              currentSubject: studentMarks[marksToBeUploaded[i]]
                            });
                          } else {
                            Firestore.instance
                                .collection('schools')
                                .document(widget.schoolCode)
                                .collection("parent")
                                .document(marksToBeUploaded[i])
                                .collection('marks')
                                .document(currentTest)
                                .setData({
                              currentSubject: studentMarks[marksToBeUploaded[i]]
                            });
                          }
                        }
                        Flushbar(
                          title: "Note",
                          message: "Marks Entered ",
                          duration: Duration(seconds: 3),
                          margin: EdgeInsets.all(8),
                          borderRadius: 8,
                        )..show(context).whenComplete(() {
                            Navigator.pop(context);
                          });
                      },
                      child: Text("Upload Marks", style: styleCard)),
                )
              ],
            ),
          ),
          Container(
            height: h / 3,
            //    width: w,
            child: details.length == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: details.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(left: w / 20, right: w / 20),
                        //     color: Colors.blue,
                        // height: 40,
                        // width: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: w / 3,
                              child: Text(
                                details[index].name,
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              width: w / 5,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'marks',
                                  //   labelText: 'Name *',
                                ),
                                initialValue: studentMarks[
                                            details[index].enrollment] ==
                                        null
                                    ? '0'
                                    : studentMarks[details[index].enrollment],
                                onChanged: (value) {
                                  studentMarks[details[index].enrollment] =
                                      value;
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class EnterMarks extends StatefulWidget {
  final List<StudentClass> details;

  final test;
  final Map<String, String> studentMarks;
  final schoolCode;
  final currentTest;
  final currentClass;
  final currentSubject;

  const EnterMarks(
      {Key key,
      this.details,
      this.test,
      this.studentMarks,
      this.schoolCode,
      this.currentTest,
      this.currentClass,
      this.currentSubject})
      : super(key: key);

  @override
  _EnterMarksState createState() => _EnterMarksState(
      key: this.key,
      details: this.details,
      studentMarks: this.studentMarks,
      test: this.test);
}

class _EnterMarksState extends State<EnterMarks> {
  List<StudentClass> details;

  String test;
  Map<String, String> studentMarks;
  _EnterMarksState({
    Key key,
    this.details,
    this.test,
    this.studentMarks,
  });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('-------------------]]]]');
    print(details);
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
           actions: [
                    IconButton(icon: Icon(Icons.info_outline,color: orange,),tooltip: "",
                    
                    onPressed: (){
                   Flushbar(
                                  title: "Note",
                                  message: "Please enter marks out of 50",
                                  duration: Duration(seconds: 3),
                                  margin: EdgeInsets.all(8),
                                  borderRadius: 8,
                                )..show(context);
                    },)
                  ],
        title: Text(
          "Enter Marks",
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
      body: GestureDetector(
        onTap: () {},
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    widget.currentSubject + " " + test,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: orange),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: RaisedButton(
                        padding: EdgeInsets.all(w / 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: dullpurple,
                        onPressed: () async {
                          List<String> marksToBeUploaded =
                              studentMarks.keys.toList();
                          for (int i = 0; i < marksToBeUploaded.length; i++) {
                            var a = await Firestore.instance
                                .collection('schools')
                                .document(widget.schoolCode)
                                .collection("parent")
                                .document(marksToBeUploaded[i])
                                .collection('marks')
                                .document(widget.currentTest)
                                .get();
                            if (a.exists) {
                              Firestore.instance
                                  .collection('schools')
                                  .document(widget.schoolCode)
                                  .collection("parent")
                                  .document(marksToBeUploaded[i])
                                  .collection('marks')
                                  .document(widget.currentTest)
                                  .updateData({
                                widget.currentSubject:
                                    studentMarks[marksToBeUploaded[i]]
                              });
                            } else {
                              Firestore.instance
                                  .collection('schools')
                                  .document(widget.schoolCode)
                                  .collection("parent")
                                  .document(marksToBeUploaded[i])
                                  .collection('marks')
                                  .document(widget.currentTest)
                                  .setData({
                                widget.currentSubject:
                                    studentMarks[marksToBeUploaded[i]]
                              });
                            }
                          }
                          Flushbar(
                            title: "Note",
                            message: "Marks Entered ",
                            duration: Duration(seconds: 3),
                            margin: EdgeInsets.all(8),
                            borderRadius: 8,
                          )..show(context).whenComplete(() {
                              Navigator.pop(context);
                            });
                        },
                        child: Text("Upload Marks", style: styleCard)),
                  )
                ],
              ),
            ),
            Expanded(
              //    width: w,
              child: details.length == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: details.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(
                              left: w / 20, right: w / 20, top: w / 30),
                         
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: w / 2,
                                child: Text(
                                  details[index].name,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: w / 5,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: 'marks',
                                    //   labelText: 'Name *',
                                  ),
                                  initialValue: studentMarks[
                                              details[index].enrollment] ==
                                          null
                                      ? '0'
                                      : studentMarks[details[index].enrollment],
                                  onChanged: (value) {
                                    studentMarks[details[index].enrollment] =
                                        value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
