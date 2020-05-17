import 'package:flutter/material.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(

        appBar: AppBar(
          backgroundColor: Color.fromRGBO(30, 31, 45, 0.97),
          title: Center(
            child: Text("Leaderboard"),
          ),
        ),

        body: Container(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          color: Color.fromRGBO(30, 31, 45, 1),
          child: Center(
            child: Text(
              "Leaderboard coming soon...",
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 25.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}