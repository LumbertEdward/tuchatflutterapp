import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuchatapp/AppUtils/AppUtils.dart';
import 'package:tuchatapp/Auth/Login.dart';
import 'package:tuchatapp/Chatts/ChatRooms.dart';
import 'package:tuchatapp/Chatts/CodeVerification.dart';
import 'package:tuchatapp/Chatts/Messages.dart';
import 'package:tuchatapp/Models/Group.dart';
import 'package:tuchatapp/Models/GroupDisplay.dart';
import 'package:tuchatapp/Uploads/FirebaseUpload.dart';
import 'package:tuchatapp/sqflitedatabase/DatabaseHelper/DatabaseHelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UploadTask? task;
  File? file;
  String userId = "";
  bool status = false;
  String? picUrl;

  //textFields
  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();
  TextEditingController capacity = TextEditingController();

  Future _selectImage() async{
    FilePickerResult? selectedFile = await FilePicker.platform.pickFiles();
    if(selectedFile != null){
      final path = selectedFile.files.single.path;
      setState(() {
        file = File(path!);
      });
    }
    else{
      return;
    }
  }

  Future<void> addChatRoom() async{
    setState(() {
      status = true;
    });

    if(await CheckConnectivityClass.checkInternet()){
      if(file != null){
        var url = await FirebaseUpload.uploadImage(file!);

        if(url == ""){
          Fluttertoast.showToast(msg: "Error uploading image, try again", toastLength: Toast.LENGTH_LONG);
          print(url);
          setState(() {
            status = false;
          });
        }
        else{
          var grpId = Random().nextInt(100).toString();
          var grp = Group(group_id: grpId.toString(), group_name: title.text,
              group_description: desc.text, group_capacity: capacity.text, group_image: url,
              group_created_by: userId, group_date_created: DateFormat('dd-MM-yyyy').format(DateTime.now()).toString());

          var response = await DatabaseHelper.instance.createGroup(grp);
          if(response > 0){
            setState(() {
              status = false;
            });
            Fluttertoast.showToast(msg: "Group Created, wait for joining code", toastLength: Toast.LENGTH_LONG);
            Navigator.of(context).pop(true);
            var prefs = await SharedPreferences.getInstance();
            var pn = prefs.getString("phone") ?? "";
            FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: "+254$pn",
                verificationCompleted: (PhoneAuthCredential authCredential) async{
                  var prefs = await SharedPreferences.getInstance();
                  prefs.setString("code", authCredential.smsCode.toString());
                  prefs.setString("AddedGroupId", grpId);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CodeVerification()));
                },
                verificationFailed: (FirebaseAuthException firebaseAuthException) {
                  Fluttertoast.showToast(msg: "Verification Failed", toastLength: Toast.LENGTH_LONG);
                },
                codeSent: (String verificationId, int? forceResendingToken){

                },
                codeAutoRetrievalTimeout: (String timeout){

                });
          }
          else{
            setState(() {
              status = false;
            });
            Fluttertoast.showToast(msg: "Not Added", toastLength: Toast.LENGTH_LONG);
          }
        }
      }
      else{
        var grpId = Random().nextInt(100).toString();
        var grp = Group(group_id: grpId, group_name: title.text,
            group_description: desc.text, group_capacity: capacity.text, group_image: "",
            group_created_by: userId, group_date_created: DateFormat('dd-MM-yyyy').format(DateTime.now()).toString());

        var response = await DatabaseHelper.instance.createGroup(grp);
        if(response > 0){
          setState(() {
            status = false;
          });
          Fluttertoast.showToast(msg: "Group Created, wait for joining code", toastLength: Toast.LENGTH_LONG);
          Navigator.of(context).pop(true);
          var prefs = await SharedPreferences.getInstance();
          var pn = prefs.getString("phone") ?? "";
          FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: "+254$pn",
              verificationCompleted: (PhoneAuthCredential authCredential) async{
                var prefs = await SharedPreferences.getInstance();
                prefs.setString("code", authCredential.smsCode.toString());
                prefs.setString("AddedGroupId", grpId);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CodeVerification()));
              },
              verificationFailed: (FirebaseAuthException firebaseAuthException) {
                Fluttertoast.showToast(msg: "Verification Failed", toastLength: Toast.LENGTH_LONG);
              },
              codeSent: (String verificationId, int? forceResendingToken){

              },
              codeAutoRetrievalTimeout: (String timeout){

              });

        }
        else{
          setState(() {
            status = false;
          });
          Fluttertoast.showToast(msg: "Not Added", toastLength: Toast.LENGTH_LONG);
        }
      }
    }
    else{
      Fluttertoast.showToast(msg: "No Internet Connection", toastLength: Toast.LENGTH_LONG);
    }
  }

  void setUser() async{
    var prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString("userId") ?? "";
    setState(() {
      userId = user_id;
    });
  }


  @override
  void initState() {
    setUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("ChatRooms", style: TextStyle(color: Colors.white, fontSize: 15),),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () async{
            showModalBottomSheet(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))
                ),
                context: context,
                isScrollControlled: true,
                builder: (context){
                  return SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: ClipRRect(
                                    child: SizedBox(
                                      height: 4,
                                      width: 50,
                                      child: ElevatedButton(
                                        onPressed: (){},
                                        child: Text(""),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 5),
                            child: GestureDetector(
                              onTap: () async{
                                Navigator.pop(context);
                                var shared = await SharedPreferences.getInstance();
                                shared.clear();
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.login, color: Colors.blue,),
                                  SizedBox(width: 20,),
                                  Text("Log Out", style: TextStyle(fontWeight: FontWeight.bold),)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                  height: 10,
                  width: 10,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue[100]
                    ),
                    child: Icon(Icons.person),
                  )
              ),
            ),
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))
                  ),
                  context: context,
                  isScrollControlled: true,
                  builder: (context){
                    return SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 3),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: ClipRRect(
                                      child: SizedBox(
                                        height: 4,
                                        width: 50,
                                        child: ElevatedButton(
                                          onPressed: (){},
                                          child: Text(""),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 5),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatRooms()));
                                },
                                child: Row(
                                  children: [
                                    Image(image: AssetImage("images/newjoin.png"), height: 30, width: 30,),
                                    SizedBox(width: 20,),
                                    Text("Join new chatroom", style: TextStyle(fontWeight: FontWeight.bold),)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: Padding(
              padding: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                    height: 40,
                    width: 35,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue[100]
                      ),
                      child: Icon(Icons.more_vert),
                    )
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<GroupDisplay>>(
            future: DatabaseHelper.instance.getGroupDisplay(userId),
            builder: (BuildContext context, AsyncSnapshot<List<GroupDisplay>> snapshot){
              if(!snapshot.hasData){
                return const Center(child: Text("Loading...."),);
              }
              return snapshot.data!.isEmpty
                  ? const Center(child: Text("No Groups", style: TextStyle(fontWeight: FontWeight.bold),),)
                  : ListView(
                children: snapshot.data!.map((e){
                  return Center(
                    child: ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: e.group_image == "" ? Image(
                                  image: AssetImage("images/logotuchat.png"),
                                  fit: BoxFit.fill,
                                ): Image(
                                  image: NetworkImage(e.group_image),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      title: Text(e.group_name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                      subtitle: Text(e.message),
                      trailing: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(e.time, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10),),
                          ),
                          Padding(
                            padding: EdgeInsets.all(3),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: SizedBox(
                                  height: 17,
                                  width: 17,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(e.total, style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),),
                                        ],
                                      )
                                  )
                              ),
                            ),
                          )
                        ],
                      ),
                      onTap: () async{
                        var sharedPrefs = await SharedPreferences.getInstance();
                        sharedPrefs.setString("chatGroupId", e.group_id);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Messages()));
                      },
                    ),
                  );
                }).toList(),
              );
            }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))
              ),
              context: context,
              isScrollControlled: true,
              builder: (context){
                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: ClipRRect(
                                  child: SizedBox(
                                    height: 4,
                                    width: 50,
                                    child: ElevatedButton(
                                      onPressed: (){},
                                      child: Text(""),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Text("Add ChatRoom", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Image(
                                      image: AssetImage("images/logotuchat.png"),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _selectImage,
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Icon(Icons.cloud_upload, color: Colors.blue,),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 5),
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "ChatRoom Title",
                              hintText: "ChatRoom Title",
                            ),
                            keyboardType: TextInputType.text,
                            controller: title,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 5),
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "ChatRoom Description",
                              hintText: "ChatRoom Description",
                            ),
                            keyboardType: TextInputType.text,
                            controller: desc,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 5),
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "ChatRoom Maximum Capacity",
                              hintText: "ChatRoom Maximum Capacity",
                            ),
                            keyboardType: TextInputType.number,
                            controller: capacity,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 5),
                          child: SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: addChatRoom,
                                child: !status ? Text("Add ChatRoom") :
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    SizedBox(height: 30,),
                                    SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white,),),
                                    SizedBox(height: 30,),
                                  ],
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
