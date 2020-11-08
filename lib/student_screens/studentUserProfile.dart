import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schoolapp/login.dart';
import 'package:schoolapp/student_screens/student.dart';
import 'package:schoolapp/student_screens/subjectssEdit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';

class StudentUserProfile extends StatefulWidget {
  final name;
  final currentClass;
  final section;
  final subjects;
  final schoolCode;
  final id;
  const StudentUserProfile(
      {Key key,
      this.name,
      this.currentClass,
      this.section,
      this.subjects,
      this.schoolCode,
      this.id})
      : super(key: key);

  @override
  _StudentUserProfileState createState() => _StudentUserProfileState();
}

class _StudentUserProfileState extends State<StudentUserProfile> {
  String timetablePath = 'NotAvailable';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      timetablePath = prefs.getString('timetablePath');
    });
  }

  String newName = '';
  String newClass = '';
  String newSection = '';
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Update Profile",
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
            SizedBox(
              height: h / 20,
            ),
            Row(
              children: [
                Container(
                    width: w/1.3,
                  margin: EdgeInsets.all(w / 25),
                  child: Text(
                     widget.name,
              
                  ),
                ),

              ],
            ),
            Row(
              children: [
                Container(
                     width: w/1.3,
                  margin: EdgeInsets.all(w / 25),
                  child: Text(widget.currentClass
                   
                  ),
                ),
              
              ],
            ),
            Row(
              children: [
                Container(
                    width: w/1.3,
                  margin: EdgeInsets.all(w / 25),
                  child: Text(
                    widget.section,
                    
                  ),
                ),
              
              ],
            ),
            Container(
              //   color: Colors.blue,
              height: h / 10,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.subjects.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: w / 3,
                      padding: EdgeInsets.all(w / 85),
                      //  margin: EdgeInsets.all(w / 35),

                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              widget.subjects[index],
                              style: style2,
                            ),
                          ]),
                    );
                  }),
            ),
            SizedBox(
              height: h / 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: w / 2,
                  padding: EdgeInsets.all(w / 35),
                  margin: EdgeInsets.all(w / 35),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: orange,
                  ),
                  child: RaisedButton(
                    color: Colors.transparent,
                    elevation: 0,
                    onPressed: () async {
try {
    File file = await FilePicker.getFile(
                        type: FileType.custom,
                        allowedExtensions: ['jpg'],
                      );
                       
                   
                        var bytes = await file.readAsBytes();
                      String dir = (await getExternalStorageDirectory()).path;
                      String filename = 'dp.jpg';
                      File dp = new File('$dir/$filename');
                      print('====');
                      print('$dir/$filename');
                      await dp.writeAsBytes(bytes);
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.setString('imagePath', '$dir/$filename');
                       Flushbar(
                        
                          title: "Success",
                          message: "Profile Picture Uploaded",
                          duration: Duration(seconds: 3),
                          margin: EdgeInsets.all(8),
                          borderRadius: 8,
                        )..show(context).whenComplete(() {
                            Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Student()),
                          (Route<dynamic> route) => false,
                        );
                        });
  
} catch (e) {
  print("error");
}

                    
                    
                    },
                    child: Text(
                      'Set Profile Picture',
                      style: styleCard,
                    ),
                  ),
                ),
             
              ],
            ),
            SizedBox(
              height: h / 30,
            ),
            Container(
              width: w,
              padding: EdgeInsets.all(w / 35),
              margin: EdgeInsets.all(w / 35),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                // color: dullpurple,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    padding: EdgeInsets.all(w / 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: dullpurple,
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.setBool('signedIn', null).whenComplete(() {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Login()),
                            (Route<dynamic> route) => false);
                      });
                    },
                    child: Text(
                      'Logout',
                      style: styleCard,
                    ),
                  ),
                  RaisedButton(
                    padding: EdgeInsets.all(w / 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: dullpurple,
                    //  color: Colors.transparent,
                    elevation: 0,
                    onPressed: () async {


                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      if (newName != '' && newName != widget.name) {
                        pref.setString('name', newName);
                        print(widget.id);
                        Firestore.instance
                            .collection('schools')
                            .document(widget.schoolCode)
                            .collection('parent')
                            .document(widget.id)
                            .updateData({'name': newName});
                      }
                      if (newClass != '' && newClass != widget.currentClass) {
                      
                        pref.setString('class', newClass);
                        Firestore.instance
                            .collection('schools')
                            .document(widget.schoolCode)
                            .collection('parent')
                            .document(widget.id)
                            .updateData({'class': newClass});
                      }
                      if (newSection != '' && newSection != widget.section) {
                        pref.setString('section', newSection.toUpperCase());
                        Firestore.instance
                            .collection('schools')
                            .document(widget.schoolCode)
                            .collection('parent')
                            .document(widget.id)
                            .updateData({'section': newSection.toUpperCase()});
                      }

                      if (newName == "" && newClass == "" && newSection == "") {
                        Flushbar(
                          title: "Note",
                          message: "No Student Details changed ",
                          duration: Duration(seconds: 3),
                          margin: EdgeInsets.all(8),
                          borderRadius: 8,
                        )..show(context).whenComplete(() {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => Student()),
                                (Route<dynamic> route) => false);
                          });
                      } else {
                        Flushbar(
                          title: "Note",
                          message: "Student info changed ",
                          duration: Duration(seconds: 3),
                          margin: EdgeInsets.all(8),
                          borderRadius: 8,
                        )..show(context).whenComplete(() {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => Student()),
                                (Route<dynamic> route) => false);
                          });
                      }
                    },
                    child: Text(
                      'Done',
                      style: styleCard,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
