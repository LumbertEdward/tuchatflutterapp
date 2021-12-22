class Chat{
  final String chatId;
  final String userId;
  final String groupId;
  final String message;
  final String date;
  final String time;
  final String img;

  Chat({required this.chatId, required this.userId, required this.groupId, required this.message, required this.date,
      required this.time, required this.img});

  factory Chat.fromMap(Map<String, dynamic> json) => Chat(
      chatId: json['chatId'],
      userId: json['userId'],
      groupId: json['groupId'],
      message: json['message'],
      date: json['date'],
      time: json['time'],
      img: json['img']
  );

  Map<String, dynamic> toMap(){
    return {
      'chatId': chatId,
      "userId": userId,
      "groupId": groupId,
      "message": message,
      "date": date,
      "time": time,
      "img": img
    };
  }

  @override
  String toString() {
    return 'Chat{chatId: $chatId, userId: $userId, groupId: $groupId, message: $message, date: $date, time: $time, img: $img}';
  }
}