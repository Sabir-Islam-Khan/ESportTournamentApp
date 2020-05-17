import 'package:events_freelance/Queries.dart';
import 'package:events_freelance/RegisterationForm.dart';
import 'package:events_freelance/UserSignin.dart';
import 'package:events_freelance/model/Post.dart';
import 'package:flutter/material.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class Details extends StatefulWidget {
  Details({this.image, this.post});
  List<NetworkImage> image;
  Post post;
  int picsNum;

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user;

  getUser() async {
    user = await auth.currentUser();
  }

  Container picContainer(NetworkImage image) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height - height / 4 - 80,
      width: MediaQuery.of(context).size.width - 30,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 10.0)],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        image: DecorationImage(image: image, fit: BoxFit.fill),
      ),
    );
  }

  SolidController controller = SolidController();
  String cmnt;
  @override
  Widget build(BuildContext context) {
    List<Widget> picContainers = [];
    widget.image.forEach((x) {
      if (x != null) {
        picContainers.add(picContainer(x));
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Color.fromRGBO(30, 31, 45, 1),
          leading: Padding(
            padding:
                const EdgeInsets.only(left: 5, right: 15, top: 6, bottom: 6),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Queries",
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
              onPressed: () async {
                FirebaseUser q = await auth.currentUser();

                if (q != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => QueriesPage(
                            post: widget.post,
                            userEmail: q.email,
                          )));
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GoogleSignin(
                        post: widget.post,
                        x: "query",
                      ),
                    ),
                  );
                }
              },
            ),
            FlatButton(
              child: Text(
                "Register",
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
              onPressed: () async {
                FirebaseUser q = await auth.currentUser();

                if (q != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RegisterationForm(
                            post: widget.post,
                            email: q.email,
                          )));
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GoogleSignin(
                        post: widget.post,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.post.EventName,
                style: TextStyle(
                    color: Colors.blue, fontSize: 14, fontFamily: "Cupertino"),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.white,
            Colors.blue,
            Colors.green,
            Colors.red,
            Colors.white
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 5, right: 15, left: 15),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.grey.shade600, blurRadius: 10.0),
              ],
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0.0,
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: MediaQuery.of(context).size.width - 20,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.image.length,
                    itemBuilder: (_, index) {
                      return picContainer(widget.image[index]);
                    },
                  ),
                ),
                Positioned(
                  top: (MediaQuery.of(context).size.height / 2.5) - 30,
                  left: 0.0,
                  child: Container(
                    height: MediaQuery.of(context).size.height -
                        50 -
                        (MediaQuery.of(context).size.height / 2.5),
                    width: MediaQuery.of(context).size.width - 30,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(30, 31, 45, 1),
                      boxShadow: [
                        BoxShadow(color: Colors.blue, blurRadius: 10.0),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Event Details",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 2, bottom: 2),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Date: ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.yellow),
                                  ),
                                  Text(
                                    widget.post.Date,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 2, bottom: 2),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Time: ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.yellow),
                                  ),
                                  Text(
                                    widget.post.Time,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 8, top: 2, bottom: 2),
                              child: GestureDetector(
                                onTap: () async {
                                  if (await canLaunch(widget.post.Address)) {
                                    await launch(widget.post.Address);
                                  }
                                },
                                child: Text(widget.post.Address,
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 2, bottom: 2),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Fee: ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.yellow),
                                  ),
                                  widget.post.Fee == null
                                      ? Text(
                                          "  This is a free event",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        )
                                      : Text(
                                          "${widget.post.Fee.toString()}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, bottom: 10, right: 10),
                              child: SelectableText(
                                widget.post.Details,
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  openComments(SolidController _controller) {
    _controller.isOpened ? _controller.hide() : _controller.show();
  }
}
