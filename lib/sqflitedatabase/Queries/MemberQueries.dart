import 'package:tuchatapp/sqflitedatabase/Tables/MemberTable.dart';

class MemberQueries{
  static const MEMBERS_SQL_QUERIES = "CREATE TABLE ${MemberTable.TABLE_NAME} (" +
      "${MemberTable.COLUMN_NAME_ID} INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE," +
      "${MemberTable.COLUMN_NAME_GROUPID} TEXT," +
      "${MemberTable.COLUMN_NAME_CODE} TEXT," +
      "${MemberTable.COLUMN_NAME_DATE_ADDED} TEXT," +
      "${MemberTable.COLUMN_NAME_USERID} TEXT)";

  static const MEMBERS_DELETE_ENTRIES = "DROP TABLE IF EXISTS ${MemberTable.TABLE_NAME}";
}