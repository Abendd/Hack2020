import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schoolapp/student_screens/attendance.dart';
import 'package:schoolapp/teacher_screens/noticeHistory.dart';
import 'package:schoolapp/teacher_screens/teacher.dart';
import 'package:flushbar/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';

class Notice extends StatefulWidget {
  final id;
  final schooolCode;

  const Notice({Key key, this.id, this.schooolCode}) : super(key: key);

  @override
  _NoticeState createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  String currentClass;
  String currentSection;
  TextEditingController notice = TextEditingController();
  String filename;
  File selectedFile;
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: offwhite,
        appBar: PreferredSize(
          child: Container(
            margin: EdgeInsets.only(top: w / 40, left: w / 100),
            child: AppBar(
              centerTitle: true,
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: darkpurple,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              title: Text(
                "Add Notice",
                style: TextStyle(color: darkpurple, fontSize: 24),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                  
                IconButton(
                    color: Colors.black,
                    icon: Icon(
                      Icons.history,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NoticeHistory()));
                    }),
                         IconButton(icon: Icon(Icons.info_outline,color: orange, size: 30,),tooltip: "File Size should be less than 50 KB",
                    
                    onPressed: (){
                   Flushbar(
                                  title: "Note",
                                  message: "File Size should be less than 5 MB",
                                  duration: Duration(seconds: 3),
                                  margin: EdgeInsets.all(8),
                                  borderRadius: 8,
                                )..show(context);
                    },),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(h / 10),
        ),
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                //   color: lighterblue,
                padding: EdgeInsets.all(w / 30),
                margin: EdgeInsets.all(w / 20),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    TextFormField(
                      onChanged: (value) {
                        filename = value;
                      },

                      controller: notice,
                      cursorColor: darkblue,
                      style: TextStyle(
                          color: darkblue,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          hintStyle: TextStyle(
                              color: darkblue, fontWeight: FontWeight.w400),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: darkerpurple),
                          ),
                          //  hintText: "Ans..",
                          labelText: "Add Notice Title",
                          hintText: "",
                          labelStyle: TextStyle(color: darkpurple)
                          // fillColor: Color,
                          // focusColor: darkbrown
                          ),
                      //onSaved: (value) => ans1 = value,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(""),
                        RaisedButton(
                          color: orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onPressed: () {
                            getPdfAndUpload();
                          },
                          child: Icon(Icons.add_photo_alternate,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Text(selectedFile == null
                        ? ''
                        : selectedFile.path.split('/').last)
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: h / 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: orange),
                      ),
                      padding: EdgeInsets.all(w / 40),
                      width: MediaQuery.of(context).size.width / 4,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Class',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            currentClass = val;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: orange),
                      ),
                      padding: EdgeInsets.all(w / 40),
                      width: MediaQuery.of(context).size.width / 4,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Section',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            currentSection = val;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              RaisedButton(
                padding: EdgeInsets.all(w / 30),
                color: orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: loading
                    ? () {}
                    : () async {
                        if (currentClass == null ||
                            currentSection == null ||
                            notice.text == "" ||
                            selectedFile == null) {
                          Flushbar(
                            title: "Error",
                            message: "Please enter all the fields",
                            duration: Duration(seconds: 3),
                            margin: EdgeInsets.all(8),
                            borderRadius: 8,
                          )..show(context);
                        } else {
                          setState(() {
                            loading = true;
                          });
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          String exn =
                              selectedFile.path.split('/').last.split('.').last;
                          var listNotice = pref.getStringList('NoticeList');
                          if (listNotice == null) {
                            listNotice = [];
                          }
                          listNotice.add(filename + '.' + exn);
                          pref.setStringList('NoticeList', listNotice);
                          String dir =
                              (await getExternalStorageDirectory()).path;
                          var bytes = await selectedFile.readAsBytes();

                          File noticeFile = new File(
                              dir + '/notices/' + filename + '.' + exn);
                          await noticeFile.writeAsBytes(bytes);

                          final _noticeDb = Firestore.instance
                              .collection('schools')
                              .document(widget.schooolCode)
                              .collection("fileserver")
                              .document('Notices');

                          FirebaseStorage storage = FirebaseStorage.instance;
                          StorageUploadTask task = storage
                              .ref()
                              .child(widget.schooolCode)
                              .child('notices')
                              .child(currentClass)
                              .child(filename + '.' + exn)
                              .putFile(selectedFile);
                          String url = await (await task.onComplete)
                              .ref
                              .getDownloadURL();
                          print(url);
                          _noticeDb
                              .collection(
                                  currentClass + currentSection.toUpperCase())
                              .document(url.substring(74))
                              .setData({
                            'name': filename,
                            'exn': exn,
                            'date': DateTime.now()
                          }).whenComplete(() {
                            print(
                                "------------000000000---------------------------");
                            Flushbar(
                              title: "Success",
                              message: "Notice Sent",
                              duration: Duration(seconds: 3),
                              margin: EdgeInsets.all(8),
                              borderRadius: 8,
                            )..show(context).whenComplete(() {
                                setState(() {
                                  loading = false;
                                });
                                Navigator.pop(context);
                              });
                          });
                        }
                      },
                child: Text(
                  loading ? 'Uploading..' : 'Done',
                  style: style,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future getPdfAndUpload() async {
    File file = await FilePicker.getFile(
      type: FileType.any,
    );
    setState(() {
      selectedFile = file;
    });
    //print('${file.readAsBytesSync()}');
  }

  changeSelectedCategory(String val) {
    setState(() {
      currentClass = val;
    });
  }
}
