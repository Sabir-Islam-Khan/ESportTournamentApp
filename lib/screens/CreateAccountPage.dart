import 'package:events_freelance/ManagerLogin.dart';
import 'package:events_freelance/home_screen.dart';
import 'package:events_freelance/model/Post.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_freelance/screens/Loading.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_freelance/create_post_screen.dart';
import 'package:events_freelance/RegisterationForm.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

import '../Queries.dart';
import '../Widgets/BezierContainer.dart';
import '../Animation/FadeAnimation.dart';

class CreateAccount extends StatefulWidget {
  final String type;
  final Post post;
  final String x;
  CreateAccount(this.type, [this.post, this.x]);
  @override
  State<StatefulWidget> createState() {
    return CreateAccountState();
  }
}

class CreateAccountState extends State<CreateAccount> {
  final userRef = Firestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  Color myColor = Colors.blue;
  String email;
  String password;
  bool loading = false;
  final tokenRef = Firestore.instance.collection('Tokens');
  FirebaseMessaging messaging = FirebaseMessaging();

  // Controllers and other variables
  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();

  final db = Firestore.instance;
  // Widget for Top button
  @override
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Color(0xffe46b10)),
            ),
            Text('Back',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xffe46b10)))
          ],
        ),
      ),
    );
  }

  // Widget for entry field
  // This is actually a combination to code less

  Widget _entryField(String title, TextEditingController txController,
      {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xffe46b10)),
          ),
          SizedBox(
            height: 10,
          ),

          // Maybe convert this into form later
          // It works for now
          TextField(
            obscureText: isPassword,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
            controller: txController,
          )
        ],
      ),
    );
  }

  // Register button
  // some process needs to be changed later
  Widget _submitButton() {
    email = mailController.value.text;
    password = passwordController.value.text;
    return FadeAnimation(
      3.4,
      GestureDetector(
        onTap: () async {
          if (widget.type == "Manager") {
            messaging.getToken().then((token) {
              tokenRef.document(email).setData({'Token': token});
              print('Token uploaded');
            });

            // setState(() {
            //   loading = true;
            // });

            DocumentSnapshot query = await userRef.document(email).get();

            if (query.exists) {
              auth.signOut();
              AuthResult a = await auth.signInWithEmailAndPassword(
                  email: email, password: password);
              if (a.user != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreatePost(),
                  ),
                );
              }

              setState(() {
                loading = false;
              });
            } else {
              if (password.length < 8) {
                Alert(
                        context: context,
                        title: "Error !",
                        desc: "Password should be minimum 8 characters")
                    .show();
              } else {
                auth.createUserWithEmailAndPassword(
                    email: email, password: password);
                userRef.document(email).setData({
                  "email": email,
                  "type": "Manager",
                  "registerations": 0,
                  "phone": phoneController.value.text,
                  "trans_count": 0,
                  "name": nameController.value.text,
                  "last_reg": "Please Register First",
                });

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreatePost(),
                  ),
                );
              }

              setState(() {
                loading = false;
              });
            }
          }

          if (widget.type == "User") {
            messaging.getToken().then((token) {
              tokenRef.document(email).setData({'Token': token});
              print('Token uploaded');
            });

            // setState(() {
            //   loading = true;
            // });

            DocumentSnapshot query = await userRef.document(email).get();

            if (query.exists) {
              auth.signOut();
              AuthResult a = await auth.signInWithEmailAndPassword(
                  email: email, password: password);
              if (a.user != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RegisterationForm(
                      post: widget.post,
                      email: email,
                    ),
                  ),
                );
              }

              setState(() {
                loading = false;
              });
            } else {
              if (password.length < 8) {
                Alert(
                        context: context,
                        title: "Error !",
                        desc: "Password should be minimum 8 characters")
                    .show();
              } else {
                auth.createUserWithEmailAndPassword(
                    email: email, password: password);
                userRef.document(email).setData({
                  "email": email,
                  "type": "General",
                  "registerations": 0,
                  "phone": phoneController.value.text,
                  "trans_count": 0,
                  "name": nameController.value.text,
                  "last_reg": "Please register first",
                });

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RegisterationForm(
                      post: widget.post,
                      email: email,
                    ),
                  ),
                );
              }

              setState(() {
                loading = false;
              });
            }
          }
        },
        child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.cyan[200],
                      offset: Offset(2, 4),
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color.fromRGBO(93, 83, 207, 1),
                      Color.fromRGBO(93, 83, 207, .9)
                    ])),
            child: FadeAnimation(
              1.5,
              Text(
                'Register Now',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            )),
      ),
    );
  }

  // label on the bottom of the page
  Widget _loginAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FadeAnimation(
            3.7,
            Text('Already have an account ?',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManagerLogin()),
                );
              },

              // TODO: convert this into button later
              child: FadeAnimation(
                3.7,
                Text(
                  'Login',
                  style: TextStyle(
                      color: Color(0xfff79c4f),
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ))
        ],
      ),
    );
  }

  // widget for the title
  Widget _title() {
    return FadeAnimation(
      1.8,
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'Lob',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xffe46b10),
            ),
            children: [
              TextSpan(
                text: 'by',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              TextSpan(
                text: 'of',
                style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
              ),
              TextSpan(
                text: 'Gam',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              TextSpan(
                text: 'es',
                style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
              ),
            ]),
      ),
    );
  }

  final phoneController = TextEditingController();
  // Entry fields column
  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        FadeAnimation(
          2.2,
          _entryField("Username", nameController),
        ),
        FadeAnimation(
          2.4,
          _entryField("Phone", phoneController),
        ),
        FadeAnimation(2.6, _entryField("Email id", mailController)),
        FadeAnimation(
            3.0, _entryField("Password", passwordController, isPassword: true)),
      ],
    );
  }

  // main page
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Color.fromRGBO(26, 26, 48, .9),
            body: SingleChildScrollView(
                child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: SizedBox(),
                        ),
                        _title(),
                        SizedBox(
                          height: 50,
                        ),
                        _emailPasswordWidget(),
                        SizedBox(
                          height: 20,
                        ),
                        _submitButton(),
                        Expanded(
                          flex: 2,
                          child: SizedBox(),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _loginAccountLabel(),
                  ),
                  Positioned(top: 40, left: 0, child: _backButton()),
                  Positioned(
                      top: -MediaQuery.of(context).size.height * .15,
                      right: -MediaQuery.of(context).size.width * .4,
                      child: FadeAnimation(1, BezierContainer()))
                ],
              ),
            )));
  }

  // dont know need this or not
  // just keeping it in case gonna need it
  void createData() async {
    //   DocumentReference ref = await db.collection('USERS').add(
    //     {'name': '${nameController.value.text}',
    //     'mail': '${mailController.value.text}',
    //     'password': '${passwordController.value.text}',
    //     },
    //     );
  }
}
