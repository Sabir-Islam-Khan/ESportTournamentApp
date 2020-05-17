import 'package:events_freelance/home_screen.dart';
import 'package:events_freelance/model/Post.dart';
import 'package:events_freelance/nextScreen.dart';
import 'package:events_freelance/screens/Loading.dart';
import 'package:events_freelance/screens/pay.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegisterationForm extends StatefulWidget {
  RegisterationForm({this.post, this.email});
  Post post;
  String email;

  String dropdownValue = "1";
  String teamName;
  String teamID;
  String transactionID;
  String phn;
  String name;
  String pID;
  String transID;

  @override
  _RegisterationFormState createState() => _RegisterationFormState();
}

class _RegisterationFormState extends State<RegisterationForm> {
  final userRef = Firestore.instance.collection('Users');
  final subRef = Firestore.instance.collection("Users");
  var singleRegRef;
  bool loading = false;
  Color myColor = Colors.blue;
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    singleRegRef = widget.post.Teams == 'true'
        ? Firestore.instance.collection("TeamRegisterations")
        : Firestore.instance.collection("SingleRegisterations");
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(30, 31, 45, .97),
        title: Text(
          "Register",
          style: TextStyle(color: myColor, fontSize: 18),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Sign Out',
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
        ],
      ),
      body: loading
          ? Center(
              child: Loading(),
            )
          : (widget.post.Teams == "true" ? teamForm() : singleForm()),
    );
  }

  teamForm() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(0.00),
        child: Container(
          child: Container(
            color: Color.fromRGBO(30, 31, 45, 1),
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Register yourself here',
                    style: TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  height: height / 10,
                  width: width - 40,
                  child: TextField(
                    style: TextStyle(color: Colors.yellow),
                    maxLength: 30,
                    decoration: InputDecoration(
                      hintText: "Team Name",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    onChanged: (val) {
                      widget.teamName = val;
                    },
                  ),
                ),
                Container(
                  height: height / 10,
                  width: width - 40,
                  margin: EdgeInsets.only(left: 10.0),
                  child: TextField(
                    style: TextStyle(color: Colors.yellow),
                    maxLength: 30,
                    decoration: InputDecoration(
                      hintText: "Contact number",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    onChanged: (val) {
                      widget.phn = val;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: myColor,
                      ),
                      child: FlatButton(
                          onPressed: () {
                            if (widget.teamName == null || widget.phn == null) {
                              Alert(
                                context: context,
                                type: AlertType.error,
                                title: "Error",
                                desc:
                                    "Values can't be empty ! Please fill every section of form",
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "Okay",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    width: 120,
                                  )
                                ],
                              ).show();
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => NextScreen(
                                        members: int.parse(widget.post.Members),
                                        teamID: widget.teamID.toString(),
                                        teamName: widget.teamName.toString(),
                                        transaction:
                                            widget.transactionID.toString(),
                                        post: widget.post,
                                        email: widget.email.toString(),
                                        phone: widget.phn,
                                      )));
                            }
                          },
                          child: Center(
                              child: Text(
                            "Next",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 22),
                          ))),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  singleForm() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          color: Color.fromRGBO(30, 31, 45, 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Register yourself here',
                  style: TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
              ),
              Container(
                height: height / 10,
                width: width - 40,
                margin: EdgeInsets.only(left: 15.0),
                child: TextField(
                  style: TextStyle(color: Colors.yellow),
                  maxLength: 30,
                  decoration: InputDecoration(
                    hintText: "Name",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  onChanged: (val) {
                    widget.name = val;
                  },
                ),
              ),
              Container(
                height: height / 10,
                width: width - 40,
                margin: EdgeInsets.only(left: 15.0),
                child: TextField(
                  style: TextStyle(color: Colors.yellow),
                  maxLength: 30,
                  decoration: InputDecoration(
                    hintText: "Game ID",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  onChanged: (val) {
                    widget.pID = val;
                  },
                ),
              ),
              widget.post.Free.toString() == 'true'
                  ? Container()
                  : Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        ),
                        Text(
                          "Fee :   ${widget.post.Fee}",
                          style: TextStyle(
                            color: Colors.redAccent[400],
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
              SizedBox(
                height: 25.0,
              ),
              Container(
                height: height / 10,
                width: width - 40,
                margin: EdgeInsets.only(left: 15.0),
                child: TextField(
                  style: TextStyle(color: Colors.redAccent[400]),
                  maxLength: 10,
                  decoration: InputDecoration(
                    hintText: "Contact number",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                        color: Colors.redAccent[400]),
                  ),
                  onChanged: (val) {
                    widget.phn = val;
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  widget.post.Free.toString() == "true"
                      ? Container(
                          width: MediaQuery.of(context).size.width * .5,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: myColor,
                          ),
                          child: FlatButton(
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });

                              bool a = await checkUser();
                              if (!a) {
                                if (widget.name == null ||
                                    widget.pID == null ||
                                    widget.phn == null) {
                                  Alert(
                                    context: context,
                                    type: AlertType.error,
                                    title: "Error",
                                    desc:
                                        "Values can't be empty ! Please fill every section of form",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "Okay",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        width: 120,
                                      )
                                    ],
                                  ).show();
                                  setState(){
                                    loading = false;
                                  }
                                } else {
                                  int i;
                                  DocumentSnapshot x = await userRef
                                      .document(widget.email)
                                      .get();
                                  i = x['registerations'];
                                  i = i + 1;

                                  await singleRegRef
                                      .document("Registerations")
                                      .collection(widget.post.ID)
                                      .document(widget.email)
                                      .setData({
                                    "Name": widget.name.toString(),
                                    "TransactionID": widget.transID.toString(),
                                    "RID": widget.pID.toString(),
                                    'Contact': widget.phn.toString(),
                                    'Time': Timestamp.now()
                                  });

                                  subRef.document(widget.email).updateData({
                                    "last_reg": widget.post.EventName,
                                  });

                                  Fluttertoast.showToast(
                                      msg: 'Registration Complete');

                                  await userRef
                                      .document(widget.email)
                                      .updateData({
                                    'registerations': i,
                                  });
                                  setState(() {
                                    loading = false;
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(),
                                    ),
                                  );
                                }
                              } else {
                                Alert(
                                  context: context,
                                  type: AlertType.error,
                                  title: "Error",
                                  desc: "You already registered to this event",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "Okay",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      width: 120,
                                    )
                                  ],
                                ).show();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                );
                              }
                            },
                            child: Center(
                              child: Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width * .5,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: myColor,
                          ),
                          child: FlatButton(
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });

                              bool a = await checkUser();
                              if (!a) {
                                if (widget.name == null ||
                                    widget.pID == null ||
                                    widget.phn == null) {
                                  Alert(
                                    context: context,
                                    type: AlertType.error,
                                    title: "Error",
                                    desc:
                                        "Values can't be empty ! Please fill every section of form",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "Okay",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        width: 120,
                                      )
                                    ],
                                  ).show();
                                  setState(() {
                                    loading = false;
                                  });
                                } else {
                                  int i;
                                  DocumentSnapshot x = await userRef
                                      .document(widget.email)
                                      .get();
                                  i = x['registerations'];
                                  i = i + 1;

                                  await singleRegRef
                                      .document("Registerations")
                                      .collection(widget.post.ID)
                                      .document(widget.email)
                                      .setData({
                                    "Name": widget.name.toString(),
                                    "TransactionID": widget.transID.toString(),
                                    "RID": widget.pID.toString(),
                                    'Contact': widget.phn.toString(),
                                    'Time': Timestamp.now()
                                  });

                                  subRef.document(widget.email).updateData({
                                    "last_reg": widget.post.EventName,
                                  });
                                  Fluttertoast.showToast(
                                      msg: 'Pay with prefered method');

                                  await userRef
                                      .document(widget.email)
                                      .updateData({
                                    'registerations': i,
                                  });
                                  setState(() {
                                    loading = false;
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Screen(
                                        widget.post.Fee,
                                        "k787846@okaxis",
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                Alert(
                                  context: context,
                                  type: AlertType.error,
                                  title: "Error",
                                  desc: "You already registered to this event",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "Okay",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      width: 120,
                                    )
                                  ],
                                ).show();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                );
                              }
                            },
                            child: Center(
                              child: Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> checkUser() async {
    singleRegRef = Firestore.instance.collection('SingleRegisterations');
    DocumentSnapshot query = await singleRegRef
        .document("Registerations")
        .collection(widget.post.ID)
        .document(widget.email)
        .get();

    if (!query.exists) {
      return false;
    }

    Fluttertoast.showToast(msg: 'User already registered');
    return true;
  }
}
