import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuchatapp/Chatts/CodeVerification.dart';
import 'package:tuchatapp/Models/Group.dart';
import 'package:tuchatapp/Models/Member.dart';
import 'package:tuchatapp/sqflitedatabase/DatabaseHelper/DatabaseHelper.dart';

class ChatRooms extends StatefulWidget {
  const ChatRooms({Key? key}) : super(key: key);

  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {

  Future<void> sendViewGroups() async{
    var grps = await DatabaseHelper.instance.getGroups();
    print("Total Groups " + grps.length.toString());
  }


  @override
  void initState() {
    sendViewGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("New ChatRooms", style: TextStyle(color: Colors.white, fontSize: 15),),
        centerTitle: true,
        leading: GestureDetector(
          onTap: (){
            Navigator.of(context).pop(true);
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
                    child: Icon(Icons.arrow_back_ios),
                  )
              ),
            ),
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: (){

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
                      child: Icon(Icons.search),
                    )
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Group>>(
            future: DatabaseHelper.instance.getGroups(),
            builder: (BuildContext context, AsyncSnapshot<List<Group>> snapshot){
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
                      subtitle: Text(e.group_description),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async{
                              var sharedPrefs = await SharedPreferences.getInstance();
                              var userId = sharedPrefs.getString("userId") ?? "";
                              var response = await DatabaseHelper.instance.checkMemberJoined(userId, e.group_id);
                              if(response == false){
                                var prefs = await SharedPreferences.getInstance();
                                prefs.setString("code", "123456");
                                prefs.setString("AddedGroupId", e.group_id);
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const CodeVerification()));
                              }
                              else {
                                Fluttertoast.showToast(
                                    msg: "You are already a member",
                                    toastLength: Toast.LENGTH_LONG);
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(7)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text("Join ChatRoom", style: TextStyle(color: Colors.white, fontSize: 12),),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }
        ),
      ),
    );
  }
}
