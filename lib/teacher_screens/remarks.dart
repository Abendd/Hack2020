import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import './remarksHistory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../colors.dart';

class SpecialRemarks extends StatefulWidget {
  final schoolCode;
  final id;
  final name;
  const SpecialRemarks({Key key, this.schoolCode, this.id, this.name})
      : super(key: key);

  @override
  _SpecialRemarksState createState() => _SpecialRemarksState();
}

class _SpecialRemarksState extends State<SpecialRemarks> {
  String currentClass;
  String currentSection;
  Map<String, List<String>> classDetails;
  bool loading = false;
  Map<String, String> studentList;
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
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Remarks",
            style: TextStyle(
                color: darkblue, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: darkblue,
              ),
              onPressed: () => Navigator.pop(context)),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.history,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RemarksHistory()));
                })
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(w/20),
                child: Text("Select Class",style: style2,),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  new DropdownButton<String>(
                    dropdownColor: dullpurple,
                    elevation: 5,
                    focusColor: darkpurple,
                    underline: SizedBox(),
                    items: classDetails.keys.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    value: currentClass,
                    onChanged: (val) {
                      setState(() {
                        currentClass = val;
                        currentSection = classDetails[currentClass][0];
                      });
                    },
                  ),
                  new DropdownButton<String>(
                    dropdownColor: dullpurple,
                    elevation: 5,
                    focusColor: darkpurple,
                    underline: SizedBox(),
                    items: classDetails[currentClass].map((String value) {
                      return new DropdownMenuItem<String>(
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
                  RaisedButton(
                       padding: EdgeInsets.all(w / 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: dullpurple,
                    child: Text('Get Details',style: style,),
                    onPressed: () async {
                      var d = await Firestore.instance
                          .collection('schools')
                          .document(widget.schoolCode)
                          .collection('parent')
                          .where('class', isEqualTo: currentClass)
                          .where('section', isEqualTo: currentSection)
                          .getDocuments();
                      Map<String, String> m = {};
                      for (int i = 0; i < d.documents.length; i++) {
                        m[d.documents[i].documentID] =
                            d.documents[i].data['name'];
                      }
                      setState(() {
                        studentList = m;
                      });
                    },
                  )
                ],
              ),
              studentList != null
                  ?  Container(
                        height: h,
                        child: ListView.builder(
                            itemCount: studentList.keys.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RemarkSubmission(
                                                studentId: studentList.keys
                                                    .elementAt(index),
                                                schoolCode: widget.schoolCode,
                                                name: widget.name,
                                              )));
                                },
                                child: Container(
                                    margin: EdgeInsets.only(top: 60, left: 60),
                                    child: Text(
                                        studentList.values.elementAt(index))),
                              );
                            }),
                      )
                  
                  : SizedBox(),
            ],
          ),
        ));
  }

  getData() async {
    var d = await Firestore.instance
        .collection('schools')
        .document(widget.schoolCode)
        .collection('classes')
        .getDocuments();
    Map<String, List<String>> m = {};
    for (int i = 0; i < d.documents.length; i++) {
      String c = d.documents.elementAt(i).documentID;
      if (m[c.split(' ')[0]] == null) {
        m[c.split(' ')[0]] = [c.split(' ')[1]];
      } else {
        m[c.split(' ')[0]].add(c.split(' ')[1]);
      }
    }
    setState(() {
      classDetails = m;
      currentClass = m.keys.elementAt(0);
      currentSection = m[m.keys.elementAt(0)][0];
    });
  }
}

class RemarkSubmission extends StatefulWidget {
  final studentId;
  final schoolCode;
  final name;

  const RemarkSubmission({Key key, this.studentId, this.name, this.schoolCode})
      : super(key: key);

  @override
  _RemarkSubmissionState createState() => _RemarkSubmissionState();
}

class _RemarkSubmissionState extends State<RemarkSubmission> {
  String remark;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
       double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Enter Remark",
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
      body: Column(
        children: [
         
          Container(
             padding: EdgeInsets.all(w / 40),
                margin: EdgeInsets.all(w / 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: dullpurple),
                ),
            child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Remarks',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
              onChanged: (val) {
                remark = val;
              },
            ),
          ),
          RaisedButton(
              padding: EdgeInsets.all(w / 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: dullpurple,
              child: loading ? Text('Submitting...',style: style,) : Text('Submit',style: style,),
              onPressed: loading
                  ? () {}
                  : () async {
                      if (remark == null) {
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
                        var l = pref.getStringList('remarksHistory');
                        if (l == null) {
                          l = [];
                        }
                        l.add(remark + '::' + widget.studentId);
                        pref.setStringList('remarksHistory', l);
                        Firestore.instance
                            .collection('schools')
                            .document(widget.schoolCode)
                            .collection("parent")
                            .document(widget.studentId)
                            .collection('remarks')
                            .document()
                            .setData({
                          'remark': remark,
                          'by': widget.name,
                          'date': DateTime.now()
                        }).whenComplete(() {
                          Flushbar(
                            title: "Success",
                            message: "Remark Sent",
                            duration: Duration(seconds: 3),
                            margin: EdgeInsets.all(8),
                            borderRadius: 8,
                          )..show(context).whenComplete(() {
                              Navigator.pop(context);
                              setState(() {
                                loading = false;
                              });
                            });
                        });
                      }
                    })
        ],
      ),
    );
  }
}
