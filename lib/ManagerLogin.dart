import 'package:events_freelance/ForgetScreen.dart';
import 'package:events_freelance/create_post_screen.dart';
import 'package:events_freelance/screens/Loading.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import './screens/CreateAccountPage.dart';
import 'Animation/FadeAnimation.dart';

class ManagerLogin extends StatefulWidget {
  @override
  _ManagerLoginState createState() => _ManagerLoginState();
}

class _ManagerLoginState extends State<ManagerLogin> {
  final userRef = Firestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  Color myColor = Colors.blue;
  String email;
  String password;
  bool loading = false;
  final tokenRef = Firestore.instance.collection('Tokens');
  FirebaseMessaging messaging = FirebaseMessaging();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(30, 31, 45, 1),
          title: Text(
            "Login",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: loading
            ? Loading()
            : SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.white,
                      Colors.blue,
                      Colors.green,
                      Colors.red,
                      Colors.white
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  ),
                  child: FadeAnimation(
                    0.5,
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: height - 20,
                        width: width - 20,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(26, 27, 45, 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade600, blurRadius: 5),
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: height * 0.04,
                            ),
                            FadeAnimation(
                              1.0,
                              Container(
                                height: height * 0.3,
                                width: width * 0.7,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: AssetImage("images/logo.png"),
                                )),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.05,
                            ),
                            FadeAnimation(
                              1.3,
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Container(
                                  height: height / 13,
                                  width: width - 100,
                                  color: Color.fromRGBO(93, 83, 207, 1),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: TextField(
                                      style: new TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        hintText: "Email address",
                                        hintStyle: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                      onChanged: (val) {
                                        email = val;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            FadeAnimation(
                              1.6,
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Container(
                                  color: Color.fromRGBO(93, 83, 207, 1),
                                  height: height / 13,
                                  width: width - 100,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: TextField(
                                      obscureText: true,
                                      style: new TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        hintText: "Password",
                                        hintStyle: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                      onChanged: (val) {
                                        password = val;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            FadeAnimation(
                              1.9,
                              Container(
                                width: 150,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: myColor,
                                ),
                                child: FlatButton(
                                    onPressed: () async {
                                      messaging.getToken().then((token) {
                                        tokenRef
                                            .document(email)
                                            .setData({'Token': token});
                                        print('Token uploaded');
                                      });

                                      setState(() {
                                        loading = true;
                                      });
                                      try {
                                        DocumentSnapshot query =
                                            await userRef.document(email).get();

                                        if (query.exists) {
                                          if (query['type'] != "Manager") {
                                            Alert(
                                                    context: context,
                                                    title: "Error !",
                                                    desc:
                                                        "This email is associated with another account")
                                                .show();
                                            setState(() {
                                              loading = false;
                                            });
                                          } else {
                                            try {
                                              auth.signOut();
                                              AuthResult a = await auth
                                                  .signInWithEmailAndPassword(
                                                      email: email,
                                                      password: password);
                                              if (a.user != null) {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CreatePost()));
                                              }

                                              setState(() {
                                                loading = false;
                                              });
                                            } catch (e) {
                                              Alert(
                                                      context: context,
                                                      title: "Error !",
                                                      desc:
                                                          "Password should be minimum 8 characters")
                                                  .show();
                                              setState(() {
                                                loading = false;
                                              });
                                            }
                                          }
                                        } else {
                                          try {
                                            if (password.length < 8) {
                                              Alert(
                                                      context: context,
                                                      title: "Error !",
                                                      desc:
                                                          "Password should be minimum 8 characters")
                                                  .show();
                                            } else {
                                              Alert(
                                                context: context,
                                                type: AlertType.error,
                                                title: "Error",
                                                desc: "No account found",
                                                buttons: [
                                                  DialogButton(
                                                    child: Text(
                                                      "Okay",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20),
                                                    ),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    width: 120,
                                                  )
                                                ],
                                              ).show();

                                              // Navigator.of(context).push(
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             CreatePost()));
                                            }

                                            setState(() {
                                              loading = false;
                                            });
                                          } catch (e) {
                                            Alert(
                                                    context: context,
                                                    title: "Error !",
                                                    desc: "Check credentials !")
                                                .show();
                                          }
                                        }
                                      } catch (e) {
                                        Alert(
                                                context: context,
                                                title: "Error !",
                                                desc: "Check credentials !")
                                            .show();
                                      }
                                    },
                                    child: Center(
                                        child: Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22),
                                    ))),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            FadeAnimation(
                              2.2,
                              FlatButton(
                                child: Text(
                                  'Forget Password?',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ForgetScreen()));
                                },
                              ),
                            ),
                            SizedBox(
                              height: height * 0.04,
                            ),

                            // Uncomment this whole row kaushik

                             /*FadeAnimation(
                               2.5,
                               Row(
                                 children: <Widget>[
                                  Padding(
                                     padding:
                                         EdgeInsets.only(left: width * 0.15),
                                     child: Text(
                                      "Don't have a account ?",
                                       style: TextStyle(
                                         color: Colors.white, fontSize: 16.0),
                                     ),
                                   ),
                                   SizedBox(
                                     width: width * 0.03,
                                   ),
                                   GestureDetector(
                                     onTap: () {
                                       Navigator.of(context).push(
                                         MaterialPageRoute(
                                           builder: (context) => CreateAccount(
                                             "Manager",
                                           ),
                                         ),
                                       );
                                     },
                                     child: Text(
                                       "Create One",
                                       style: TextStyle(
                                         color: Colors.white,
                                         fontSize: 16.0,
                                         decoration: TextDecoration.underline,
                                       ),
                                     ),
                                   ),
                                 ],
                               ),
                             ),*/
                             //upper section comment ends

//                      Uncomment  this afterwards
                            //lower section comment starts
                             Text(
                              "Manager signup coming soon..",
                              style: TextStyle(color: Colors.yellow, fontSize: 20.0),
                            ),
                            //lower section comment ends
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ));
  }
}
