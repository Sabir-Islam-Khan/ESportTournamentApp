import 'package:flutter/material.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(

          backgroundColor: Color.fromRGBO(30, 31, 45, 0.97),

          title: Center(
            child: Text("About Us"),
          ),

        ),
        body: Container(
          height: MediaQuery.of(context).size.height *1,
          width: MediaQuery.of(context).size.width * 1,
          color: Color.fromRGBO(30,31,45,1),
          child: Column(
            children: <Widget>[

              SizedBox(
                height: 40.0,
              ),

              Center(
                child: Text(
                  "Title - LOG (Lobby of Games)",
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                child:
                  Text(
                    "LOG (Lobby of Games) is a new ESports community. Now you can register into favourite ESports tournaments like PUBG, Call of Duty, Free fire,LUDO, Real Cricket through LOG. LOG helps Esports event organisers to promote their events on the platform giving them the potential to reach wide range of audience.Getting all the exiting events under one roof, it helps players to register to their favourite event. The LOG community gives the latest updates on trending games from around the globe.Follow our streams by subscribing our YouTube channel- https://www.youtube.com/channel/UCC2a_N2yda88Z1hD0PgyGWwFollow us on Instagram  lobbyofgames.Mail us  lobbyofgames@gmail.com",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}