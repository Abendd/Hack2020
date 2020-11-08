import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schoolapp/student_screens/student.dart';
import 'package:schoolapp/student_screens/subjectSelection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';

class StudentProfileSetup extends StatefulWidget {
  String id;
  String type;
  String schoolCode;
  StudentProfileSetup({this.id, this.type, this.schoolCode});
  @override
  _StudentProfileSetupState createState() => _StudentProfileSetupState();
}

class _StudentProfileSetupState extends State<StudentProfileSetup> {
  String _class;
  String _name;
  String _section;
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
              child: TextFormField(
                onChanged: (val) {
                  setState(() {
                    _name = val;
                  });
                },
                autofocus: false,
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
              margin: EdgeInsets.only(top: w / 3),
              width: w / 2,
              child: RaisedButton(
                padding: EdgeInsets.all(w / 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: dullpurple,
                onPressed: () async {
                  print(widget.id);
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
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
                      .collection('parent')
                      .document(widget.id)
                      .updateData({
                    'class': _class,
                    'section': _section.toUpperCase(),
                    'name': _name
                  });

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => SetSubjects(
                              id: widget.id,
                              schoolCode: widget.schoolCode,
                              name: _name)));
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
}
