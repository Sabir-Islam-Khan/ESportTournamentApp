import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  String link1;
  String link2;
  String link3;
  String link4;
  String link5;
  String link6;
  String link7;
  String link8;
  String link9;
  String link10;
  String Time;
  String EventName;
  String Fee;
  String Description;
  String Details;
  String Address;
  String UploadTime;
  String Date;
  String Members;
  String Free;
  String Teams;
  String AddedBy;
  String ID;
  String DP;


  Post({
    this.Details,
    this.ID,
    this.Time,
    this.AddedBy,
    this.DP,
    this.Address,
    this.Date,
    this.Description,
    this.EventName,
    this.Fee,
    this.Free,
    this.link1,
    this.link2,
    this.link3,
    this.link4,
    this.link5,
    this.link6,
    this.link7,
    this.link8,
    this.link9,
    this.link10,
    this.Members,
    this.Teams,
    this.UploadTime
  }
      );

  factory Post.fromDocument(DocumentSnapshot doc){
    return Post(

      UploadTime: doc['UploadTime'].toString(),
      link1: doc['Link1'].toString(),
      link2: doc['Link2'].toString(),
      link3: doc['Link3'].toString(),
      link4: doc['Link4'].toString(),
      link5: doc['Link5'].toString(),
      link6: doc['Link6'].toString(),
      link7: doc['Link7'].toString(),
      link8: doc['Link8'].toString(),
      link9: doc['Link9'].toString(),
      link10: doc['Link10'].toString(),
      Details: doc['Details'].toString(),
      ID:doc['ID'].toString(),
      Time: doc['Time'].toString(),
      AddedBy: doc['AddedBy'].toString(),
      Date: doc['Date'].toString(),
      DP: doc['DP'].toString(),
      Description: doc['Description'].toString(),
      Address: doc['Address'].toString(),
      Fee: doc['Fee'].toString(),
      Free: doc['Free'].toString(),
      EventName: doc['EventName'].toString(),
      Members: doc['Members'].toString(),
      Teams: doc['Teams'].toString().toString(),
    );
  }
}
