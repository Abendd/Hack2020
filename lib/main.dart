import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schoolapp/colors.dart';
import 'package:schoolapp/login.dart';
import 'package:schoolapp/student_screens/student.dart';
import 'package:schoolapp/teacher_screens/timetable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'teacher_screens/teacher.dart';
import 'widgets/drawer.dart';

final Mydrawer drawer = new Mydrawer();
void main() => runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/student': (context) => Student(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/teacherHome': (context) => TeacherHome(),
      },
    ));

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
void initState(){
  super.initState();
  SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
       DeviceOrientation.portraitDown,
      
  ]);
}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(

      future: getVariable(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
        
          if (snapshot.data[0]) {
            return MaterialApp(

              debugShowCheckedModeBanner: false,
              home: Login(),
            );
          }
          if (snapshot.data[1] == 'Student') {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Student(),
            );
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: TeacherHome(),
            );
          }
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  getVariable() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return [pref.getBool('signedIn') == null, pref.getString('type')];
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 2,
        
        navigateAfterSeconds: new MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MyApp(),
        ),
        title: new Text(
          'edDox',
          style: new TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 52),
        ),
        //  image: new Image.network('https://i.imgur.com/TyCSG9A.png'),
        backgroundColor: dullpurple,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: () => print("Flutter Egypt"),
        loaderColor: dullpurple);
  }
}
