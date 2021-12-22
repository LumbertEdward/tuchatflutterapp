import 'package:tuchatapp/sqflitedatabase/Tables/UserTable.dart';

class UserQueries{
  static const USER_SQL_QUERY = "CREATE TABLE ${UserTable.TABLE_NAME} (" +
      "${UserTable.COLUMN_NAME_ID} INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE," +
      "${UserTable.COLUMN_NAME_FIRST_NAME} TEXT," +
      "${UserTable.COLUMN_NAME_LAST_NAME} TEXT," +
      "${UserTable.COLUMN_NAME_EMAIL} TEXT," +
      "${UserTable.COLUMN_NAME_PHONE} TEXT," +
      "${UserTable.COLUMN_NAME_USERID} TEXT," +
      "${UserTable.COLUMN_NAME_PASSWORD} TEXT)";

  static const SQL_DELETE_ENTRIES = "DROP TABLE IF EXISTS ${UserTable.TABLE_NAME}";

}