import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schoolapp/teacher_screens/teacher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';

class TeacherProfileSetup extends StatefulWidget {
  final schoolCode;
  final id;
  final type;
  const TeacherProfileSetup({Key key, this.schoolCode, this.id, this.type})
      : super(key: key);

  @override
  _TeacherProfileSetupState createState() => _TeacherProfileSetupState();
}

class _TeacherProfileSetupState extends State<TeacherProfileSetup> {
  String _class;
  String _name;
  String _section;
  List<String> subjectsList;
  List<bool> selectedSubjects = [];

  @override
  void initState() {
    // TODO: implement initState
    initializeVariables();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
              color: darkblue, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(w / 40),
              margin: EdgeInsets.all(w / 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: darkerpurple)),
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    _name = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Name',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(w / 40),
              margin: EdgeInsets.all(w / 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: darkerpurple)),
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  setState(() {
                    _class = val;
                  });
                },
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Class',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(w / 40),
              margin: EdgeInsets.all(w / 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: darkerpurple)),
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    _section = val;
                  });
                },
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Section',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),
            Container(
              height: h / 3,
              margin: EdgeInsets.only(top: w / 20, left: w / 20, right: w / 20),
              child: ListView.builder(
                  itemCount: subjectsList.length,
                  itemBuilder: (context, index) {
                    return Container(
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

                  
                  String dir = (await getExternalStorageDirectory()).path;
                  new Directory(dir + '/notices').create();
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();

                  List<String> finalSub = [];
                  for (int i = 0; i < subjectsList.length; i++) {
                    if (selectedSubjects[i]) {
                      finalSub.add(subjectsList[i]);
                    }
                  }
                  pref.setStringList('subjects', finalSub);
                  pref.setString('id', widget.id);
                  pref.setString('name', _name);
                  pref.setString('class', _class);
                  pref.setString('section', _section.toUpperCase());
                  pref.setString('type', widget.type);
                  pref.setString('schoolCode', widget.schoolCode);
                  pref.setBool('signedIn', true);

                  Firestore.instance
                      .collection('schools')
                      .document(widget.schoolCode)
                      .collection('teacher')
                      .document(widget.id)
                      .updateData({
                    'class': _class,
                    'section': _section.toUpperCase(),
                    'name': _name
                  });
                  var a = await Firestore.instance
                      .collection('schools')
                      .document(widget.schoolCode)
                      .collection('classes')
                      .document(_class + ' ' + _section.toUpperCase())
                      .get();
                  if (!a.exists) {
                    Firestore.instance
                        .collection('schools')
                        .document(widget.schoolCode)
                        .collection('classes')
                        .document(_class + ' ' + _section.toUpperCase())
                        .setData({});
                  }
                      
                      if(_class.length == null || _name == null || _section ==null)
                      {
                        print("---------------111111111111------------");
                           Flushbar(
                          title: "Note",
                          message: "No info changed ",
                          duration: Duration(seconds: 3),
                          margin: EdgeInsets.all(8),
                          borderRadius: 8,
                        )..show(context).whenComplete((){
                            Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => TeacherHome()));
                        });

                      }
                      else{
    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => TeacherHome()));
                      }
              
                },
                child: Text(
                  'Done',
                  style: style,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  initializeVariables() async {
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
