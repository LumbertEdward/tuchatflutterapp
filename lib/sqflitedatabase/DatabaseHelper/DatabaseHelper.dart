import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tuchatapp/Models/Chat.dart';
import 'package:tuchatapp/Models/Group.dart';
import 'package:tuchatapp/Models/GroupDisplay.dart';
import 'package:tuchatapp/Models/Member.dart';
import 'package:tuchatapp/Models/User.dart';
import 'package:tuchatapp/sqflitedatabase/Db/DatabaseClass.dart';
import 'package:tuchatapp/sqflitedatabase/Queries/ChatQueries.dart';
import 'package:tuchatapp/sqflitedatabase/Queries/GroupQueries.dart';
import 'package:tuchatapp/sqflitedatabase/Queries/MemberQueries.dart';
import 'package:tuchatapp/sqflitedatabase/Queries/UserQueries.dart';
import 'package:tuchatapp/sqflitedatabase/Tables/ChatsTable.dart';
import 'package:tuchatapp/sqflitedatabase/Tables/GroupTable.dart';
import 'package:tuchatapp/sqflitedatabase/Tables/MemberTable.dart';
import 'package:tuchatapp/sqflitedatabase/Tables/UserTable.dart';

class DatabaseHelper{
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  //initialise database
  Future<Database> _initDatabase() async{
    return await openDatabase(
        join(await getDatabasesPath(), DatabaseClass.DATABASE_NAME),
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onDowngrade: _downGrade,
        version: DatabaseClass.VERSION
    );
  }

  Future _onCreate(Database db, int version) async{
    await db.execute(UserQueries.USER_SQL_QUERY);
    await db.execute(MemberQueries.MEMBERS_SQL_QUERIES);
    await db.execute(GroupQueries.GROUP_SQL_ENTRIES);
    await db.execute(ChatQueries.CHAT_SQL_ENTRIES);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async{
    if(newVersion > oldVersion){
      await db.execute(UserQueries.USER_SQL_QUERY);
      await db.execute(MemberQueries.MEMBERS_SQL_QUERIES);
      await db.execute(GroupQueries.GROUP_SQL_ENTRIES);
      await db.execute(ChatQueries.CHAT_SQL_ENTRIES);
      await _onCreate(db, newVersion);
    }
  }

  Future _downGrade(Database db, int oldVersion, int newVersion) async{
    if(oldVersion > newVersion){
      await db.execute(UserQueries.USER_SQL_QUERY);
      await db.execute(MemberQueries.MEMBERS_SQL_QUERIES);
      await db.execute(GroupQueries.GROUP_SQL_ENTRIES);
      await db.execute(ChatQueries.CHAT_SQL_ENTRIES);
      await _onCreate(db, oldVersion);
    }
  }

  //users

  //getUsers
  Future<List<User>> getUsers() async{
    Database db = await instance.database;
    var users = await db.query(UserTable.TABLE_NAME, orderBy: UserTable.COLUMN_NAME_FIRST_NAME);
    List<User> userList = users.isNotEmpty ? users.map((e) => User.fromMap(e)).toList() : [];

    return userList;
  }

  //addUsers
  Future<int> registerUser(User user) async{
    Database db = await instance.database;
    return await db.insert(UserTable.TABLE_NAME, user.toMap());
  }

  Future<List<User>> loginUser(String email, String password) async{
    Database db = await instance.database;
    var user = await db.query(UserTable.TABLE_NAME, where: "${UserTable.COLUMN_NAME_EMAIL} = ? AND ${UserTable.COLUMN_NAME_PASSWORD} = ?",
    whereArgs: [email, password]);
    print(user);

    List<User> usr = user.isNotEmpty ? user.map((e) => User.fromMap(e)).toList() : [];

    return usr;
  }

  //removeUser
  Future<int> removeUser(String id) async{
    Database db = await instance.database;
    return await db.delete(UserTable.TABLE_NAME, where: "${UserTable.COLUMN_NAME_USERID} = ?", whereArgs: [id]);
  }

  //updateUser
  Future<int> updateUser(User user) async{
    Database db = await instance.database;
    return await db.update(UserTable.TABLE_NAME, user.toMap(), where: "${UserTable.COLUMN_NAME_USERID} = ?", whereArgs: [user.userId]);
  }

  //groups

  //create group
  Future<int> createGroup(Group group) async{
    Database db = await instance.database;
    return await db.insert(GroupTable.TABLE_NAME, group.toMap());
  }

  //get groups
  Future<List<Group>> getGroups() async{
      Database db = await instance.database;
      var groups = await db.query(GroupTable.TABLE_NAME, orderBy: GroupTable.COLUMN_NAME_GROUP_NAME);
      List<Group> grps = groups.isNotEmpty ? groups.map((e) => Group.fromMap(e)).toList() : [];

      return grps;
  }

  //get group details
  Future<Group> getGroupDetails(String groupId) async{
    Database db = await instance.database;
    var groups = await db.query(GroupTable.TABLE_NAME, where: "${GroupTable.COLUMN_NAME_GROUP_ID} = ?",
    whereArgs: [groupId]);

    List<Group> grps = groups.isNotEmpty ? groups.map((e) => Group.fromMap(e)).toList() : [];
    print(grps);
    return grps[0];
  }


  //Members

  Future<int> addMember(Member member) async{
      Database db = await instance.database;
      return await db.insert(MemberTable.TABLE_NAME, member.toMap());
  }

  //group members
  Future<List<Member>> getGroupMembers(String groupId) async{
    Database db = await instance.database;
    var members = await db.query(MemberTable.TABLE_NAME, where: "${MemberTable.COLUMN_NAME_GROUPID} = ?",
    whereArgs: [groupId]);

    List<Member> membrs = members.isNotEmpty ? members.map((e) => Member.fromMap(e)).toList(): [];

    return membrs;
  }

  //get member groups
  Future<List<String>> getMemberGroups(String userId) async{
    Database db = await instance.database;
    var members = await db.query(MemberTable.TABLE_NAME, where: "${MemberTable.COLUMN_NAME_USERID} = ?",
        whereArgs: [userId]);

    List<Member> membrs = members.isNotEmpty ? members.map((e) => Member.fromMap(e)).toList(): [];

    if(membrs.isNotEmpty){
      List<String> grps = [];
      for(int i = 0; i < membrs.length; i++){
        grps.add(membrs[i].groupId);
      }

      return grps;
    }else{
      return [""];
    }
  }

  Future<bool> checkMemberJoined(String userId, String groupId) async{
    Database db = await instance.database;
    var members = await db.query(MemberTable.TABLE_NAME, where: "${MemberTable.COLUMN_NAME_USERID} = ? AND "
        "${MemberTable.COLUMN_NAME_GROUPID} = ?",
        whereArgs: [userId, groupId]);

    List<Member> membrs = members.isNotEmpty ? members.map((e) => Member.fromMap(e)).toList(): [];

    if(membrs.length > 0){
      return true;
    }
    return false;
  }

  Future<List<GroupDisplay>> getGroupDisplay(String userId) async{
    var grps = await getMemberGroups(userId);
    var all = await getGroups();
    List<GroupDisplay>? chatsFinal;

    List<Group> userGroups = [];

    for(int i = 0; i < all.length; i++){
      for(int j = 0; j < grps.length; j++){
        if(grps[j] == all[i].group_id){
          userGroups.add(all[i]);
        }
      }
    }

    if(userGroups.isNotEmpty){
      List<GroupDisplay> display = [];
      for(int i = 0; i < userGroups.length; i++){
        var chats = await getChats(userGroups[i].group_id);
        if(chats.isNotEmpty){
          var disp = GroupDisplay(
              group_id: userGroups[i].group_id,
              group_name: userGroups[i].group_name,
              group_image: userGroups[i].group_image,
              message: chats[chats.length - 1].message,
              date: chats[chats.length - 1].date,
              time: chats[chats.length - 1].time,
              total: chats.length.toString()
          );

          display.add(disp);
        }
        else{
          var disp = GroupDisplay(
              group_id: userGroups[i].group_id,
              group_name: userGroups[i].group_name,
              group_image: userGroups[i].group_image,
              message: "No message",
              date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
              time: DateFormat.jm().format(DateTime.now()),
              total: "0"
          );

          display.add(disp);
        }
      }
      chatsFinal = display;
    }
    else{
      chatsFinal = [];
    }

    return chatsFinal;
  }

  //leave group
  Future<int> leaveGroup(String userId, String groupId) async{
    Database db = await instance.database;
    return await db.delete(MemberTable.TABLE_NAME, where: "${MemberTable.COLUMN_NAME_USERID} = ? AND ${MemberTable.COLUMN_NAME_GROUPID}", whereArgs: [userId, groupId]);
  }

  //chats

  //add chat
  Future<int> addChat(Chat chat) async{
      Database db = await instance.database;
      return await db.insert(ChatsTable.TABLE_NAME, chat.toMap());
  }

  //get group chats
  Future<List<Chat>> getChats(String groupId) async{
      Database db = await instance.database;
      var chats = await db.query(ChatsTable.TABLE_NAME, where: "${ChatsTable.COLUMN_NAME_GROUPID} = ?",
      whereArgs: [groupId]);
      List<Chat> chts = chats.isNotEmpty ? chats.map((e) => Chat.fromMap(e)).toList(): [];

      return chts;
  }

  //delete chat
  Future<int> deleteChat(String chatId) async{
    Database db = await instance.database;
    return await db.delete(ChatsTable.TABLE_NAME, where: "${ChatsTable.COLUMN_NAME_CHAT_ID} = ?", whereArgs: [chatId]);
  }

}
