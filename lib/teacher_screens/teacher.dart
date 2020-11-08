import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schoolapp/colors.dart';
import 'package:schoolapp/student_screens/timetable.dart';
import 'package:schoolapp/teacher_screens/TeacherMeeting.dart';

import 'package:schoolapp/teacher_screens/attendance.dart';
import 'package:schoolapp/teacher_screens/fileserver.dart';
import 'package:schoolapp/teacher_screens/marks.dart';
import 'package:schoolapp/teacher_screens/remarks.dart';
import 'package:schoolapp/teacher_screens/teacherUserProfile.dart';
import 'package:schoolapp/teacher_screens/timetable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../teacher_screens/notification.dart';

class TeacherHome extends StatefulWidget {
  @override
  _TeacherHomeState createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool attendenceMarked = false;
  String name;
  String _class;
  String section;
  String id;
  String schoolCode;
  List<String> subjects;
  String imagePath;
  @override
  void initState() {
    super.initState();
    initialiseVariables();
  }

  Widget _icon(IconData icon, {Color color = Colors.white}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color: darkblue,
          boxShadow: [
            new BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
            ),
          ]),
      child: Icon(
        icon,
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: offwhite,
        //  drawer: drawer,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(h / 4),
          child: Stack(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                        "Hi, " + name + "!",
                        style: TextStyle(color: darkpurple, fontSize: 24),
                      ),
                actions: <Widget>[
                  Row(
                    children: <Widget>[
                     
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TeacherUserProfile(
                                        name: name,
                                        currentClass: _class,
                                        section: section,
                                        subjects: subjects,
                                        id: id,
                                        schoolCode: schoolCode,
                                      )));
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: w / 40),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              //width: w/20,

                              child: imagePath == null
                                  ? Image.network(
                                      "https://fiverr-res.cloudinary.com/images/t_main1,q_auto,f_auto,q_auto,f_auto/gigs/50183164/original/f80714a807d09df88dc708d83941384ac5d9e6dd/draw-nice-style-cartoon-caricature-as-a-profile-picture.png",
                                      width: w / 10,
                                      height: w / 10,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(imagePath),
                                      width: w / 10,
                                      height: w / 10,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      // Container(
                      //   //  color: Colors.lightBlue,
                      //   width: 40,
                      //   margin: EdgeInsets.only(
                      //       top: 10, bottom: 5, right: w / 1.45),
                      //   child: InkWell(
                      //     onTap: () => _scaffoldKey.currentState.openDrawer(),
                      //     child: RotatedBox(
                      //       quarterTurns: 4,
                      //       child: _icon(Icons.sort, color: Colors.white),
                      //     ),
                      //   ),
                      // ),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => Student()));
                      //     //   refreshIndicatorKey.currentState.show();
                      //   },
                      //   child: Container(
                      //       margin: EdgeInsets.only(right: 30),
                      //       //color: Colors.black,
                      //       child: Icon(
                      //         Icons.refresh,
                      //         color: Colors.black,
                      //         size: 30,
                      //       )),
                      // )
                    ],
                  ),
                ],
              ),
              Container(
                width: w,
                margin: EdgeInsets.only(top: h / 10),
                child: Center(child: Image.asset('assets/th.png')),
              ),
            ],
          ),
        ),
        body: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: w / 30,
          mainAxisSpacing: w / 30,
          crossAxisCount: 2,
          children: [
            Container(
              height: h / 6,
              width: h / 6,
              child: RaisedButton(
                elevation: 0,
                color: Color(0xff4333a0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Attendance(
                                currentlass: _class,
                                id: id,
                                schoolCode: schoolCode,
                                section: section,
                              )));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: w,
                      // color: Colors.pink,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Attendance",
                            style: styleCard,
                          ),
                          Icon(Icons.pie_chart_outlined, color: Colors.white)
                        ],
                      ),
                    ),
                    Image.asset('assets/att.png')
                  ],
                ),
              ),
            ),
            Container(
              height: h / 6,
              width: h / 6,
              child: RaisedButton(
                elevation: 0,
                color: Color(0xffc3bee8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Notice(
                                id: id,
                                schooolCode: schoolCode,
                              )));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: w,
                      // color: Colors.pink,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Notice",
                            style: styleCard,
                          ),
                          Icon(Icons.note_add, color: Colors.white)
                        ],
                      ),
                    ),
                    Container(
                      //  color: Colors.pink,
                      //   padding: EdgeInsets.all(w / 30),
                      height: h / 7,
                      width: h / 6.5,
                      child: Image.asset(
                        'assets/not.png',
                        scale: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: h / 6,
              width: h / 6,
              child: RaisedButton(
                elevation: 0,
                color: dullpurple,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FileServer(
                                id: id,
                                schooolCode: schoolCode,
                              )));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: w,
                      // color: Colors.pink,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "File Server",
                            style: styleCard,
                          ),
                          Icon(Icons.perm_media, color: Colors.white)
                        ],
                      ),
                    ),
                    Container(
                      width: h / 7,
                      child: Image.asset(
                        'assets/fs.png',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: h / 6,
              width: h / 6,
              child: RaisedButton(
                elevation: 0,
                color: orange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Marks(
                                id: id,
                                schoolCode: schoolCode,
                              )));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: w,
                      // color: Colors.pink,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Marks",
                            style: styleCard,
                          ),
                          Icon(Icons.poll, color: Colors.white)
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/marks.png',
                      scale: 9.5,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: h / 5,
              width: h / 5,
              child: RaisedButton(
                color: lighterblue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SpecialRemarks(
                                id: id,
                                schoolCode: schoolCode,
                                name: name,
                              )));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: w,
                      // color: Colors.pink,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Remarks",
                            style: styleCard,
                          ),
                          Icon(Icons.add_comment, color: Colors.white)
                        ],
                      ),
                    ),
                    Container(
                      width: h / 5,
                      child: Image.asset(
                        'assets/rev.png',
                      ),
                    ),
                    //
                  ],
                ),
              ),
            ),
            Container(
              height: h / 6,
              width: h / 6,
              child: RaisedButton(
                elevation: 0,
                color: Color(0xff4333a0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewTimeTable()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: w,
                      // color: Colors.pink,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Time Table",
                            style: styleCard,
                          ),
                          Icon(Icons.calendar_today, color: Colors.white)
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/tt.png',
                      scale: 9.5,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: h / 5,
              width: h / 5,
              child: RaisedButton(
                color: dullpurple,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TeacherMeeting(
                              schoolCode: schoolCode,
                              name: name,
                            ))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: w,
                      // color: Colors.pink,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Meeting",
                            style: styleCard,
                          ),
                          Icon(Icons.video_call, color: Colors.white)
                        ],
                      ),
                    ),
                    //
                    Image.network(
                      'https://img.icons8.com/bubbles/2x/video-call.png',
                      scale: 1.7,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void initialiseVariables() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String i = pref.getString('id');
    String sc = pref.getString('schoolCode');
    String path = pref.getString('imagePath');
    String dir = (await getExternalStorageDirectory()).path;
    Directory(dir + '/notices').exists().then((value) {
      if (!value) {
        Directory(dir + '/notices').create();
      }
    });

    String n = pref.getString('name');
    if (n == null) {
      print('--------------1--------------');
      var details = await Firestore.instance
          .collection('schools')
          .document(sc)
          .collection('teacher')
          .document(i)
          .get();
      String n = details['name'];
      String c = details['class'];
      String sec = details['section'];

      List<String> sub = [];
      for (int i = 0; i < details['subjects'].length; i++) {
        sub.add(details['subjects'][i]);
      }
      pref.setString('class', c);
      pref.setString('name', n);
      pref.setString('section', sec);
      pref.setStringList('subjects', sub);

      setState(() {
        name = n;
        _class = c;
        id = i;
        subjects = sub;
        schoolCode = sc;
        section = sec;
        imagePath = path;
      });
    } else {
      String n = pref.getString('name');
      List<String> sub = pref.getStringList('subjects');
      String sec = pref.getString('section');
      String c = pref.getString('class');
      setState(() {
        name = n;
        _class = c;
        id = i;
        subjects = sub;
        schoolCode = sc;
        section = sec;
        imagePath = path;
      });
    }
  }
}
