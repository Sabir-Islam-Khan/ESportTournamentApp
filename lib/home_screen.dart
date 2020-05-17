import 'package:events_freelance/ManagerLogin.dart';
import 'package:events_freelance/screens/Loading.dart';
import 'package:events_freelance/screens/Profile.dart';
import 'package:events_freelance/screens/about.dart';
import 'package:events_freelance/screens/leaderboard.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:events_freelance/model/Post.dart';
import 'package:flutter/material.dart';
import 'package:events_freelance/Details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UserSignin.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SolidController controller = SolidController();
  int h = 1;
  bool loading = false;
  final subRef = Firestore.instance.collection("Posts");
  FirebaseMessaging _messaging = FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getToken() async {
    String t = await _messaging.getToken();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromRGBO(30, 31, 45, .6),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45),
        child: AppBar(
          backgroundColor: Color.fromRGBO(30, 31, 45, 1),
          title: Center(
            child: Text(
              "Events",
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontFamily: "Cupertino"),
            ),
          ),
        ),
      ),
      endDrawer: Drawer(
        child: Container(
          color: Color.fromRGBO(30, 31, 45, 1),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  height: 40.0,
                  width: MediaQuery.of(context).size.width * 1,
                  color: Color.fromRGBO(93, 83, 207, 1),
                  child: Center(
                    child: Text(
                      "Lobby of Games",
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManagerLogin(),
                      ),
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 15.0),
                      Image(
                        height: 70.0,
                        width: 70.0,
                        image: AssetImage("images/avatar.png"),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        "Manager Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.currentUser().then((value) {
                      if (value == null) {
                        showDialog(
                            context: context,
                            child: AlertDialog(
                              title: Text("User not logged in"),
                              content: Text(
                                  "Please login from an event before accesing your profile."),
                            ));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProfilePage()));
                      }
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 15.0),
                      Image(
                        height: 70.0,
                        width: 70.0,
                        image: AssetImage("images/gamer.png"),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        "User Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,

                      // TODO : Change this to profile screen according to login status
                      MaterialPageRoute(
                        builder: (context) => Leaderboard(),
                      ),
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 15.0),
                      Image(
                        height: 70.0,
                        width: 70.0,
                        image: AssetImage("images/leaderboard.png"),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        "Leaderboard",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,

                      // TODO : Change this to profile screen according to login status
                      MaterialPageRoute(
                        builder: (context) => About(),
                      ),
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 15.0),
                      Image(
                        height: 70.0,
                        width: 70.0,
                        image: AssetImage("images/about.png"),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        "About us",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 3),
        height: height,
        child: new Container(
          margin: EdgeInsets.all(5.0),
          height: height,
          child: FutureBuilder(
            future: getActivityFeed(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Loading(),
                );
              }
              return ListView(
                children: snapshot.data,
              );
            },
          ),
        ),
      ),
    );
  }

  getActivityFeed() async {
    List<Widget> tiles = [];

    QuerySnapshot snapshot =
        await subRef.orderBy('UploadTime', descending: true).getDocuments();

    snapshot.documents.forEach((doc) {
      Post post = Post.fromDocument(doc);
      tiles.add(postTile(MediaQuery.of(context).size.width, post));
    });
    setState(() {
      loading = false;
    });
    try {
      return tiles;
    } catch (z) {
      Fluttertoast.showToast(msg: z.toString());
      setState(() {
        loading = false;
      });
    }
  }

  Padding postTile(double width, Post post) {
    List<NetworkImage> pics = [
      NetworkImage(post.link1),
      post.link2 == "null" ? null : NetworkImage(post.link2),
      post.link3 == "null" ? null : NetworkImage(post.link3),
      post.link4 == "null" ? null : NetworkImage(post.link4),
      post.link5 == "null" ? null : NetworkImage(post.link5),
      post.link6 == "null" ? null : NetworkImage(post.link6),
      post.link7 == "null" ? null : NetworkImage(post.link7),
      post.link8 == "null" ? null : NetworkImage(post.link8),
      post.link8 == "null" ? null : NetworkImage(post.link9),
      post.link10 == "null" ? null : NetworkImage(post.link10),
    ];
    List<Widget> picChildren = [
      picContainer(
        image: pics[0],
        width: width,
      ),
    ];

    int i = 0;
    int _current = 1;
    pics.forEach((p) {
      i++;
      if (p != null) {
        if (i > 1) {
          picChildren.add(
            picContainer(
              image: p,
              width: width,
            ),
          );
        }
      }
    });
    return Padding(
      padding: const EdgeInsets.only(
        right: 4,
        left: 4,
        top: 8,
        bottom: 8,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
          color: Colors.green,
          boxShadow: [BoxShadow(color: Colors.blue, blurRadius: 15.0)],
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
              color: Colors.blue,
            ),
            child: Padding(
              padding: const EdgeInsets.all(1.5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.5),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                      color: Color.fromRGBO(30, 31, 45, 1),
                      boxShadow: [
                        BoxShadow(color: Colors.blue, blurRadius: 5.0)
                      ],
                    ),
                    height: 465,
                    width: width - 12,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8)),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://picsum.photos/250?image=42'),
                                )),
                          ),
                          title: Text(
                            post.EventName,
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: Colors.yellow),
                          ),
                          subtitle: Text(
                            post.Date,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: Colors.white),
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Details(
                                        image: pics,
                                        post: post,
                                      )));
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8)),
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 330,
                          width: width,
                          child: CarouselSlider(
                            items: picChildren,
                            options: CarouselOptions(
                                enlargeCenterPage: true,
                                enableInfiniteScroll: false,
                                initialPage: 1,
                                aspectRatio: 11 / 10,
                                onScrolled: (d) {
                                  setState(() {
                                    _current = d.toInt();
                                    h = _current;
                                  });
                                }

                                //onPageChanged: callBack,
                                ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Container(
                              child: Text(
                            post.AddedBy,
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: Colors.yellow),
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Container(
                              child: Text(
                            post.Description,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Data>> _getData() async {
    var mainUrl = "https://jsonplaceholder.typicode.com/photos";
    var data = await http.get(mainUrl);
    var jsonData = json.decode(data.body);
    List<Data> listOf = [];
    for (var i in jsonData) {
      Data data = new Data(i['id'], i['title'], i["url"], i["thumbnailUrl"]);
      listOf.add(data);
    }
    listOf[1].url = 'https://picsum.photos/250?image=42';
    listOf[2].url = 'https://picsum.photos/250?image=58';
    listOf[0].url = 'https://picsum.photos/250?image=100';
    listOf[3].url = 'https://picsum.photos/250?image=101';
    listOf[4].url = 'https://picsum.photos/250?image=35';

    return listOf;
  }

  openComments(SolidController _controller) {
    _controller.isOpened ? _controller.hide() : _controller.show();
  }
}

class picContainer extends StatelessWidget {
  picContainer({this.image, this.width});

  double width;
  NetworkImage image;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Container(
        height: 350,
        width: width - 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          color: Colors.grey,
          image: DecorationImage(image: image, fit: BoxFit.fill),
        ),
      ),
    );
  }
}

/*

Hero(
                  tag: 'logo',
                  child: Container(

      height: 270,
      width: width-50,
       decoration: BoxDecoration(
       borderRadius: BorderRadius.only(
         topLeft: Radius.circular(25),
         topRight: Radius.circular(25),
         bottomLeft: Radius.circular(25),
         bottomRight: Radius.circular(25),
       ),
         color: Colors.grey,

                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),




* TabBar(
          labelColor: Colors.red,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.transparent,
          controller: tabController,
          onTap: (int) {
            switch (int) {
              case 0:
                setState(() {
                  pageTitle = 'Home';
                });
                break;
              case 1:
                setState(() {
                  pageTitle = 'Dashboard';
                });
                break;
              case 2:
                setState(() {
                  pageTitle = 'Messages';
                });
                break;
            }
          },
          tabs: [
            Tab(
              icon: Icon(Icons.home),
              text: 'Home',
            ),
            Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
            Tab(icon: Icon(Icons.mode_comment), text: 'Messages')
          ]),
*
*
*
*
*
*
*
*
*
*

ListView.builder(
            scrollDirection: Axis.vertical,
            //itemCount: snapshot.data.length,
            itemBuilder: (BuildContext c,int index){

              List<NetworkImage> images=[
                NetworkImage(snapshot.data[index].url),
                NetworkImage(snapshot.data[index+1].url),
                NetworkImage(snapshot.data[index+2].url),
                NetworkImage(snapshot.data[index+3].url),
                NetworkImage(snapshot.data[index+4].url),

              ];

              List<String> subTitles=["Subtitle 1","Subtitle 2","Subtitle 3","Subtitle 4","Subtitle 5","Subtitle 6"];

              List<String> details=["Details 1","Details 2","Details 3","Details 4","Details 5","Details 6"];

              bool liked=false;

              String likes=" 1.1k";
              String comments="265";
              String gifs="3,322";

              NetworkImage dp=NetworkImage(snapshot.data[index].url);
              String date="20/4/2020";
              String postTitle='This is title';

              return    postTile(width, snapshot, index,images,subTitles[h],details,liked,likes,comments,gifs,dp,date,postTitle);
            }
        );



*
*
*
*
*
*
*
*
* TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: <Widget>[
          ListView.builder(
              itemCount: users.length,
              itemBuilder: (_, index) {
                User user = users[index];
                return LayoutBuilder(
                  builder: (_, constraints) {
                    return Container(
                      margin: index == users.length - 1
                          ? EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0)
                          : EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                      constraints: BoxConstraints(
                          maxHeight: constraints.maxHeight,
                          minWidth: constraints.maxWidth),
                      child: Container(
                        height: height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom -
                            kToolbarHeight -
                            kToolbarHeight,
                        width: width,
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              child: InkWell(
                                onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfilePage(user: user))),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  child: Stack(
                                    children: <Widget>[
                                      Image.network(
                                        user.picture.large,
                                        height: height,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        left: 8,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  128, 127, 128, 0.5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          height: 48,
                                          width: 48,
                                          child: Center(
                                            child: Text(
                                              '5+',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 0.5)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          bottom: 8,
                                          right: 8,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                '36',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                      user.picture.thumbnail,
                                    )),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          user.name.first +
                                              ' ' +
                                              user.name.last,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 2.0, bottom: 2.0),
                                          child: Text(
                                            'Lorem Ipsum is simply dummy text of the print',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            semanticsLabel: '...',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff707070)),
                                          ),
                                        ),
                                        Text(
                                          '34 comments',
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Color(0xffC6C6C6),
                                              fontWeight: FontWeight.w200),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () =>Navigator.of(context).push(MaterialPageRoute(builder:(_)=>ChatScreen(user))),
                                    icon: Icon(Icons.comment),
                                  ),
                                ],
                              ),
                            ),
                            index == users.length - 1 ? SizedBox() : Divider()
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
          ListView.builder(
              itemCount: users.length,
              itemBuilder: (_, index) {
                User user = users[index];
                return Container(
                  color: index < 3 ? Colors.grey[100] : Colors.white,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8),
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                      user.picture.thumbnail,
                    )),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: posts[index].iconW(),
                    ),
                    title: Text(
                      user.name.first + ' ' + user.name.last,
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                          child: Text(
                            posts[index].action(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            semanticsLabel: '...',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xff707070)),
                          ),
                        ),
                        Text(
                          posts[index].timeAgo(),
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 10,
                              color: Color(0xffC6C6C6),
                              fontWeight: FontWeight.w200),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ListView.builder(
              itemCount: users.length,
              itemBuilder: (_, index) {
                User user = users[index];
                return Container(
                  color: index % 2 == 0 ? Colors.grey[100] : Colors.white,
                  child: ListTile(
                    onTap: () =>Navigator.of(context).push(MaterialPageRoute(builder:(_)=>ChatScreen(user))),
                    contentPadding: EdgeInsets.all(8),
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                      user.picture.thumbnail,
                    )),
                    title: Text(
                      user.name.first + ' ' + user.name.last,
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                          child: Text(
                            'Lorem Ipsum is simply dummy text of the print so it takes place of the actual content 😁 if it is needed it also wraps',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            semanticsLabel: '...',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xff707070)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      * Image(
                                                                     image: NetworkImage(
                                                                     snapshot.data[index].url,
                                                                 ),
                                                                       height: 250,
                                                                       width: width-50,
                                                                       fit: BoxFit.fill,
                                                                 ),
      *
      *
      *
      *
      *
      *
      *
      * ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (_, index) {
                            return Padding(
                              padding: EdgeInsets.only(left: 15,top: 15),
                              child: Container(
                                height: 60,
                                width: width-30,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(10),
                                                bottomRight: Radius.circular(5),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                            ),
                                            child: Image(
                                              image: NetworkImage(data[index].url),
                                            ),
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Text(data[index].title),
                                              Text("10 mins ago"),
                                            ],
                                          ),
                                        ],
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(20),
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(20),
                                            ),
                                          ),
                                          child: Image(
                                            image: NetworkImage(
                                                data[index].url
                                            ),
                                          ),
                                        ),
                                      )

                                    ],
                                  ),
                                ),

                              ),
                            );
                          });
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
                User user = users[index];
                return LayoutBuilder(
                  builder: (_, constraints) {
                    return Container(
                      margin: index == users.length - 1
                          ? EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0)
                          : EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                      constraints: BoxConstraints(
                          maxHeight: constraints.maxHeight,
                          minWidth: constraints.maxWidth),
                      child: Container(
                        height: height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom -
                            kToolbarHeight -
                            kToolbarHeight,
                        width: width,
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              child: InkWell(
                                onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfilePage(user: user))),
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                                  child: Stack(
                                    children: <Widget>[
                                      Image.network(
                                        user.picture.large,
                                        height: height,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        left: 8,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  128, 127, 128, 0.5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          height: 48,
                                          width: 48,
                                          child: Center(
                                            child: Text(
                                              '5+',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 0.5)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          bottom: 8,
                                          right: 8,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                '36',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          user.picture.thumbnail,
                                        )),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          user.name.first +
                                              ' ' +
                                              user.name.last,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 2.0, bottom: 2.0),
                                          child: Text(
                                            'Lorem Ipsum is simply dummy text of the print',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            semanticsLabel: '...',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff707070)),
                                          ),
                                        ),
                                        Text(
                                          '34 comments',
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Color(0xffC6C6C6),
                                              fontWeight: FontWeight.w200),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () =>Navigator.of(context).push(MaterialPageRoute(builder:(_)=>ChatScreen(user))),
                                    icon: Icon(Icons.comment),
                                  ),
                                ],
                              ),
                            ),
                            index == users.length - 1 ? SizedBox() : Divider()
                          ],
                        ),
                      ),
                    );
                  },
                );
      *
      *
      *
      *
      *
      *
      *
      *
      *
      * loading?
              Center(
                child: CircularProgressIndicator(),
              )
              :

      *
      *
      *
      *
      *Row(
                                                               children: <Widget>[

                                                                   Column(
                                                                     crossAxisAlignment: CrossAxisAlignment.start,
                                                                   children: <Widget>[
                                                                     Padding(
                                                                       padding: const EdgeInsets.only(
                                                                         right: 10,top: 5
                                                                       ),
                                                                       child: Container(child: ),
                                                                     ),

                                                                   ],
                                                                   ),

                                                               ],
                                                               ),
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
*
* */
