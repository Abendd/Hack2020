import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schoolapp/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';

class NoticeHistory extends StatefulWidget {
  @override
  _NoticeHistoryState createState() => _NoticeHistoryState();
}

class _NoticeHistoryState extends State<NoticeHistory> {
  List<String> historyList;
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
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
              "Notice History",
              style: TextStyle(color: darkpurple, fontSize: 24),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        preferredSize: Size.fromHeight(h / 10),
      ),
      backgroundColor: offwhite,
      body: Center(
        child: historyList == null
            ? Text('loading')
            : ListView.builder(
                itemCount: historyList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      String dir = (await getExternalStorageDirectory()).path;
                      String filename =
                          'notices/' + historyList.elementAt(index);
                      OpenFile.open('$dir/$filename');
                    },
                    child: Container(
                      margin: EdgeInsets.all(w / 25),
                      // height: h / 20,
                      padding: EdgeInsets.all(w / 25),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(50, 85, 168, .3),
                              blurRadius: 10,
                              offset: Offset(0, 10))
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: Text(
                        historyList.elementAt(index),
                        style: style2,
                      )),
                    ),
                  );
                },
              ),
      ),
    );
  }

  getData() async {
    print('---');
    SharedPreferences pref = await SharedPreferences.getInstance();
    var l = pref.getStringList('NoticeList');
    print(l);
    setState(() {
      if (l != null) {
        historyList = l.reversed.toList();
      } else {
        historyList = [];
      }
    });
  }
}
