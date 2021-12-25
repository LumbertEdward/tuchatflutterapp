import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuchatapp/AppUtils/AppUtils.dart';
import 'package:tuchatapp/Chatts/Home.dart';
import 'package:tuchatapp/Models/Chat.dart';
import 'package:tuchatapp/Models/Group.dart';
import 'package:tuchatapp/Uploads/FirebaseUpload.dart';
import 'package:tuchatapp/sqflitedatabase/DatabaseHelper/DatabaseHelper.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {

  String groupId = "";
  String userId = "";
  String groupName = "";
  String groupDescription = "";
  Group? group;
  String imageUrl = "";
  File? file;
  String? picUrl;
  final _controller = ScrollController();

  TextEditingController message = TextEditingController();

  Future<void> checkGroup() async{
    var sharedPrefs = await SharedPreferences.getInstance();
    var ctGrpId = sharedPrefs.getString("chatGroupId") ?? "";
    var usersD = sharedPrefs.getString("userId") ?? "";

    setState(() {
      userId = usersD;
      groupId = ctGrpId;
    });

    if(groupId != ""){
      var grpDet = await DatabaseHelper.instance.getGroupDetails(groupId);
      setState(() {
        groupName = grpDet.group_name;
        groupDescription = grpDet.group_description;
      });

    }
    else{
      Fluttertoast.showToast(msg: "null", toastLength: Toast.LENGTH_LONG);
    }
  }

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

  Future<void> uploadImage() async{
    if(await CheckConnectivityClass.checkInternet()){
      if(file != null){
        var url = await FirebaseUpload.uploadImage(file!);

        if(url == ""){
          Fluttertoast.showToast(msg: "Error uploading image, try again", toastLength: Toast.LENGTH_LONG);
          print(url);
        }
        else{

        }
      }
    }
  }

  Future<void> sendMessage() async{
    if(groupId == ""){
      Fluttertoast.showToast(msg: "Group Does not exist", toastLength: Toast.LENGTH_LONG);
    }
    else{
      var chat_id = Random().nextInt(1000).toString();
      var chat = Chat(chatId: chat_id, userId: userId, groupId: groupId, message: message.text,
          date: DateFormat('dd-MM-yyyy').format(DateTime.now()), time: DateFormat.jm().format(DateTime.now()), img: imageUrl);

      var response = await DatabaseHelper.instance.addChat(chat);
      if(response > 0){
        var sharedPrefs = await SharedPreferences.getInstance();
        var ctGrpId = sharedPrefs.getString("chatGroupId") ?? "";
        setState(() {
          groupId = ctGrpId;
        });
        Fluttertoast.showToast(msg: "Added", toastLength: Toast.LENGTH_LONG);
      }
      else{
        Fluttertoast.showToast(msg: "Not Added", toastLength: Toast.LENGTH_LONG);
      }
    }
  }

  @override
  void initState() {
    checkGroup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: ListTile(
          title: Text(groupName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
          subtitle: Text(groupDescription, style: TextStyle(color: Colors.white),),
        ),
        leading: GestureDetector(
          onTap: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
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
                        color: Colors.blue
                    ),
                    child: Icon(Icons.arrow_back_ios),
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.exit_to_app, color: Colors.blue,),
                                    SizedBox(width: 20,),
                                    Text("Leave chatroom", style: TextStyle(fontWeight: FontWeight.bold),)
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
                          color: Colors.blue
                      ),
                      child: Icon(Icons.more_vert),
                    )
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder<List<Chat>>(
                future: DatabaseHelper.instance.getChats(groupId),
                builder: (BuildContext context, AsyncSnapshot<List<Chat>> snapshot){
                  if(!snapshot.hasData){
                    return const Center(child: Text("Loading...."),);
                  }
                  return snapshot.data!.isEmpty
                      ? const Center(child: Padding(
                    padding: EdgeInsets.all(20), child: Text("No Chats", style: TextStyle(fontWeight: FontWeight.bold),),),)
                      : Expanded(
                      child: ListView(
                        controller: _controller,
                        shrinkWrap: true,
                        children: snapshot.data!.map((e){
                          return e.userId == userId ? Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(

                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[300]
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
                                            child: Text(e.userId, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                            child: Text(e.message, style: TextStyle(color: Colors.blue)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5, top: 3, right: 5, bottom: 5),
                                  child: Text(e.time, style: TextStyle(fontSize: 10, color: Colors.grey),),
                                )
                              ],
                            ),
                          ) : Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(

                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
                                            child: Text(e.userId, style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold),),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                            child: Text(e.message, style: TextStyle(color: Colors.white)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5, top: 3, right: 5, bottom: 5),
                                  child: Text(e.time, style: TextStyle(fontSize: 10, color: Colors.grey),),
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      )
                  );
                }
            ),
            Container(
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  color: Colors.blue
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[300],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){

                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                              child: Icon(
                                Icons.attach_file_rounded, color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: SizedBox(
                                width: 260,
                                height: 40,
                                child: TextField(
                                  decoration: InputDecoration(
                                      hintText: "Enter Text",
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(color: Colors.white)
                                  ),
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  controller: message,
                                )
                            ),
                          ),
                          GestureDetector(
                            onTap: sendMessage,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                              child: Icon(
                                Icons.send, color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}
