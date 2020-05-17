import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_freelance/home_screen.dart';
import 'package:events_freelance/screens/Loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
class CreatePost extends StatefulWidget {



  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  Color myColor=Colors.blue;
  String eventName;
  DateTime datee;
  String description;
  String details;
  String address;
  String fee;
  String freee;
  String date="Choose Date";
  String time="Choose Time";
  bool free=false;
  bool loading=false;
  Uuid id;
  List<File> images=[];
  SolidController solidController=new SolidController();
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
  String reg;
  bool teams=false;
  final StorageReference storageRef = FirebaseStorage.instance.ref();
  final subRef = Firestore.instance.collection('Posts');
  List<Color> colors=[Colors.grey,Colors.grey,Colors.grey,Colors.grey,Colors.grey,Colors.grey,Colors.grey,Colors.grey,Colors.grey,Colors.grey,];
  List<String> downloadUrl=[];
  String dropdownValue='1';




  @override
  Widget build(BuildContext context) {
    double height= MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    TextEditingController textCont=new TextEditingController();

    return Scaffold(
      backgroundColor: Color.fromRGBO(30, 31, 45, .6),

      bottomSheet: SolidBottomSheet(
        maxHeight: height/2,
        headerBar: Text(""),
        controller: solidController,
        body: TimePickerWidget(
          onCancel: (){
            solidController.hide();
          },
          onConfirm: (tim,i){
            setState(() {
              time=tim.hour.toString()+"-"+tim.minute.toString()+"-"+tim.second.toString();
            });
            solidController.hide();
          },
        ),
      ),

      appBar: AppBar(
        backgroundColor: Color.fromRGBO(40, 41, 55, 1),
        title: Text('Create post',style: TextStyle(color: Colors.white, fontSize: 16),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color:  Colors.white, size: 16,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Upload',
              style: TextStyle(color: Colors.white,fontSize: 16.0),
            ),
            onPressed: ()async{
              setState(() {
                loading=true;
              });
              String title;
              int a=1;
                StorageUploadTask uploadTask;
                int x=0;
                images.forEach((fil)async{
                  title=Uuid().v4();
                  uploadTask=storageRef.child(title+a.toString()).putFile(fil);
                  a++;
                  StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
                  downloadUrl.add(await storageSnap.ref.getDownloadURL());
                  x++;
                  Fluttertoast.showToast(msg: "Uploaded:"+x.toString()+"/"+images.length.toString());
                  if(x==images.length){
                    upload();
                  }
                });

            },

          )
        ],
      ),
      body: loading?
          Loading()
          :Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: height-20,
          width: width-20,
          decoration: BoxDecoration(
            color: Color.fromRGBO(30, 31, 45, 1),
            borderRadius: BorderRadius.all(Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: myColor,
                blurRadius: 15.0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Register your event here',style: TextStyle(color: myColor,fontWeight: FontWeight.bold,fontSize: 22 ),
                    ),
                  ),
                  Container(
                    height: height/10,
                    width: width-40,
                    child: TextField(
                      style: TextStyle(color: Colors.yellow),
                        decoration: InputDecoration(
                          labelStyle: new TextStyle(color: Colors.white),
                          hintText: "Event Name",
                          
                          hintStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      onChanged: (val){
                          eventName=val;
                      },
                    ),
                  ),
                  Container(
                    height: height/10,
                    width: width-40,
                    child: TextField(
                      style: TextStyle(color: Colors.yellow),
                      decoration: InputDecoration(
                        
                        hintText: "Event Description",
                        hintStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      onChanged: (val){
                        description=val;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Details', style: TextStyle(color: myColor,fontWeight: FontWeight.bold,fontSize: 20 ),),
                  ),
                  Container(
                    height: height/10,
                    width: width-40,
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: TextStyle(color: Colors.yellow),
                      decoration: InputDecoration(
                        hintText: "Detailed Description",
                        hintStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      onChanged: (val){
                        details=val;
                      },
                    ),
                  ),
                  Container(
                    height: height/10,
                    width: width-40,
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: TextStyle(color: Colors.yellow),
                      decoration: InputDecoration(
                        hintText: "Address",
                        hintStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      onChanged: (val){
                        address=val;
                      },
                    ),
                  ),




                  Row(
                    children: <Widget>[
                      Container(
                        height: height/10,
                        width: width-150,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.yellow),
                          decoration: InputDecoration(
                            hintText: "Fee",
                            
                            hintStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                          onChanged: (val){
                            fee=val;
                          },
                          enabled: !free,
                        ),
                      ),
                      Checkbox(
                        value: free,
                        onChanged: (x){
                          setState(() {
                            free=x;

                          });
                        },
                      ),
                      Text(
                        "Free",
                        style: TextStyle(
                            color: myColor,fontWeight: FontWeight.w600,fontSize: 18
                        ),
                      )
                    ],
                  ),




                  Row(
                    children: <Widget>[

                      Checkbox(
                        value: teams,
                        onChanged: (x){
                          setState(() {
                            teams=x;

                          });
                        },
                      ),
                      Text(
                        "Allow Teams ",
                        style: TextStyle(
                            color: myColor,fontWeight: FontWeight.w600,fontSize: 18
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text(
                        "Members:  ",
                        style: TextStyle(
                            color: myColor,fontWeight: FontWeight.w600,fontSize: 18
                        ),
                      ),
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                            color: myColor
                        ),
                        underline: Container(
                          height: 2,
                          color: myColor,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>['1', '2', '3', '4','5', '6', '7', '8','9', '10', '11', '12','13', '14', '15']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        })
                            .toList(),
                      ),
                    ],
                  ),




                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Date: ",style: TextStyle(color: myColor,fontWeight: FontWeight.w600,fontSize: 18)),
                      FlatButton(
                        child: Text(date,style: TextStyle(color: myColor,fontWeight: FontWeight.w600,fontSize: 18),),
                        onPressed: (){
                          DatePicker.showDatePicker(
                              context,
                            onConfirm: (d,l){
                                setState(() {
                                  date=d.day.toString()+"/"+d.month.toString()+"/"+d.year.toString();
                                  datee=d;
                                });
                            },
                          );
                        },
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Time: ",style: TextStyle(color: myColor,fontWeight: FontWeight.w600,fontSize: 18)),
                      FlatButton(
                        child: Text(time,style: TextStyle(color: myColor,fontWeight: FontWeight.w600,fontSize: 18),),
                        onPressed: (){
                          showDialog(
                              context: context,
                            child: Center(
                              child: TimePickerWidget(
                                onConfirm: (tim,i){
                                  setState(() {
                                    time=tim.hour.toString()+":"+tim.minute.toString()+":"+tim.second.toString();
                                  });
                                },
                              ),
                            )
                          );
                        },
                      )
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Images', style: TextStyle(color: myColor,fontWeight: FontWeight.bold,fontSize: 20 ),),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.image,color: colors[0],size: 26,
                        ),
                      ),
                      Container(
                        child: Icon(
                          Icons.image,color: colors[1],size: 26,
                        ),
                      ),
                      Container(
                        child: Icon(
                          Icons.image,color: colors[2],size: 26,
                        ),
                      ),
                      Container(
                        child: Icon(
                          Icons.image,color: colors[3],size: 26,
                        ),
                      ),
                      Container(
                        child: Icon(
                          Icons.image,color: colors[4],size: 26,
                        ),
                      ),
                      Container(
                        child: Icon(
                          Icons.image,color: colors[5],size: 26,
                        ),
                      ),
                      Container(
                        child: Icon(
                          Icons.image,color: colors[6],size: 26,
                        ),
                      ),
                      Container(
                        child: Icon(
                          Icons.image,color: colors[7],size: 26,
                        ),
                      ),
                      Container(
                        child: Icon(
                          Icons.image,color: colors[8],size: 26,
                        ),
                      ),
                      Container(
                        child: Icon(
                          Icons.image,color: colors[9],size: 26,
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: FlatButton(
                      child: Container(
                        height: 25,
                          width: 100,
                          color: myColor,
                          child: Center(child: Text("Add Image",style: TextStyle(color: Colors.white),)),
                      ),
                      onPressed: ()async{
                        if(images.length==10){
                          Fluttertoast.showToast(msg: 'Images Limit reached');
                        }
                        else{

                          images.add(await ImagePicker.pickImage(
                            source: ImageSource.gallery,
                          ));
                          setState(() {
                            colors[images.length-1]=Colors.green;
                          });

                        }

                          },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  upload() async{
    FirebaseUser a=await FirebaseAuth.instance.currentUser();
    String id=Uuid().v4();
    await subRef.document(id).setData({
      "Link1": downloadUrl[0],
      "Link2": downloadUrl.length<2?'null':downloadUrl[1],
      "Link3": downloadUrl.length<3?'null':downloadUrl[2],
      "Link4": downloadUrl.length<4?'null':downloadUrl[3],
      "Link5": downloadUrl.length<5?'null':downloadUrl[4],
      "Link6": downloadUrl.length<6?'null':downloadUrl[5],
      "Link7": downloadUrl.length<7?'null':downloadUrl[6],
      "Link8": downloadUrl.length<8?'null':downloadUrl[7],
      "Link9": downloadUrl.length<9?'null':downloadUrl[8],
      "Link10": downloadUrl.length<10?'null':downloadUrl[9],

      "UploadTime":Timestamp.now(),
      "Fee":fee,
      "EventName": eventName,
      "Description": description,
      "Details": details,
      "Address": address,
      "Time": time,
      "Date": date,
      "Members": dropdownValue,
      "Free": free,
      "Teams": teams,
      "AddedBy": a.email,
      "ID":id


    });

    Fluttertoast.showToast(msg: "Event uploaded");
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage()));

    setState(() {
      loading=false;
    });
  }

  
}
