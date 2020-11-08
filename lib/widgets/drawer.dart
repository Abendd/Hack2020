
import 'package:flutter/material.dart';

class Mydrawer extends StatefulWidget {
  String email;
  String imageUrl;
  String name;
  Mydrawer({this.email, this.name, this.imageUrl});
  @override
  _MydrawerState createState() => _MydrawerState();
}

class _MydrawerState extends State<Mydrawer> {
  

  bool loggedin = true;

  // void inputData() async {
  //   final FirebaseUser user = await _auth.currentUser();
  //   final uid = user.uid;
  //   if (uid != null)
  //   {
  //     setState(() {
  //    loggedin = false ;
  //   });
  //   }
  //   // here you write the codes to input the data into firestore
  // }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Drawer(
      child: ListView(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        //padding: EdgeInsets.all(0),
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 50, bottom: 20),
            color: Colors.white24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // ClipOval(
                //   child: Image.asset(
                //     imageUrl,
                //     width: 100,
                //     height: 100,
                //   ),
                // ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                //    signOutGoogle();
                  },
                  child: Text(
                    'SNEAKER APP',
                    style: TextStyle(color: Colors.black, fontSize: 28),
                  ),
                ),
                //   SizedBox(height: 10),
                // Text(
                //   'email',
                //   style: TextStyle(color: Colors.black),
                // ),
              ],
            ),
          ),
          // ListTile(
          //   leading: Icon(Icons.all_inclusive),
          //   title: Text("Home"),
          //   onTap: () {
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(builder: (context) => FirstScreen()),
          //     // );
          //   },
          // ),
          ListTile(
      //        leading: Image.asset('images/nike.png',scale: 15,),
              title: Text("Nike",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400),),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Services()),
                // );
              }),
          SizedBox(height: 20,),
          ListTile(
              leading: Image.network('https://img.icons8.com/ios-filled/100/000000/air-jordan.png',scale: 3,),
              title: Text("Jordon",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400),),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => About()),
                // );
              }),
              SizedBox(height: 20,),
          ListTile(
              leading:Image.network('https://img.icons8.com/ios-filled/100/000000/adidas-trefoil.png',scale:3,),
              title: Text("Yeezy",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400),),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => About()),
                // );
              }),
          //  ListTile(
          //     leading: Icon(Icons.all_inclusive),
          //     title: Text("Order Notification"),
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => OrderNot()),
          //       );
          //     },
          //   ),
SizedBox(height: 25,),
          ListTile(
            leading: Icon(Icons.home,size: 30,color: Colors.black,),
            title: Text("Delivery Address",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400),),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => UserDetails()),
              // );
            },
          ),
          SizedBox(height: 20,),
          ListTile(
              leading: Icon(Icons.polymer,size: 30,color: Colors.black,),
              title: Text("About",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400),),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => About()),
                // );
              }),

//ListTile(leading: Container(height: 100,),),
          new Divider(
            height: 30,
            thickness: 0,
            color: Colors.white,
          ),
          ListTile(
              leading: Container(
            margin: EdgeInsets.only(top: 10, left: 60),
            width: 150,
            height: 150,
            child: RaisedButton(
              onPressed: () {
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (context) => Login()));
                // : signOutGoogle();
              },
              color: Colors.black,
              child: Container(
                //  margin: EdgeInsets.only(top:20),
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  loggedin ? 'Sign In' : 'Sign Out',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          )),

          Container(
            margin: EdgeInsets.only(top:h/5,),
            child: Column(
              children: <Widget>[
                Text("Developer"),
                Text("Rishabh Sharma",style: TextStyle(fontSize: 14, color: Colors.black,fontWeight: FontWeight.w500),),
              ],
            ))
        ],
      ),
    );
  }
}
