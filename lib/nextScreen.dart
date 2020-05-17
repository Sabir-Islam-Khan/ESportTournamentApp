import 'package:events_freelance/home_screen.dart';
import 'package:events_freelance/model/Post.dart';
import 'package:events_freelance/screens/Loading.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uuid/uuid.dart';
import 'package:events_freelance/screens/pay.dart';

class NextScreen extends StatefulWidget {
  NextScreen(
      {this.members,
      this.teamName,
      this.teamID,
      this.transaction,
      this.post,
      this.email,
      this.phone});
  String teamName;
  String teamID;
  String transaction;
  int members;
  Post post;
  String email;
  String phone;
  @override
  _NextScreenState createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  final userRef = Firestore.instance.collection('Users');
  final teamRegRef = Firestore.instance.collection("TeamRegisterations");
  final teamRef = Firestore.instance.collection("Teams");
  bool loading = false;
  final subRef = Firestore.instance.collection("Users");
  List<String> names = [];
  List<String> ids = [];

  @override
  Widget build(BuildContext context) {
    Color myColor = Colors.blue;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<Widget> children = [];

    for (int i = 0; i < widget.members; i++) {
      names.add(" ");
      ids.add(" ");
      children.add(Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Container(
              height: height / 10,
              width: width - 40,
              child: TextField(
                style: TextStyle(color: Colors.yellow),
                maxLength: 30,
                decoration: InputDecoration(
                  hintText: (i + 1).toString() + ".Member Name",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.white),
                ),
                onChanged: (val) {
                  names[i] = val;
                },
              ),
            ),
            Container(
              height: height / 10,
              width: width - 40,
              child: TextField(
                style: TextStyle(color: Colors.yellow),
                maxLength: 30,
                decoration: InputDecoration(
                  hintText: "Member ID",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.yellow),
                ),
                onChanged: (val) {
                  ids[i] = val;
                },
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ));
    }

    children.add(
      widget.post.Free.toString() == 'true'
          ? Container()
          : Container(
              margin: EdgeInsets.only(bottom: 40.0),
              height: height / 25,
              width: width - 40,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  ),
                  Text(
                    "Fee :   Free Event",
                    style: TextStyle(
                      color: Colors.redAccent[400],
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
    );

    children.add(
      widget.post.Free == "true"
          ? Container(
              width: 220,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: myColor,
              ),
              child: FlatButton(
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });

                  bool a = await checkUser();

                  if (!a) {
                    bool checker = true;
                    for (int i = 0; i < widget.members; i++) {
                      if (names[i] == null || ids[i] == null) {
                        setState(() {
                          checker = false;
                        });
                      } else {
                        await teamRef
                            .document(widget.post.ID)
                            .collection(widget.email)
                            .document()
                            .setData({
                          "Name": names[i],
                          "Number": (i + 1).toString(),
                          "ID": ids[i],
                        });
                      }
                    }
                    if (checker == true) {
                      String id = Uuid().v4();
                      await teamRegRef
                          .document("Registerations")
                          .collection(widget.post.ID)
                          .document(widget.email)
                          .setData({
                        "Name": widget.teamName,
                        "Time": Timestamp.now(),
                        "Members": widget.members.toString(),
                        "TransactionID": widget.transaction,
                        "RID": widget.teamID,
                        "ID": id.toString(),
                        'Contact': widget.phone.toString()
                      });

                      subRef.document(widget.email).updateData({
                        "last_reg": widget.post.EventName,
                      });

                      setState(() {
                        loading = false;
                      });
                      Fluttertoast.showToast(msg: "Registration Complete");
                    } else {
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () => Navigator.pop(context),
                            width: 120,
                          )
                        ],
                      ).show();

                      setState(() {
                        loading = false;
                      });
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
                            style: TextStyle(color: Colors.white, fontSize: 20),
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

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
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
              width: 220,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: myColor,
              ),
              child: FlatButton(
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });

                  bool a = await checkUser();

                  if (!a) {
                    bool checker = true;
                    for (int i = 0; i < widget.members; i++) {
                      if (names[i] == null || ids[i] == null) {
                        setState(() {
                          checker = false;
                        });
                      } else {
                        await teamRef
                            .document(widget.post.ID)
                            .collection(widget.email)
                            .document()
                            .setData({
                          "Name": names[i],
                          "Number": (i + 1).toString(),
                          "ID": ids[i],
                        });
                      }
                    }
                    if (checker == true) {
                      String id = Uuid().v4();
                      await teamRegRef
                          .document("Registerations")
                          .collection(widget.post.ID)
                          .document(widget.email)
                          .setData({
                        "Name": widget.teamName,
                        "Time": Timestamp.now(),
                        "Members": widget.members.toString(),
                        "TransactionID": widget.transaction,
                        "RID": widget.teamID,
                        "ID": id.toString(),
                        'Contact': widget.phone.toString()
                      });

                      subRef.document(widget.email).updateData({
                        "last_reg": widget.post.EventName,
                      });

                      setState(() {
                        loading = false;
                      });
                      Fluttertoast.showToast(msg: "Pay with prefered method");
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Screen(
                            widget.post.Fee,
                            "k787846@okaxis",
                          ),
                        ),
                      );
                    } else {
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () => Navigator.pop(context),
                            width: 120,
                          )
                        ],
                      ).show();

                      setState(() {
                        loading = false;
                      });
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
                            style: TextStyle(color: Colors.white, fontSize: 20),
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
    );

    children.add(SizedBox(height: 20.0));

    return Scaffold(
      backgroundColor: Color.fromRGBO(30, 31, 45, .97),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(30, 31, 45, .97),
        title: Center(
          child: Text(
            "Register",
            style: TextStyle(color: myColor, fontSize: 18),
          ),
        ),
      ),
      body: loading
          ? Center(
              child: Loading(),
            )
          : Padding(
              padding: EdgeInsets.all(0.00),
              child: SingleChildScrollView(
                child: Container(
                  color: Color.fromRGBO(30, 31, 45, 1),
                  child: Column(
                    children: children,
                  ),
                ),
              ),
            ),
    );
  }

  Future<bool> checkUser() async {
    DocumentSnapshot query = await teamRegRef
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
