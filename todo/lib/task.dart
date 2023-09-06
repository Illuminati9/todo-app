import 'dart:convert';

List<Task> taskFromJson(String str) => List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));

String taskToJson(List<Task> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Task {
  Task({
    required this.id,
    required this.iscompleted,
    required this.title,
    required this.description
  });

  String id;
  bool iscompleted;
  String title;
  String description;

   factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json["_id"],
    title: json["title"],
    description :  json["description"],
    iscompleted: json["complete"]
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description":description,
    "complete":iscompleted    
  };
}
