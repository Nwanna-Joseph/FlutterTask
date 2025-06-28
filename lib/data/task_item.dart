

import 'dart:convert';
import 'dart:core';

import 'package:flutter/cupertino.dart';

class TaskItem {

  String id;
  String? title;
  String? note;
  DateTime dueDate;
  DateTime createdOn;
  bool? completedStatus;


  TaskItem({required this.id, this.title, this.note,required this.dueDate, required this.createdOn, this.completedStatus});

  TaskItem? toTaskItem(Map<String, String> map){
    return null;
  }

  Map<String, String> fromTaskItem(TaskItem taskItem){
    return {};
  }

  String toJson(){
    return jsonEncode({
      id: id,
      title: title,
      note: note,
      dueDate: dueDate,
      createdOn: createdOn,
      completedStatus: completedStatus,
    });
  }

  factory TaskItem.fromJson(String json){
    var map = jsonDecode(json);
    return TaskItem(
        id: map["id"],
        title: map["title"],
        note: map["note"],
        dueDate: map["dueDate"],
        createdOn: map["createdOn"],
        completedStatus: map["completedStatus"],
    );
  }

}

class SortAndFilterParams{

    bool? filterCompleteStatus; // null = All, false = Active, true = Completed
    DateTime? filterDueDate; // null = don't filter, set = filter
    DateTime? filterCreationDate; // null = don't filter, set = filter

    bool? sortDueDate;
    bool? sortCreationDate;

}