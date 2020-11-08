import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../colors.dart';

class StudentRemarks extends StatefulWidget {
  String schoolCode;
  String id;
  StudentRemarks({this.id, this.schoolCode});
  @override
  _StudentRemarksState createState() => _StudentRemarksState();
}

class _StudentRemarksState extends State<StudentRemarks> {
  List<Remark> remarks;
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
    return remarks == null
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: PreferredSize(
              child: Stack(
                children: [
                  Container(
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
                        "Remarks",
                        style: TextStyle(color: darkpurple, fontSize: 24),
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      actions: [],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: h / 10),
                      width: w,
                      child: Center(child: Image.asset('assets/rem.png')))
                ],
              ),
              preferredSize: Size.fromHeight(h / 3),
            ),
            backgroundColor: offwhite,
            body: ListView.builder(
              itemCount: remarks.length,
              itemBuilder: (context, index) {
                return Container(
                  height: h / 10,
                  margin:
                      EdgeInsets.only(top: w / 25, left: w / 20, right: w / 20),
                  child: RaisedButton(
                      elevation: 0,
                      color: dullpurple,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      onPressed: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            remarks[index].text,
                            style: style,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                remarks[index].date.day.toString() +
                                    '-' +
                                    remarks[index].date.month.toString() +
                                    '-' +
                                    remarks[index].date.year.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '- ' + remarks[index].by,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          )
                        ],
                      )),
                );
              },
            ));
  }

  void initialiseVariables() async {
    QuerySnapshot docs = await Firestore.instance
        .collection('schools')
        .document(widget.schoolCode)
        .collection("parent")
        .document(widget.id)
        .collection('remarks')
        .getDocuments();

    List<Remark> r = [];
    for (int i = 0; i < docs.documents.length; i++) {
      r.add(Remark(
        docs.documents.elementAt(i)['remark'],
        docs.documents.elementAt(i)['by'],
        docs.documents.elementAt(i)['date'].toDate(),
      ));
    }

    r.sort((a, b) {
      return -a.date.compareTo(b.date);
      // also not work return b['timestamp'].compareTo(a['timestamp']);
    });
    setState(() {
      remarks = r;
    });
  }
}

class Remark {
  final text;
  final by;
  final DateTime date;

  Remark(this.text, this.by, this.date);
}
