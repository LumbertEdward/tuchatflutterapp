import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuchatapp/AppUtils/AppUtils.dart';
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

  Future _uploadImage() async{
    if(await CheckConnectivityClass.checkInternet()){
      if(file == null){
        return;
      }
      else{
        final fileName = basename(file!.path);
        final destination = 'files/$fileName';
        task = FirebaseUpload.uploadFile(destination, file!);

        if(task == null){
          return;
        }
        else{
          final snapshot = await task!.whenComplete(() {});
          final urlDownload = await snapshot.ref.getDownloadURL();
          print(urlDownload);
        }
      }
    }
    else{
      Fluttertoast.showToast(msg: "No Internet Connection", toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> addChatRoom() async{
    setState(() {
      status = true;
    });
  }

  void setUser() async{
    var prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString("userId") ?? "";
    setState(() {
      userId = user_id;
    });
    Fluttertoast.showToast(msg: userId, toastLength: Toast.LENGTH_LONG);
  }


  @override
  void initState() {
    setUser();
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : "No File selected";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("ChatRooms", style: TextStyle(color: Colors.white, fontSize: 15),),
        centerTitle: true,
        leading: GestureDetector(
          onTap: (){},
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
            onTap: (){},
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
                                child: Image(
                                  image: AssetImage("images/logotuchat.png"),
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
                      onTap: (){

                      },
                      onLongPress: (){
                        setState(() {

                        });
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
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Icon(Icons.cloud_upload, color: Colors.blue,),
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
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 5),
                            child: SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: addChatRoom,
                                  child: status ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      SizedBox(height: 30,),
                                      SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white,),),
                                      SizedBox(height: 30,),
                                    ],
                                  ): Text("Add ChatRoom")
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
