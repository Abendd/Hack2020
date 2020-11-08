import 'dart:io';
import 'dart:async';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scalable_image/scalable_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';

class TimeTable extends StatefulWidget {
  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  String timetablePath = 'NotAvailable';
  String filename;

  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      timetablePath = prefs.getString('timetablePath');
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
     double h = MediaQuery.of(context).size.height;
    return Scaffold(
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(w / 35),
                  margin: EdgeInsets.all(w / 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: orange,
                  ),
                  child: RaisedButton(
                    color: Colors.transparent,
                    elevation: 0,
                    onPressed: () async {
                      File file = await FilePicker.getFile(
                        type: FileType.custom,
                        allowedExtensions: ['jpg'],
                      ).whenComplete(() {
                        Flushbar(
                          title: "Success",
                          message: "Time Table Uploaded",
                          duration: Duration(seconds: 3),
                          margin: EdgeInsets.all(8),
                          borderRadius: 8,
                        )..show(context).whenComplete(() {
                            Navigator.pop(context);
                        });
                      });
                      var bytes = await file.readAsBytes();
                      String dir = (await getExternalStorageDirectory()).path;
                      String filename = 'timetable.jpg';
                      File dp = new File('$dir/$filename');
                      print('====');
                      print('$dir/$filename');
                      await dp.writeAsBytes(bytes);
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.setString('timetablePath', '$dir/$filename');

                      setState(() {
                        timetablePath = '$dir/$filename';
                      });
                    
                    },
                    child: Text(
                      'Add Time Table',
                      style: styleCard,
                    ),
                  ),
                ),
              ],
            ),
            timetablePath == null
                ? Container(
                    child: Text("Please Add Time Table"),
                  )
                : Container(
                    width: w / 1.09,
                  height: h/1.5,
                    child: Center(
                 child:     new ScalableImage(
                   imageProvider: FileImage(File(timetablePath)),
                  dragSpeed: 4.0,
          maxScale: 16.0
                 )
                    //  child: 
                      // ZoomableImage( AssetFile(
                      //   File(timetablePath),
                      //   fit: BoxFit.cover,
                      // ),)
                   
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
