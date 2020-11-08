import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';

class RemarksHistory extends StatefulWidget {
  @override
  _RemarksHistoryState createState() => _RemarksHistoryState();
}

class _RemarksHistoryState extends State<RemarksHistory> {
  var remarksHistory;
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
                "Remarks History",
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
        child: remarksHistory == null
            ? Text('loading')
            : ListView.builder(
                itemCount: remarksHistory.length,
                itemBuilder: (context, index) {
                  return Container(
                  
                     margin: EdgeInsets.all(w/25),
                    // height: h/20,
                        decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(50, 85, 168, .3),
                                    blurRadius: 10,
                                    offset: Offset(0, 10))
                              ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10
                    ),
                ),
                      child: ListTile(


                        title: Text( remarksHistory[index][0]),
                        subtitle: Text(remarksHistory[index][1],),
                      )
                    );
                },
              ),
      ),
    );
   
  }

  getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var l = pref.getStringList('remarksHistory');
  
    var ans = [];
    for (int i = 0; i < l.length; i++) {

      ans.add(l[i].split('::'));
    }
    setState(() {
      remarksHistory = ans;
    });
  }
}
