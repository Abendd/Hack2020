import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_icons/flutter_icons.dart';

import 'package:schoolapp/colors.dart';
import 'package:schoolapp/student_screens/student.dart';
import 'package:schoolapp/teacher_screens/teacher.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String schoolCode;
  String dropdownValue = 'Teacher';
  bool _obscureText = true;
  String id;
  String pwd;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              dullpurple,
              Color(0xff427fdb),
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: h / 8,
            ),
            Text(
              'edDox',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 54,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: h / 10),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                          top: h / 15,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'I am ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 24),
                            ),
                            SizedBox(
                            height: w / 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      dropdownValue = "Teacher";
                                    });
                                    print("--------111111100000001111");
                                    print(dropdownValue);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(w/60),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: dropdownValue!="Teacher"?Colors.grey[400]: dullpurple,
                                    ),
                                    child: Text("Teacher",style: style,),
                                  ),
                                ),
                                          GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      dropdownValue = "Student";
                                    });
                                     print("--------2222222222222222222222");
                                    print(dropdownValue);
                                  },
                                  child: Container(
                                     padding: EdgeInsets.all(w/60),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: dropdownValue!="Student"?Colors.grey[400]: dullpurple,
                                    ),
                                    child: Text("Student",style: style,),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(40),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(50, 85, 168, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10))
                              ]),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200]))),
                                child: TextField(
                                  onChanged: (val) {
                                    schoolCode = val;
                                  },
                                  decoration: InputDecoration(
                                      hintText: "School Code",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200]))),
                                child: TextField(
                                  onChanged: (val) {
                                    setState(() {
                                      id = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Enrollment Number",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200]))),
                                child: TextField(
                                  onChanged: (val) {
                                    setState(() {
                                      pwd = val;
                                    });
                                  },
                                  obscureText: _obscureText,
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                          icon: _obscureText
                                              ? Icon(Entypo.eye)
                                              : Icon(Entypo.eye_with_line),
                                          onPressed: _toggle),
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: loading ? () {} : _login,
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: 30, left: 40, right: 40),
                          child: Container(
                            height: h / 15,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: dullpurple,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              !loading ? 'Sign In' : "Loading...",
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText ? _obscureText  = false : _obscureText =true;
    });
  }

  _login() async {
    setState(() {
      loading = true;
    });
    print('1');
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (dropdownValue == 'Student') {
      DocumentSnapshot docsnap = await Firestore.instance
          .collection('schools')
          .document(schoolCode)
          .collection('parent')
          .document(id)
          .get();

      if (docsnap.exists && docsnap['pwd'] == pwd) {
        pref.setString('type', dropdownValue);
        pref.setString('schoolCode', schoolCode);
        pref.setString('id', id);
        pref.setBool('signedIn', true);
        setState(() {
          loading = false;
        });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Student()));
      } else {
        setState(() {
          loading = false;
        });
        Flushbar(
          title: "Error",
          message: "Wrong Credentials",
          duration: Duration(seconds: 3),
          margin: EdgeInsets.all(8),
          borderRadius: 8,
        )..show(context);
      }
    } else if (dropdownValue == 'Teacher') {
      DocumentSnapshot docsnap = await Firestore.instance
          .collection('schools')
          .document(schoolCode)
          .collection('teacher')
          .document(id)
          .get();
      print('--------');
      // print(docsnap['deviceId']);

      if (docsnap.exists && docsnap['pwd'] == pwd) {
        pref.setString('type', dropdownValue);
        pref.setString('schoolCode', schoolCode);
        pref.setString('id', id);
        pref.setBool('signedIn', true);
        setState(() {
          loading = false;
        });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => TeacherHome()));
      } else {
        setState(() {
          loading = false;
        });
        Flushbar(
          title: "Error",
          message: "Wrong Credentials",
          duration: Duration(seconds: 3),
          margin: EdgeInsets.all(8),
          borderRadius: 8,
        )..show(context);
      }
    }
  }
}
