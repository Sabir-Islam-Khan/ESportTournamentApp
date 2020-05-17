import 'package:events_freelance/UserSignin.dart';
import 'package:events_freelance/home_screen.dart';
import 'package:events_freelance/model/Post.dart';
import 'package:events_freelance/screens/Loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgetScreen extends StatefulWidget {
  ForgetScreen({this.post,this.t});
  String t;
  Post post;
  @override
  _ForgetScreenState createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  Color myColor=Colors.blue;
  String email;
  FirebaseAuth auth=FirebaseAuth.instance;
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Color.fromRGBO(30, 31, 45, .6),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(30, 31, 45, 1),
          title: Text(
            "Forget",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: loading?Loading():Padding(
          
          padding: const EdgeInsets.all(10.0),
          child: Container(
          
            height: height-20,
            width: width-20,
            decoration: BoxDecoration(
              color: Color.fromRGBO(30, 31, 45, 1),
              
                borderRadius: BorderRadius.all(Radius.circular(20),),
                boxShadow: [
              BoxShadow(
                color: myColor,
                blurRadius: 15.0,
              ),
                ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 50,),
                Container(
                  height: height/10,
                  width: width-150,
                  child: TextField(
                    style: TextStyle(color: Colors.yellow),
                    decoration: InputDecoration(

                      hintText: "Email",
                      hintStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    onChanged: (val){
                      email=val;
                    },
                  ),

                ),





                Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: myColor,
                  ),
                  child: FlatButton(
                      onPressed: ()async{
                          auth.sendPasswordResetEmail(email: email);
                          Fluttertoast.showToast(msg: 'Please check email');
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage()));
                      },
                      child: Center(child: Text("Reset",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 22),))),
                ),




              ],
            ),
          ),
        )
    );  }
}
