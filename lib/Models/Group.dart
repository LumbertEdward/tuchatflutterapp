class Group{
  final String group_id;
  final String group_name;
  final String group_description;
  final String group_capacity;
  final String group_image;
  final String group_created_by;
  final String group_date_created;

  Group({required this.group_id, required this.group_name, required this.group_description,
      required this.group_capacity, required this.group_image, required this.group_created_by, required this.group_date_created});

  factory Group.fromMap(Map<String, dynamic> json) => Group(
      group_id: json['group_id'],
      group_name: json['group_name'],
      group_description: json['group_description'],
      group_capacity: json['group_capacity'],
      group_image: json['group_image'],
      group_created_by: json['group_created_by'],
      group_date_created: json['group_date_created']
  );

  Map<String, dynamic> toMap(){
    return {
      "group_id": group_id,
      "group_name": group_name,
      "group_description": group_description,
      "group_capacity": group_capacity,
      "group_image": group_image,
      "group_created_by": group_created_by,
      "group_date_created": group_date_created
    };
  }

  @override
  String toString() {
    return 'Group{group_id: $group_id, group_name: $group_name, group_description: $group_description, group_capacity: $group_capacity, group_image: $group_image, group_created_by: $group_created_by, group_date_created: $group_date_created}';
  }
}