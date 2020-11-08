import 'dart:io';
import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import '../colors.dart';

class StudentFileserver extends StatefulWidget {
  String currentClass;
  String section;
  String schoolCode;
  String id;
  StudentFileserver(
      {this.currentClass, this.section, this.id, this.schoolCode});
  @override
  _StudentFileserverState createState() => _StudentFileserverState();
}

class _StudentFileserverState extends State<StudentFileserver> {
  List<String> _subject = [];
  String currentSubject = "";

  List<Map<String, String>> files = [];

  void initialiseSubjects() async {
    final _subjectDb = Firestore.instance
        .collection('schools')
        .document(widget.schoolCode)
        .collection("Subjects");

    QuerySnapshot d = await _subjectDb.getDocuments();
    List<String> sb = [];
    for (int i = 0; i < d.documents.length; i++) {
      sb.add(d.documents.elementAt(i).documentID);
    }
    setState(() {
      _subject = sb;
      currentSubject = sb[0];
    });
    getFiles();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialiseSubjects();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
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
                "FileServer",
                style: TextStyle(color: darkpurple, fontSize: 24),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [],
            ),
          ),
          preferredSize: Size.fromHeight(h / 10),
        ),
        body: Column(
          children: <Widget>[
            Container(
                width: w,
                height: h / 3.5,
                child: Image.asset('assets/fs1.png')),
            Container(
              margin: EdgeInsets.all(w / 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      'Select Subject :',
                      style: TextStyle(
                          fontSize: 25,
                          color: darkpurple,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    child: DropdownButton<String>(
                      // isExpanded: true,

                      underline: Container(
                        color: Colors.white,
                      ),
                      onChanged: (String val) {
                        setState(() {
                          currentSubject = val;
                        });
                        getFiles();
                      },
                      style: TextStyle(fontSize: 25, color: darkpurple),
                      items: _subject.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),

                      value: currentSubject,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: files != null
                  ? ListView.builder(
                      itemCount: files.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            _downloadFile(
                                files.elementAt(index)['url'],
                                files.elementAt(index)['filename'] +
                                    '.' +
                                    files.elementAt(index)['exn']);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              margin: EdgeInsets.only(left: w / 50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                              //     height: h / 1,
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
                                title: Text(
                                  files.elementAt(index)['filename'],
                                ),
                                subtitle: Text("Click to Download"),
                              ),
                            ),
                          ),
                        );
                      })
                  : Text('loading'),
            )
          ],
        ));
  }

  changeSelectedSubject(String val) {
    setState(() {
      currentSubject = val;
    });
  }

  Future<File> _downloadFile(String url, String filename) async {
    String dir = (await getExternalStorageDirectory()).path;

    if (await File('$dir/$filename').exists()) {
      OpenFile.open('$dir/$filename');
    } else {
      print(filename);
      Client client = new Client();
      var req = await client.get(Uri.parse(url));
      var bytes = req.bodyBytes;

      print(dir);
      File file = new File('$dir/$filename');
      await file.writeAsBytes(bytes);

      OpenFile.open('$dir/$filename');
      //
    }
  }

  getFiles() async {
    print('------');
    print(currentSubject);

    List<Map<String, String>> f = [];
    final fileserver = Firestore.instance
        .collection('schools')
        .document(widget.schoolCode)
        .collection("fileserver");
    var personal = await fileserver
        .document(currentSubject)
        .collection(widget.currentClass)
        .document(widget.section)
        .collection('files')
        .getDocuments();
    var all = await fileserver
        .document(currentSubject)
        .collection(widget.currentClass)
        .document('All')
        .collection('files')
        .getDocuments();
    for (int i = 0; i < personal.documents.length; i++) {
      f.add({
        'filename': personal.documents.elementAt(i)['filename'],
        'url': personal.documents.elementAt(i)['url'],
        'exn': personal.documents.elementAt(i)['exn']
      });
    }
    for (int i = 0; i < all.documents.length; i++) {
      f.add({
        'filename': all.documents.elementAt(i)['filename'],
        'url': all.documents.elementAt(i)['url'],
        'exn': all.documents.elementAt(i)['exn']
      });
    }
    print('1');
    print(f);
    print(widget.section);
    setState(() {
      files = f;
    });
  }
}
