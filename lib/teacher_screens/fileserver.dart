import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../colors.dart';

class FileServer extends StatefulWidget {
  final id;
  final schooolCode;

  const FileServer({Key key, this.id, this.schooolCode}) : super(key: key);
  @override
  _FileServerState createState() => _FileServerState();
}

class _FileServerState extends State<FileServer> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String currentClass;
  String currentSection;
  TextEditingController notice = TextEditingController();
  List<String> _subject = [];
  String currentSubject = "";
  File selectedFile;
  String filename;
  Map<String, List<String>> _class;
  bool loading = false;
  void initialiseSubjects() async {
    final SharedPreferences pref = await _prefs;
    List<String> sub = pref.getStringList('subjects');

    var data = await Firestore.instance
        .collection('schools')
        .document(widget.schooolCode)
        .collection('classes')
        .getDocuments();
    Map<String, List<String>> c = {};
    for (int i = 0; i < data.documents.length; i++) {
      if (c[data.documents[i].documentID.split(' ')[0]] == null) {
        c[data.documents[i].documentID.split(' ')[0]] = [
          'All',
          data.documents[i].documentID.split(' ')[1]
        ];
      } else {
        c[data.documents[i].documentID.split(' ')[0]]
            .add(data.documents[i].documentID.split(' ')[1]);
      }
    }

    setState(() {
      _subject = sub;
      currentSubject = sub[0];
      _class = c;
      currentClass = _class.keys.toList()[0];
      currentSection = _class[_class.keys.toList()[0]][0];
    });
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


    return _class.length == 0
        ? Scaffold(
            body: Text("loading"),
          )
        : Scaffold(
            backgroundColor: offwhite,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "File Server",
                style: TextStyle(
                    color: darkblue, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: darkblue,
                  ),
                  onPressed: () => Navigator.pop(context)),
              actions: [
                  
                IconButton(
                    color: Colors.black,
                    icon: Icon(
                      Icons.history,
                      size: 30,
                    ),
                    onPressed: () {
                    
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
                        'assets/fs1.png',
                        fit: BoxFit.contain,
                      )),
                  Container(
                    width: w / 2,
                    padding: EdgeInsets.all(w / 30),
                    //  margin: EdgeInsets.all(w / 20),
                    child: RaisedButton(
                      padding: EdgeInsets.all(w / 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: dullpurple,
                      onPressed: () {
                        getPdfAndUpload();
                      },
                      child: Icon(
                        Icons.add_photo_alternate,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(selectedFile == null
                        ? ''
                        : selectedFile.path.split('/').last),
                  ),
                  Container(
                    padding: EdgeInsets.all(w / 40),
                    margin: EdgeInsets.all(w / 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: dullpurple),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'File Title',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          filename = val;
                        });
                      },
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                            child: Text(
                          "Class",
                          style: style2,
                        )),
                        new DropdownButton<String>(
                          dropdownColor: dullpurple,
                          elevation: 5,
                          focusColor: darkpurple,
                          underline: SizedBox(),
                          items: _class.keys.map((String value) {
                            return new DropdownMenuItem<String>(
                              onTap: (){
                                FocusScope.of(context).requestFocus(new FocusNode());
                              },
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          value: currentClass,
                          onChanged: changeSelectedCLass,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Subject",
                    style: style2,
                  ),
                  new DropdownButton<String>(
                    dropdownColor: dullpurple,
                    elevation: 5,
                    focusColor: darkpurple,
                    underline: SizedBox(),
                    items: _subject.map((String value) {
                      return new DropdownMenuItem<String>(
                            onTap: (){
                                FocusScope.of(context).requestFocus(new FocusNode());
                              },
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    value: currentSubject,
                    onChanged: changeSelectedSubject,
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                            child: Text(
                          "Section",
                          style: style2,
                        )),
                        new DropdownButton<String>(
                          dropdownColor: dullpurple,
                          elevation: 5,
                          focusColor: darkpurple,
                          underline: SizedBox(),
                          items: _class[currentClass].map((String value) {
                            return new DropdownMenuItem<String>(
                                  onTap: (){
                                FocusScope.of(context).requestFocus(new FocusNode());
                              },
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          value: currentSection,
                          onChanged: (val) {
                            setState(() {
                              currentSection = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(w / 20),
                    width: w / 2,
                    child: RaisedButton(
                      onPressed: loading
                          ? () {}
                          : () async {
                              if (filename == null) {
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
                                final _fileServerDb = Firestore.instance
                                    .collection('schools')
                                    .document(widget.schooolCode)
                                    .collection("fileserver");
                                FirebaseStorage storage =
                                    FirebaseStorage.instance;
                                //print('${file.readAsBytesSync()}');
                                StorageUploadTask task = storage
                                    .ref()
                                    .child(widget.schooolCode)
                                    .child(currentSubject)
                                    .child(currentClass + currentSection)
                                    .child(filename)
                                    .putFile(selectedFile);
                                String url = await (await task.onComplete)
                                    .ref
                                    .getDownloadURL();

                                _fileServerDb
                                    .document(currentSubject)
                                    .collection(currentClass)
                                    .document(currentSection)
                                    .collection('files')
                                    .document()
                                    .setData({
                                  'filename': filename,
                                  'url': url,
                                  'exn': selectedFile.path
                                      .split('/')
                                      .last
                                      .split('.')
                                      .last
                                }).whenComplete(() {
                                  print(
                                      "------------000000000---------------------------");
                                  Flushbar(
                                    title: "Success",
                                    message: "File Added",
                                    duration: Duration(seconds: 3),
                                    margin: EdgeInsets.all(8),
                                    borderRadius: 8,
                                  )..show(context).whenComplete(() {
                                      Navigator.pop(context);
                                    });
                                  setState(() {
                                    loading = false;
                                  });
                                });
                              }
                            },
                      child: Text(
                        loading ? 'Uploading' : 'Done',
                        style: styleCard,
                      ),
                      padding: EdgeInsets.all(w / 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: dullpurple,
                    ),
                  )
                ],
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
  }

  changeSelectedCLass(String val) {
    setState(() {
      currentClass = val;
    currentSection = _class[currentClass][0];
    });
  }

  changeSelectedSubject(String val) {
    setState(() {
      currentSubject = val;
    });
  }
}
