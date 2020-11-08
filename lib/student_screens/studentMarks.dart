import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schoolapp/colors.dart';

class StudentMarks extends StatefulWidget {
  final String id;
  final String schoolCode;
  final List<String> subjects;
  const StudentMarks({Key key, this.id, this.schoolCode, this.subjects})
      : super(key: key);

  @override
  _StudentMarksState createState() => _StudentMarksState();
}

class _StudentMarksState extends State<StudentMarks> {
  List<List<String>> marks;
  List<String> examtypes;
  String currentExamType;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Select Exam",
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
        backgroundColor: offwhite,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: h / 20,
            ),
            Container(
              alignment: Alignment.center,
              child: DropdownButton<String>(
                underline: Container(
                  color: Colors.white,
                ),
                style: TextStyle(fontSize: 25, color: darkpurple),
                items: examtypes.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(
                      value,
                    ),
                  );
                }).toList(),
                value: currentExamType,
                onChanged: changeSelectedTest,
              ),
            ),
            SizedBox(
              height: h / 20,
            ),
            RaisedButton(
              padding: EdgeInsets.all(w / 45),
              color: dullpurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: initializevariables,
              child: Text(
                'Get Marks',
                style: style,
              ),
            ),
            marks != null
                ? Expanded(
                    child: ListView.builder(
                      itemCount: marks.length,
                      itemBuilder: (context, i) {
                        return Container(
                          margin: EdgeInsets.only(left: w / 20, top: w / 25),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  width: w / 10,
                                  child: Text(
                                    marks[i][0],
                                    style: style2,
                                  )),
                              Text(
                                marks[i][1],
                                style: style2,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : SizedBox()
          ],
        ));
  }

  void initializevariables() async {
    final marksDb = Firestore.instance
        .collection('schools')
        .document(widget.schoolCode)
        .collection("parent")
        .document(widget.id)
        .collection('marks')
        .document(currentExamType);
    List<List<String>> m = [];
    DocumentSnapshot docs = await marksDb.get();
    print(widget.id);
    if (docs.exists) {
      for (int i = 0; i < docs.data.keys.length; i++) {
        m.add([
          docs.data.keys.elementAt(i),
          docs.data[docs.data.keys.elementAt(i)]
        ]);
      }
    }
    setState(() {
      marks = m;
      print(marks);
    });
  }

  changeSelectedTest(String value) {
    setState(() {
      currentExamType = value;
    });
  }

  getData() async {
    var d = await Firestore.instance
        .collection('schools')
        .document(widget.schoolCode)
        .collection("testTypes")
        .getDocuments();
    List<String> t = [];
    for (int i = 0; i < d.documents.length; i++) {
      t.add(d.documents.elementAt(i).documentID);
    }
    setState(() {
      examtypes = t;
      currentExamType = t[0];
    });
  }
}
