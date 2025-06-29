import 'dart:convert';

import 'package:taskit/domain/entities/task_item.dart';

class TaskModel extends TaskItem {
  TaskModel({required super.id, super.title, super.note,required super.dueDate, required super.createdOn, super.completedStatus});

  String toJson(){
    return jsonEncode({
      "id": id,
      "title": title,
      "note": note,
      "dueDate": dueDate.toIso8601String(),
      "createdOn": createdOn.toIso8601String(),
      "completedStatus": completedStatus,
    });
  }

  factory TaskModel.fromJson(String json){
    var map = jsonDecode(json);
    return TaskModel(
      id: map["id"],
      title: map["title"],
      note: map["note"],
      dueDate: DateTime.parse(map["dueDate"]),
      createdOn: DateTime.parse(map["createdOn"]),
      completedStatus: map["completedStatus"],
    );
  }
}