import 'package:events_freelance/model/Post.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ParticipantScreen extends StatefulWidget {
  ParticipantScreen({this.post});
  Post post;
  @override
  _ParticipantScreenState createState() => _ParticipantScreenState();
}

class _ParticipantScreenState extends State<ParticipantScreen> {
  bool loading=true;
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,


      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          title: Text("Registerations",style: TextStyle(color: Colors.red,fontSize: 18,fontFamily: "Cupertino"),),

        ),
      ),

      body:

      Container(
        margin: EdgeInsets.only(top: 3),
        height: height,
        child: new Container(
          margin: EdgeInsets.all(5.0),
          height: height,

          child:FutureBuilder(

            future: getActivityFeed(),
            builder: (context, snapshot) {

              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              else{
                return ListView(
                  children: snapshot.data,
                );
              }

            },
          ),
        ),
      ),
    );
  }

  getActivityFeed() async{

    final regRef = widget.post.Teams=='true'?
    Firestore.instance.collection('TeamRegisterations')
        :
    Firestore.instance.collection('SingleRegisterations');
    List<Widget> tiles=[];

    QuerySnapshot snapshot = await regRef
        .document('Registerations')
        .collection(widget.post.ID)
        .orderBy('Time',descending: true)
        .getDocuments();

    snapshot.documents.forEach((doc) {

      tiles.add(
          regTile(MediaQuery.of(context).size.width,doc)
      );
    });

    setState(() {
      loading=false;
    });
    try{

      return tiles;
    }catch(z){
      Fluttertoast.showToast(msg: z.toString());
      setState(() {
        loading=false;
      });
    }
  }

  Widget regTile(double width, DocumentSnapshot doc) {
   return Padding(
     padding: const EdgeInsets.all(10.0),
     child: Container(
       decoration: BoxDecoration(
         color: Colors.blue,
         borderRadius: BorderRadius.all(Radius.circular(10)),
         boxShadow: [
           BoxShadow(
             color: Colors.grey.shade600,
             blurRadius: 5
           )
         ]
       ),
       width: width-10,
       child: Padding(
         padding: const EdgeInsets.all(8.0),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
             Text("Name: "+doc['Name'].toString()),
             Text("ID: "+doc['RID'].toString()),
             Text("Transaction ID: "+doc['TransactionID'].toString()),
             Text("Contact: "+doc['Contact'].toString()),
           ],
         ),
       ),
     ),
   );
  }
}
