import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';
import 'package:jitsi_meet/feature_flag/feature_flag_enum.dart';
import 'package:schoolapp/student_screens/student.dart';

import '../colors.dart';

class MeetingLists extends StatefulWidget {
  final schoolCode;
  final name;
  final id;
  final currentClass;
  final currentSection;
  const MeetingLists(
      {Key key,
      this.schoolCode,
      this.name,
      this.id,
      this.currentClass,
      this.currentSection})
      : super(key: key);
  @override
  _MeetingListsState createState() => _MeetingListsState();
}

class _MeetingListsState extends State<MeetingLists> {
List<List<String>> meetingList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeVariables();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: offwhite,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Meeting",
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
      body: Center(
        child: ListView.builder(
            itemCount: meetingList.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(w / 25),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(50, 85, 168, .3),
                          blurRadius: 20,
                          offset: Offset(0, 10))
                    ]),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WaitingRoom(
                                id: widget.id,
                                name: widget.name,
                                schoolCode: widget.schoolCode,
                                roomName: meetingList[index][0] , pwd: meetingList[index][1])));
                  },
                  title: Text(
                    meetingList[index][0],
                    style: style2,
                  ),
                  subtitle: Text(
                    "Tap to join",
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              );
            }),
      ),
    );
  }

  void initializeVariables() async {
    QuerySnapshot docs = await Firestore.instance
        .collection('schools')
        .document(widget.schoolCode)
        .collection('lobby')
        .getDocuments();
   List< List<String>> l = [];
    for (int i = 0; i < docs.documents.length; i++) {
      print(docs.documents);
      var c = docs.documents.elementAt(i).data['classes'];
      for (int j = 0; j < c.length; j++) {
        if (c[j].split('-')[0] == widget.currentClass &&
            c[j].split('-')[1].toUpperCase() == widget.currentSection) {
          print(i);
          l.add([docs.documents.elementAt(i).documentID,docs.documents.elementAt(i).data['pwd'] ] );
        
        }
      }
    }
    print(l);
    setState(() {
      meetingList = l;
    });
  }
}

class WaitingRoom extends StatefulWidget {
  final roomName;
  final schoolCode;
  final name;
  final id;
  final pwd;
  WaitingRoom({this.roomName, this.schoolCode, this.name, this.id, this.pwd});
  @override
  _WaitingRoomState createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  getdata() async {
    var data = await Firestore.instance
        .collection('schools')
        .document(widget.schoolCode)
        .collection('lobby')
        .document(widget.roomName)
        .get();
    print('------');
    print(data['waiting room']);
    print(widget.roomName);
    List<String> details = [];
    bool flag = false;
    for (int i = 0; i < data['waiting room'].length; i++) {
      if (data['waiting room'].elementAt(i) == widget.id) {
        flag = true;
        break;
      }
      details.add(data['waiting room'].elementAt(i));
    }
    if (!flag) {
      details.add(widget.id);
      Firestore.instance
          .collection('schools')
          .document(widget.schoolCode)
          .collection('lobby')
          .document(widget.roomName)
          .setData({'waiting room': details});
    }
    print(data['waiting room']);
  }

  bool x = false;

  Widget button() {
    return RaisedButton(
      onPressed: () {
        print('------------------------------------------4----------------------------');
        print(widget.pwd);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Meeting(roomName: widget.roomName+widget.pwd)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          color: Colors.green,
          height: MediaQuery.of(context).size.height,
        ),
        Container(
          child: StreamBuilder(
              stream: Firestore.instance
                  .collection('schools')
                  .document(widget.schoolCode)
                  .collection('lobby')
                  .document(widget.roomName)
                  .snapshots(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  int position = -1;
                  print("00000000000000000000000000000000000000000000000000000");
                print(widget.roomName + widget.schoolCode);
                  print(snapshot.data['waiting room']);
                  for (int i = 0;
                      i < snapshot.data['waiting room'].length;
                      i++) {
                    if (snapshot.data['waiting room'].elementAt(i) ==
                        widget.id) {
                      position = i + 1;
                      break;
                    }
                  }
                  if (position == 1) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacement(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => Meeting(
                                  id: widget.id,
                                  schoolCode: widget.schoolCode,
                                  name: widget.name,
                                  roomName: widget.roomName + widget.pwd)));
                    });

                    // setState(() {
                    //   x= true;
                    // });

                    //  x?button(): Text("wait");

                  }
                  return Center(child: Text(position.toString()));
                } else if (snapshot == null) {
                  return Text('loading');
                } else {
                  return Text('loading');
                }
              }),
        ),
      ],
    ));
  }
}

class Meeting extends StatefulWidget {
  final schoolCode;
  final name;
  final id;
  final String roomName;
  Meeting({this.roomName, this.schoolCode, this.name, this.id});
  @override
  _MeetingState createState() => _MeetingState();
}

class _MeetingState extends State<Meeting> {
  final serverText = TextEditingController();
  final roomText = TextEditingController();
  final subjectText = TextEditingController(text: "");
  final nameText = TextEditingController(text: "Plugin Test User");
  final emailText = TextEditingController(text: "fake@email.com");
  final iosAppBarRGBAColor =
      TextEditingController(text: "#0080FF80"); //transparent blue
  var isAudioOnly = true;
  var isAudioMuted = true;
  var isVideoMuted = true;
  
  @override
  void initState() {
    super.initState();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
    _joinMeeting();
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          // appBar: AppBar(
          //   title: const Text('Plugin example app'),
          // ),
          // body: Container(
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: 16.0,
          //   ),
          //   child: SingleChildScrollView(
          //     child: Column(
          //       children: <Widget>[
          //         SizedBox(
          //           height: 24.0,
          //         ),
          //         TextField(
          //           controller: serverText,
          //           decoration: InputDecoration(
          //               border: OutlineInputBorder(),
          //               labelText: "Server URL",
          //               hintText: "Hint: Leave empty for meet.jitsi.si"),
          //         ),
          //         SizedBox(
          //           height: 16.0,
          //         ),
          //         TextField(
          //           controller: roomText,
          //           decoration: InputDecoration(
          //             border: OutlineInputBorder(),
          //             labelText: "Room",
          //           ),
          //         ),
          //         SizedBox(
          //           height: 16.0,
          //         ),
          //         TextField(
          //           controller: subjectText,
          //           decoration: InputDecoration(
          //             border: OutlineInputBorder(),
          //             labelText: "Subject",
          //           ),
          //         ),
          //         SizedBox(
          //           height: 16.0,
          //         ),
          //         TextField(
          //           controller: nameText,
          //           decoration: InputDecoration(
          //             border: OutlineInputBorder(),
          //             labelText: "Display Name",
          //           ),
          //         ),
          //         SizedBox(
          //           height: 16.0,
          //         ),
          //         TextField(
          //           controller: emailText,
          //           decoration: InputDecoration(
          //             border: OutlineInputBorder(),
          //             labelText: "Email",
          //           ),
          //         ),
          //         SizedBox(
          //           height: 16.0,
          //         ),
                  // TextField(
                  //   controller: iosAppBarRGBAColor,
                  //   decoration: InputDecoration(
                  //       border: OutlineInputBorder(),
                  //       labelText: "AppBar Color(IOS only)",
                  //       hintText: "Hint: This HAS to be in HEX RGBA format"),
                  // ),
          //         SizedBox(
          //           height: 16.0,
          //         ),
          //         CheckboxListTile(
          //           title: Text("Audio Only"),
          //           value: isAudioOnly,
          //           onChanged: _onAudioOnlyChanged,
          //         ),
          //         SizedBox(
          //           height: 16.0,
          //         ),
          //         CheckboxListTile(
          //           title: Text("Audio Muted"),
          //           value: isAudioMuted,
          //           onChanged: _onAudioMutedChanged,
          //         ),
          //         SizedBox(
          //           height: 16.0,
          //         ),
          //         CheckboxListTile(
          //           title: Text("Video Muted"),
          //           value: isVideoMuted,
          //           onChanged: _onVideoMutedChanged,
          //         ),
          //         Divider(
          //           height: 48.0,
          //           thickness: 2.0,
          //         ),
          //         SizedBox(
          //           height: 64.0,
          //           width: double.maxFinite,
          //           child: RaisedButton(
          //             onPressed: () {
          //               _joinMeeting();
          //             },
          //             child: Text(
          //               "Join Meeting",
          //               style: TextStyle(color: Colors.white),
          //             ),
          //             color: Colors.blue,
          //           ),
          //         ),
          //         SizedBox(
          //           height: 48.0,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          ),
    );
  }

  _onAudioOnlyChanged(bool value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  _joinMeeting() async {
    String serverUrl =
        serverText.text?.trim()?.isEmpty ?? "" ? null : serverText.text;

    try {
      // Enable or disable any feature flag here
      // If feature flag are not provided, default values will be used
      // Full list of feature flags (and defaults) available in the README
      Map<FeatureFlagEnum, bool> featureFlags = {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
      };

      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }
      print("8888888888888888888888888888888888888888888888888888888888");
print(widget.roomName);
      // Define meetings options here
      var options = JitsiMeetingOptions()
        ..room = widget.roomName
        ..serverURL = serverUrl
        ..subject = subjectText.text
        ..userDisplayName = widget.name
        ..userEmail = emailText.text
        ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
        ..audioOnly = isAudioOnly
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted
        ..featureFlags.addAll(featureFlags);

      debugPrint("JitsiMeetingOptions: $options");
      await JitsiMeet.joinMeeting(
        options,
        listener: JitsiMeetingListener(onConferenceWillJoin: ({message}) {
          debugPrint("${options.room} will join with message: $message");
        }, onConferenceJoined: ({message}) {
          debugPrint("${options.room} joined with message: $message");
        }, onConferenceTerminated: ({message}) {
          debugPrint("${options.room} terminated with message: $message");
        }),
        // by default, plugin default constraints are used
        //roomNameConstraints: new Map(), // to disable all constraints
        //roomNameConstraints: customContraints, // to use your own constraint(s)
      );
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  static final Map<RoomNameConstraintType, RoomNameConstraint>
      customContraints = {
    RoomNameConstraintType.MAX_LENGTH: new RoomNameConstraint((value) {
      return value.trim().length <= 50;
    }, "Maximum room name length should be 30."),
    RoomNameConstraintType.FORBIDDEN_CHARS: new RoomNameConstraint((value) {
      return RegExp(r"[$€£]+", caseSensitive: false, multiLine: false)
              .hasMatch(value) ==
          false;
    }, "Currencies characters aren't allowed in room names."),
  };

  void _onConferenceWillJoin({message}) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined({message}) {}

  void _onConferenceTerminated({message}) async {
    print('----------------------1-1--1------');
    var data = await Firestore.instance
        .collection('schools')
        .document(widget.schoolCode)
        .collection('lobby')
        .document(widget.roomName)
        .get();
    print('------');
    List<String> details = [];
    for (int i = 1; i < data['waiting room'].length; i++) {
      details.add(data['waiting room'].elementAt(i));
    }
    Firestore.instance
        .collection('schools')
        .document(widget.schoolCode)
        .collection('lobby')
        .document(widget.roomName)
        .setData({'waiting room': details});
    print('-----------11');

    print('-----------1111');
         Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Student()),
                          (Route<dynamic> route) => false,
                        );
    // Navigator.pushReplacement(context,
    //     MaterialPageRoute(builder: (BuildContext context) => Student()));
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}
