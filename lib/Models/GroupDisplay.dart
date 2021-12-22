class GroupDisplay{
  final String group_id;
  final String group_name;
  final String group_image;
  final String message;
  final String date;
  final String time;
  final String total;

  GroupDisplay({required this.group_id, required this.group_name, required this.group_image, required this.message,
      required this.date, required this.time, required this.total});

  factory GroupDisplay.fromMap(Map<String, dynamic> json) => GroupDisplay(
      group_id: json['group_id'],
      group_name: json['group_name'],
      group_image: json['group_image'],
      message: json['message'],
      date: json['date'],
      time: json['time'],
      total: json['total']
  );

  Map<String, dynamic> toMap(){
    return {
      "group_id": group_id,
      "group_name": group_name,
      "group_image": group_image,
      "message": message,
      "date": date,
      "time": time,
      "total": total
    };
  }

  @override
  String toString() {
    return 'GroupDisplay{group_id: $group_id, group_name: $group_name, group_image: $group_image, message: $message, date: $date, time: $time, total: $total}';
  }
}