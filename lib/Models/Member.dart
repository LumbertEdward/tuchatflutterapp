class Member{
  final String userId;
  final String groupId;
  final String code;
  final String dateAdded;

  Member({required this.userId, required this.groupId, required this.code, required this.dateAdded});

  factory Member.fromMap(Map<String, dynamic> json) => Member(
      userId: json['userId'],
      groupId: json['groupId'],
      code: json['code'],
      dateAdded: json['dateAdded']
  );

  Map<String, dynamic> toMap(){
    return {
      "userId": userId,
      "groupId": groupId,
      "code": code,
      "dateAdded": dateAdded
    };
  }

  @override
  String toString() {
    return 'Member{userId: $userId, groupId: $groupId, code: $code, dateAdded: $dateAdded}';
  }
}