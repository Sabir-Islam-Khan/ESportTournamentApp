import 'package:events_freelance/home_screen.dart';
import 'package:events_freelance/model/Post.dart';
import 'package:events_freelance/screens/Loading.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../UserSignin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "../screens/Loading.dart";

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  final subRef = Firestore.instance.collection("Users");
  String name = "Username";
  String email = "user@mail.com";
  String phone = "464778543";
  int event_count = 0;
  int trans_count = 0;

  bool isDone = false;
  List<Widget> events = new List();
  List<Widget> trans = new List();
  DocumentSnapshot doc;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      email = user.email;
      subRef.document(email).get().then((data) {
        setState(() {
          doc = data;
          if(doc['last_reg'] == null) {

            setState(() {
              doc.data['last_reg'] = "Fetching data";
            });

          }
        });
        name = data["name"];
        phone = data["phone"];
        event_count = data["registerations"];
        trans_count = data["trans_count"];
        // for (int i = 0; i < event_count; i++) {
        //   events.add(
        //     ListTile(
        //       title: Text("Last registered event :",
        //           style: TextStyle(color: Colors.white),),
        //       subtitle: Text( data['last_reg'] ,
        //           style: TextStyle(color: Colors.white),),

        //     ),
        //   );
        // }
        // for (int i = 0; i < trans_count; i++) {
        //   trans.add(
        //     ListTile(
        //       // title: Text(data["transections"][i]["count"],
        //       //     style: TextStyle(color: Colors.white)),
        //       // subtitle: Text(data["transections"][i]["date"],
        //       //     style: TextStyle(color: Colors.white)),
        //       title: Text(
        //         "Stay tuned for detailed profile ! Game on",
        //         style: TextStyle(
        //           color: Colors.yellow,
        //         ),
        //       ),
        //     ),
        //   );
        // }
        setState(() {
          isDone = true;
        });
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (!isDone)
      return Loading();
    else
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(30, 31, 45, 1),
          title: Text(
            "Profile",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontFamily: "Cupertino"),
          ),
        ),
        backgroundColor: Color.fromRGBO(30, 31, 45, .6),
        body: Container(
          child: ListView(
            children: <Widget>[
              Card(
                color: Color.fromRGBO(30, 31, 45, 1),
                child: Container(
                  height: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CircleAvatar(
                        child: Icon(Icons.person, size: 50),
                        radius: 45,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            name,
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Container(height: 3),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.email,
                                color: Colors.grey,
                                size: 15,
                              ),
                              Container(
                                width: 5,
                              ),
                              Text(
                                email,
                                style:
                                    TextStyle(fontSize: 15, color: Colors.grey),
                              )
                            ],
                          ),
                          Container(height: 3),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.phone,
                                color: Colors.grey,
                                size: 15,
                              ),
                              Container(
                                width: 5,
                              ),
                              Text(
                                phone,
                                style:
                                    TextStyle(fontSize: 15, color: Colors.grey),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 20.0,
                  left: MediaQuery.of(context).size.width * 0.25,
                ),
                child: Text(
                  "Last registered Event :",
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 27.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 10.0,
                  left: MediaQuery.of(context).size.width * 0.3,
                ),
                child: Text(
                  doc["last_reg"],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                 top: MediaQuery.of(context).size.height *0.54,
                  left: MediaQuery.of(context).size.width * 0.15
                ),
                              child: Text(
                  "Stay tuned for more features",
                  style: TextStyle(
                    color: Colors.red[400],
                    fontSize: 25.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
