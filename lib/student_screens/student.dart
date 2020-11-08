import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schoolapp/colors.dart';
import 'package:schoolapp/student_screens/attendance.dart';
import 'package:schoolapp/student_screens/studentFileserver.dart';
import 'package:schoolapp/student_screens/studentMarks.dart';
import 'package:schoolapp/student_screens/studentRemarks.dart';
import 'package:schoolapp/student_screens/studentUserProfile.dart';
import 'package:schoolapp/student_screens/timetable.dart';
import 'package:schoolapp/teacher_screens/timetable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'analytics.dart';
import 'meeting.dart';

class Student extends StatefulWidget {
  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<Student> {
  List<String> links = [];
  String _name;
  String _class;
  String _section;
  String schoolCode;
  String id;
  List<String> subjects;
  bool loading = true;
  String imagePath;
  List<List<String>> notices = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialiseVariables();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.height;
    return loading
        ? Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            appBar: PreferredSize(
              child: Container(
                margin: EdgeInsets.only(top: w / 40, left: w / 100),
                child: AppBar(
                  title: Text(
                    "Hi, " + _name + "!",
                    style: TextStyle(color: darkpurple, fontSize: 24),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewTimeTable()));

                        // MaterialPageRoute(
                        //           builder: (context) => TimeTable(

                        //               ));
                      },
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StudentUserProfile(
                                        name: _name,
                                        currentClass: _class,
                                        section: _section,
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
                                      width: w / 15,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(imagePath),
                                      width: w / 15,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              preferredSize: Size.fromHeight(h / 10),
            ),
            backgroundColor: offwhite,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: h / 50,
                ),
                Container(
                  height: h / 12,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: notices.length, //count of the notices/ message
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: () async {
                            String url = notices.elementAt(i).elementAt(2);
                            String dir =
                                (await getExternalStorageDirectory()).path;
                            String filename =
                                url.split('/').last.split('?').first;
                            OpenFile.open('$dir/$filename');
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: w / 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            height: h / 10,
                            width: w / 3,
                            child: ListTile(
                              leading: Container(
                                  padding: EdgeInsets.all(w / 60),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: orange,
                                  ),
                                  child: Icon(
                                    Icons.insert_drive_file,
                                    color: Colors.white.withOpacity(0.5),
                                  )),
                              title: Text(notices[i].elementAt(0)),
                              subtitle: Text(notices[i].elementAt(1)),
                            ),
                          ),
                        );
                      }),
                ),
                SizedBox(
                  height: h / 50,
                ),
                Expanded(
                  //   height: h/2,
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: w / 30,
                    mainAxisSpacing: w / 30,
                    crossAxisCount: 2,
                    children: [
                         Container(
                        height: h / 5,
                        width: h / 5,
                        child: RaisedButton(
                          color: Color(0xff4333a0),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StudentAttendance(
                                        schoolcode: schoolCode,
                                        id: id,
                                      ))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: w,
                                // color: Colors.pink,

                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Attendance",
                                      style: styleCard,
                                    ),
                                    Icon(Icons.pie_chart_outlined,
                                        color: Colors.white)
                                  ],
                                ),
                              ),
                              Image.asset('assets/att.png')
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: h / 5,
                        width: h / 5,
                        child: RaisedButton(
                          elevation: 0,
                          color: dullpurple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StudentFileserver(
                                        currentClass: _class,
                                        section: _section,
                                        id: id,
                                        schoolCode: schoolCode,
                                      ))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: w,
                                // color: Colors.pink,

                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                        height: h / 5,
                        width: h / 5,
                        child: RaisedButton(
                          color: Color(0xffff8788),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StudentMarks(
                                        id: id,
                                        schoolCode: schoolCode,
                                        subjects: subjects,
                                      ))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: w,
                                // color: Colors.pink,

                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Marks",
                                      style: styleCard,
                                    ),
                                    Icon(Icons.insert_chart,
                                        color: Colors.white)
                                  ],
                                ),
                              ),
                              //  https://cdn0.iconfinder.com/data/icons/business-dual-color-glyph-set-1/128/comment-512.png
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
                          color: Color(0xffc3bee8),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StudentRemarks(
                                        id: id,
                                        schoolCode: schoolCode,
                                      ))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: w,
                                // color: Colors.pink,

                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Remarks",
                                      style: new TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Icon(Icons.comment, color: Colors.white)
                                  ],
                                ),
                              ),
                              //
                              Container(
                                width: h / 5,
                                child: Image.asset(
                                  'assets/rev.png',
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
                          color: Color(0xff4333a0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TimeTable()));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: w,
                                // color: Colors.pink,

                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Time Table",
                                      style: styleCard,
                                    ),
                                    Icon(Icons.calendar_today,
                                        color: Colors.white)
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
                                  builder: (context) => MeetingLists(
                                        schoolCode: schoolCode,
                                        id: id,
                                        name: _name,
                                        currentClass: _class,
                                        currentSection: _section,
                                      ))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: w,
                                // color: Colors.pink,

                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                      Container(
                        height: h / 5,
                        width: h / 5,
                        child: RaisedButton(
                          color: Color(0xff5E809F),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Analytics(
                                        id: id,
                                        schoolCode: schoolCode,
                                        currentClass: _class + ' ' + _section,
                                        subjectsList: subjects,
                                      ))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: w,
                                // color: Colors.pink,

                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Analytics",
                                      style: styleCard,
                                    ),
                                    Icon(Icons.show_chart, color: Colors.white)
                                  ],
                                ),
                              ),
                              //
                              Container(
                                height: h / 8,
                                width: h / 8,
                                child: Image.asset(
                                  'assets/ant.png',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  void initialiseVariables() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String i = pref.getString('id');
    String sc = pref.getString('schoolCode');
    String path = pref.getString('imagePath');

    String n = pref.getString('name');
    if (n == null) {
      print('--------------1--------------');
      var details = await Firestore.instance
          .collection('schools')
          .document(sc)
          .collection('parent')
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

      var _noticeDb = Firestore.instance
          .collection('schools')
          .document(sc)
          .collection("fileserver")
          .document('Notices');
      final noticesDetails = _noticeDb.collection(c + sec).getDocuments();

      QuerySnapshot docs = await noticesDetails;
      var noticeData = docs.documents;
      noticeData.sort((a, b) {
        return -a['date'].compareTo(b['date']);
        // also not work return b['timestamp'].compareTo(a['timestamp']);
      });
      List<List<String>> l = [];
      for (int i = 0; i < noticeData.length; i++) {
        l.add([
          noticeData.elementAt(i)['name'],
          noticeData.elementAt(i)['exn'],
          'https://firebasestorage.googleapis.com/v0/b/schoolapp-315a0.appspot.com/o/' +
              noticeData.toList().elementAt(i).documentID
        ]);
        _downloadFile(
            'https://firebasestorage.googleapis.com/v0/b/schoolapp-315a0.appspot.com/o/' +
                noticeData.toList().elementAt(i).documentID);
      }

      setState(() {
        notices = l;
        _name = n;
        _class = c;
        id = i;
        subjects = sub;
        schoolCode = sc;
        loading = false;
        _section = sec;
        imagePath = path;
      });
    } else {
      print('--------------2--------------');
      String c = pref.getString('class');
      String sec = pref.getString('section');
      List<String> sub = pref.getStringList('subjects');
      var _noticeDb = Firestore.instance
          .collection('schools')
          .document(sc)
          .collection("fileserver")
          .document('Notices');
      final noticesDetails = _noticeDb.collection(c + sec).getDocuments();

      QuerySnapshot docs = await noticesDetails;
      var noticeData = docs.documents;
      noticeData.sort((a, b) {
        return -a['date'].compareTo(b['date']);
        // also not work return b['timestamp'].compareTo(a['timestamp']);
      });
      List<List<String>> l = [];
      for (int i = 0; i < noticeData.length; i++) {
        l.add([
          noticeData.elementAt(i)['name'],
          noticeData.elementAt(i)['exn'],
          'https://firebasestorage.googleapis.com/v0/b/schoolapp-315a0.appspot.com/o/' +
              noticeData.toList().elementAt(i).documentID
        ]);
        _downloadFile(
            'https://firebasestorage.googleapis.com/v0/b/schoolapp-315a0.appspot.com/o/' +
                noticeData.toList().elementAt(i).documentID);
      }

      setState(() {
        notices = l;
        _name = n;
        _class = c;
        id = i;
        subjects = sub;
        schoolCode = sc;
        loading = false;
        _section = sec;
        imagePath = path;
      });
    }
  }

  Future downloadImage(url) async {
    final directory = await getApplicationDocumentsDirectory();
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: directory.toString(),
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
  }

  Future<File> _downloadFile(String url) async {
    String dir = (await getExternalStorageDirectory()).path;
    String filename = url.split('/').last.split('?').first;
    if (await File('$dir/$filename').exists()) {
      print('exsist');
    } else {
      print(filename);
      Client client = new Client();
      var req = await client.get(Uri.parse(url));
      var bytes = req.bodyBytes;

      print(dir);
      File file = new File('$dir/$filename');
      await file.writeAsBytes(bytes);
      print(file);
      return file;
    }
  }
}
