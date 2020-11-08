import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/feature_flag/feature_flag_enum.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:schoolapp/teacher_screens/teacher.dart';

import '../colors.dart';

class TeacherMeeting extends StatefulWidget {
  final schoolCode;
   final name ;

  const TeacherMeeting({Key key, this.schoolCode, this.name}) : super(key: key);
  @override
  _TeacherMeetingState createState() => _TeacherMeetingState();
}

class _TeacherMeetingState extends State<TeacherMeeting> {
  final serverText = TextEditingController();
  final roomText = TextEditingController();
  final subjectText = TextEditingController(text: "");
  final nameText = TextEditingController(text: "");
  final emailText = TextEditingController(text: "fake@email.com");
 
  final iosAppBarRGBAColor =
      TextEditingController(text: "#0080FF80"); //transparent blue
  var isAudioOnly = true;
  var isAudioMuted = true;
  var isVideoMuted = true;
  List _myActivities;
  var time= DateTime.now().microsecondsSinceEpoch.toString();
  String _myActivitiesResult;
  final formKey = new GlobalKey<FormState>();
  List<List<String>> currentClass = [
    ['', '']
  ];
  @override
  void initState() {
    print("-----------------11111111111111111111111111111111111111111");
    print(time);
    super.initState();
    _myActivities = [];
    _myActivitiesResult = '';
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: offwhite,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Meeting",
            style: TextStyle(
                color: darkblue, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          actions: [
                  
                
                         IconButton(icon: Icon(Icons.info_outline,color: orange, size: 30,),tooltip: "File Size should be less than 50 KB",
                    
                    onPressed: (){
                   Flushbar(
                                  title: "Note",
                                  message: "As a best practice, please append your name initials and date after the desired meeting name",
                                  duration: Duration(seconds: 5),
                                  margin: EdgeInsets.all(8),
                                  borderRadius: 8,
                                )..show(context);
                    },),
              ],
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: darkblue,
              ),
              onPressed: () => Navigator.pop(context)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 24.0,
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextField(
                    controller: roomText,
                    decoration: InputDecoration(
                      hintText: 'Room Name',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    )),
                SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  height: 16.0,
                ),
                // TextField(
                //   controller: nameText,
                //   decoration: InputDecoration(
                //     hintText: 'Display Name',
                //     enabledBorder: UnderlineInputBorder(
                //       borderSide: BorderSide(color: Colors.transparent),
                //     ),
                //     focusedBorder: UnderlineInputBorder(
                //       borderSide: BorderSide(color: Colors.transparent),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 16.0,
                ),
                Container(
                  height: h/5,
             
                  child: ListView.builder(
                    itemCount: currentClass.length,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: w/5,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Class',
                              ),
                              onChanged: (val) {
                                currentClass[index][0] = val;
                              },
                            ),
                          ),
                          Container(
                          width: w/5,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Section',
                              ),
                              onChanged: (val) {
                                currentClass[index][1] = val;
                              },
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
                RaisedButton(
                  color: orange,
                   padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  child: Text('Add Class',style: style,),
                  onPressed: () {
                    var a = currentClass;
                    a.add(['', '']);
                    setState(() {
                      currentClass = a;
                    });
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                CheckboxListTile(
                  activeColor: orange,
                  title: Text("Audio Only"),
                  value: isAudioOnly,
                  onChanged: _onAudioOnlyChanged,
                ),
                SizedBox(
                  height: 16.0,
                ),
                CheckboxListTile(
                  activeColor: orange,
                  title: Text("Audio Muted"),
                  value: isAudioMuted,
                  onChanged: _onAudioMutedChanged,
                ),
                SizedBox(
                  height: 16.0,
                ),
                CheckboxListTile(
                  activeColor: orange,
                  title: Text("Video Muted"),
                  value: isVideoMuted,
                  onChanged: _onVideoMutedChanged,
                ),
                Divider(
                 
                  thickness: 2.0,
                ),
               SizedBox(
                  height: h / 30,),
                SizedBox(
                  height: h / 12,
                  width: double.maxFinite,
                  child: RaisedButton(
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      if (roomText.text == "" ) {
                        Flushbar(
                          title: "Error",
                          message: "Please fill all the fields",
                          duration: Duration(seconds: 3),
                          margin: EdgeInsets.all(8),
                          borderRadius: 8,
                        )..show(context);
                      } else {
                        _joinMeeting();
                      }
                    },
                    child: Text("Join Meeting", style: style),
                    color: orange,
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
              ],
            ),
          ),
        ),
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

      // Define meetings options here
      var options = JitsiMeetingOptions()
        ..room = roomText.text+time
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

  void _onConferenceJoined({message}) {
    var a = [];
    for (int i = 0; i < currentClass.length; i++) {
      a.add(currentClass[i][0] + '-' + currentClass[i][1]);
    }
    Firestore.instance
        .collection('schools')
        .document(widget.schoolCode)
        .collection('lobby')
        .document(roomText.text)
        .setData({'waiting room': [], 'classes': a ,'pwd': time});
  }

  void _onConferenceTerminated({message}) {
    Firestore.instance
        .collection('schools')
        .document(widget.schoolCode)
        .collection('lobby')
        .document(roomText.text)
        .delete();
    Navigator.pop(context);
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}
