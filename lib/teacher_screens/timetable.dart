import 'dart:convert';
import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schoolapp/helper.dart';

import '../colors.dart';

class NewTimeTable extends StatefulWidget {
  @override
  _NewTimeTableState createState() => _NewTimeTableState();
}

class _NewTimeTableState extends State<NewTimeTable> {
  int selectedday = 0;
  TimeOfDay startTime;
  TimeOfDay endTime;
  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  List<List<TimeTableSlot>> timetable = [];

  _pickStartTime(TimeOfDay initTime) async {
    if (initTime == null) {
      TimeOfDay t =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (t != null)
        setState(() {
          startTime = t;
        });
    } else {
      TimeOfDay t =
          await showTimePicker(context: context, initialTime: initTime);
      if (t != null)
        setState(() {
          startTime = t;
        });
    }
  }

  _pickEndTime(TimeOfDay initTime) async {
    if (initTime == null) {
      TimeOfDay t =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (t != null)
        setState(() {
          endTime = t;
        });
    } else {
      TimeOfDay t =
          await showTimePicker(context: context, initialTime: initTime);
      if (t != null)
        setState(() {
          endTime = t;
        });
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // For your reference print the AppDoc directory
    print(directory.path);
    return directory.path;
  }

  Future<File> _localFile(String filename) async {
    final path = await _localPath;
    return File('$path/' + filename);
  }

  writeContent(List<List<TimeTableSlot>> content) async {
    final file = await _localFile('timetable' + '.json');
    // Write the file
    List<List<Map<String, String>>> data = [];
    for (int i = 0; i < content.length; i++) {
      data.add([]);
      for (int j = 0; j < content[i].length; j++) {
        data.last.add({
          'n': content[i][j].className.toString(),
          'st': content[i][j].startTime.toString(),
          'et': content[i][j].endTime.toString()
        });
      }
    }
    file.writeAsStringSync(json.encode({'timetable': data}));
  }

  TimeOfDay convertToTime(String s) {
    s = s.substring(10);
    s = s.substring(0, s.length - 1);

    var a = TimeOfDay(
        hour: int.parse(s.split(":")[0]), minute: int.parse(s.split(":")[1]));
    print('1');
    return a;
  }

  readcontent() async {
    final file = await _localFile('timetable' + '.json');
    file.exists().then((value) {
      if (value) {
        file.readAsString().then((value) {
          Map<String, dynamic> a = json.decode(value);
          List<List<TimeTableSlot>> l = [];
          var vals = a['timetable'];
          print(vals);
          for (int i = 0; i < vals.length; i++) {
            l.add([]);
            for (int j = 0; j < vals[i].length; j++) {
              l.last.add(TimeTableSlot(convertToTime(vals[i][j]['st']),
                  convertToTime(vals[i][j]['et']), vals[i][j]['n'].toString()));
            }
          }
          setState(() {
            timetable = l;
          });
          print('---------------');
          print(l);
        });
      }
    });
  }

  showAlertDialog(BuildContext context) {
    String className;
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    TextEditingController c = TextEditingController();

    // set up the button
    Widget cancel = FlatButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        });
    Widget okButton = FlatButton(
      child: Text("Done"),
      onPressed: () {
        TimeTableSlot newSlot = TimeTableSlot(startTime, endTime, className);

        timetable[selectedday].add(newSlot);
        timetable[selectedday].sort((a, b) {
          if (a.startTime.hour < b.startTime.hour) {
            return -1;
          } else if (a.startTime.hour < b.startTime.hour) {
            if (a.startTime.minute < b.startTime.minute) {
              return -1;
            } else if (a.startTime.minute == b.startTime.minute) {
              return 0;
            } else {
              return 1;
            }
          } else {
            return 1;
          }
        });
        writeContent(timetable);
        setState(() {});
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Add Class"),
      content: Container(
        height: h / 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                    onTap: () {
                      _pickStartTime(null);
                    },
                    child: Text("Start time")),
                InkWell(
                    onTap: () {
                      _pickEndTime(null);
                    },
                    child: Text("End time")),
              ],
            ),
            TextField(
              controller: c,
              onChanged: (val) {
                className = val;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter Class Name",
              ),
            ),
          ],
        ),
      ),
      actions: [
        cancel,
        okButton,
      ],
    );

    // show the dialog
    Navigator.of(context).push(
      PageRouteBuilder(
          pageBuilder: (context, _, __) => alert,
          fullscreenDialog: true,
          opaque: false),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < days.length; i++) {
      timetable.add([]);
    }
    readcontent();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: offwhite,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Time Table",
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
        actions: [
          IconButton(
              icon: Icon(
                Icons.add,
                color: darkblue,
                size: 30,
              ),
              onPressed: () {
                showAlertDialog(context);
              })
        ],
      ),
      body: Column(
        children: [
          Container(
            height: h / 8,
            child: ListView.builder(
              itemCount: days.length,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(w / 25),
              itemBuilder: (context, i) {
                return Column(
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          selectedday = i;
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.all(w / 25),
                          child: Text(
                            days[i],
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: selectedday == i ? orange : Colors.grey,
                                fontSize: 20),
                          )),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: timetable[selectedday].length,
                itemBuilder: (context, i) {
                  return Container(
                    //   color: Colors.pink,
                    padding: EdgeInsets.all(w / 30),
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    height: h / 7,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(timetable[selectedday][i].className),
                        Text((timetable[selectedday][i].startTime.hour % 12) ==
                                0
                            ? '12'
                            : (timetable[selectedday][i].startTime.hour % 12)
                                    .toString() +
                                timetable[selectedday][i]
                                    .startTime
                                    .period
                                    .toString()
                                    .substring(10)),
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle),
                              onPressed: () {
                                timetable[selectedday]
                                    .remove(timetable[selectedday][i]);
                                timetable[selectedday].sort((a, b) {
                                  if (a.startTime.hour < b.startTime.hour) {
                                    return -1;
                                  } else if (a.startTime.hour <
                                      b.startTime.hour) {
                                    if (a.startTime.minute <
                                        b.startTime.minute) {
                                      return -1;
                                    } else if (a.startTime.minute ==
                                        b.startTime.minute) {
                                      return 0;
                                    } else {
                                      return 1;
                                    }
                                  } else {
                                    return 1;
                                  }
                                });
                                writeContent(timetable);
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.update_rounded),
                              onPressed: () {
                                showUpdateAlertDialog(
                                    context,
                                    timetable[selectedday][i].startTime,
                                    timetable[selectedday][i].endTime,
                                    timetable[selectedday][i].className,
                                    selectedday,
                                    i);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                    margin: EdgeInsets.all(w / 25),
                  );
                }),
          )
        ],
      ),
    );
  }

  showUpdateAlertDialog(BuildContext context, TimeOfDay sTime, TimeOfDay eTime,
      String name, int i, int j) {
    String className = name;
    TimeOfDay startTime = sTime;
    TimeOfDay endTime = eTime;
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    TextEditingController c = TextEditingController();

    // set up the button
    Widget cancel = FlatButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        });
    Widget okButton = FlatButton(
      child: Text("Done"),
      onPressed: () {
        TimeTableSlot newSlot = TimeTableSlot(startTime, endTime, className);

        timetable[i][j] = newSlot;
        timetable[selectedday].sort((a, b) {
          if (a.startTime.hour < b.startTime.hour) {
            return -1;
          } else if (a.startTime.hour < b.startTime.hour) {
            if (a.startTime.minute < b.startTime.minute) {
              return -1;
            } else if (a.startTime.minute == b.startTime.minute) {
              return 0;
            } else {
              return 1;
            }
          } else {
            return 1;
          }
        });
        writeContent(timetable);
        setState(() {});
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Add Class"),
      content: Container(
        height: h / 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                    onTap: () {
                      _pickStartTime(timetable[i][j].startTime);
                    },
                    child: Text("Start time")),
                InkWell(
                    onTap: () {
                      _pickEndTime(timetable[i][j].endTime);
                    },
                    child: Text("End time")),
              ],
            ),
            TextField(
              controller: c,
              onChanged: (val) {
                className = val;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: name,
              ),
            ),
          ],
        ),
      ),
      actions: [
        cancel,
        okButton,
      ],
    );

    // show the dialog
    Navigator.of(context).push(
      PageRouteBuilder(
          pageBuilder: (context, _, __) => alert,
          fullscreenDialog: true,
          opaque: false),
    );
  }
}

class TimeTableSlot {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String className;

  TimeTableSlot(this.startTime, this.endTime, this.className);
}
