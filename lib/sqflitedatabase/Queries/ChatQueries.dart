import 'package:tuchatapp/sqflitedatabase/Tables/ChatsTable.dart';

class ChatQueries{
  static const CHAT_SQL_ENTRIES = "CREATE TABLE ${ChatsTable.TABLE_NAME} (" +
      "${ChatsTable.COLUMN_NAME_ID} INTEGER," +
      "${ChatsTable.COLUMN_NAME_CHAT_ID} TEXT," +
      "${ChatsTable.COLUMN_NAME_DATE} TEXT," +
      "${ChatsTable.COLUMN_NAME_GROUPID} TEXT," +
      "${ChatsTable.COLUMN_NAME_MESSAGE} TEXT," +
      "${ChatsTable.COLUMN_NAME_TIME} TEXT," +
      "${ChatsTable.COLUMN_NAME_USERID} TEXT," +
      "${ChatsTable.COLUMN_NAME_IMAGE} TEXT)";

  static const CHAT_SQL_DROP = "DROP TABLE IF EXISTS ${ChatsTable.TABLE_NAME}";
}