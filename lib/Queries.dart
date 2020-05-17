import 'package:events_freelance/home_screen.dart';
import 'package:events_freelance/model/Participants_Screen.dart';
import 'package:events_freelance/model/Post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QueriesPage extends StatefulWidget {
  QueriesPage({this.post,this.userEmail});

  Post post;
  String userEmail;

  @override
  _QueriesPageState createState() => _QueriesPageState();
}

class _QueriesPageState extends State<QueriesPage> {
  final quesRef = Firestore.instance.collection("Questions");
  final userRef = Firestore.instance.collection("Users");
  FirebaseUser a;
  bool loading=false;
  String ques;
  String ans;
  String type;


  @override
  void initState() {
    super.initState();
    var doc=userRef.document(widget.userEmail).get().then((doc){
      type=doc['type'];
    });
  }

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    getUser();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(30, 31, 45, .97),
        title: Text("Questions",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w600),),
        actions: <Widget>[

      widget.userEmail.toString()==widget.post.AddedBy.toString()?
      FlatButton(
            child:
            Icon(Icons.people,color: Colors.red,),
            onPressed: ()async{
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ParticipantScreen(
                post: widget.post,
              )));
            },
          )
          :
        Container(),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              showDialog(
                context: context,
                builder: (context){
                  return SimpleDialog(
                    children: <Widget>[

                      Container(
                        height: 80,
                        width: width/2,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left:8.0,
                            right: 8.0
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Write Question",
                            ),
                            onChanged: (val){
                              ques=val;
                            },
                          ),
                        ),
                      ),

                      FlatButton(
                        child: Text("Ask",style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue
                          ),
                        ),
                        onPressed: () async{
                          setState(() {
                            loading=true;
                          });
                          await quesRef
                              .document(widget.post.ID)
                              .collection("Questions")
                              .document()
                              .setData({
                            "Question":ques,
                            "Answer":"No Answer yet",
                            "AddedBy":widget.userEmail,
                            'Time':Timestamp.now()
                          });
                          setState(() {
                            loading=false;
                          });
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                }
              );
            },
          ),
          FlatButton(
            child: Text('Sign Out',style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.blue
          ),),
            onPressed: ()async{
              await FirebaseAuth.instance.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
            },
          ),
        ],
      ),

      body: Container(
        color: Color.fromRGBO(30, 31, 45, 1),
        
        height: height,
        child: new Container(
          margin: EdgeInsets.all(5.0),
          height: height,

          child:loading?Center(child: CircularProgressIndicator(),):FutureBuilder(

            future: getActivityFeed(),
            builder: (context, snapshot) {

              if (!snapshot.hasData) {
                return Center(
                  child: Text("No Query yet"),
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

  getActivityFeed() async{
    List<Widget> tiles=[];
    QuerySnapshot query=await quesRef
          .document(widget.post.ID)
          .collection("Questions")
          .orderBy('Time',descending: true)
          .getDocuments();
    query.documents.forEach((doc){
      tiles.add(quesTile(
        doc
      ));
    });
    setState(() {
      loading=false;
    });
    return tiles;
  }


  Widget quesTile(DocumentSnapshot doc) {


    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        child: Container(
          width: MediaQuery.of(context).size.width-20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.blue,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade600,
                blurRadius: 5.0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(doc['AddedBy'].toString(),style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),),
                SizedBox(height: 3,),
                Text(doc['Question'].toString(),style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),),
                SizedBox(height: 3,),
                Text(doc['Answer'].toString(),style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),),

              ],
            ),
          ),
        ),

        onTap: (){
          if(type=='General'){
            Fluttertoast.showToast(msg: "Only managers can answer questions");
          }
          else{

            showDialog(
                context: context,
                builder: (context){
                  return SimpleDialog(
                    children: <Widget>[
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width/2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Write Answer",
                            ),
                            onChanged: (val){
                              ans=val;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      FlatButton(
                        child: Text("Answer",style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.red
                        ),
                        ),
                        onPressed: () async{
                          setState(() {
                            loading=true;
                          });
                          //03076516621
                          await quesRef
                              .document(widget.post.ID)
                              .collection("Questions")
                              .document(doc.documentID)
                              .updateData({
                            "Answer":ans.toString(),
                          });
                          setState(() {
                            loading=false;
                          });
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                }
            );
          }

        },
      ),
    );
  }

  void getUser() async{
    a=await FirebaseAuth.instance.currentUser();
  }
}
