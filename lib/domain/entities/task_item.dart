import 'dart:core';

class TaskItem {

  String id;
  String? title;
  String? note;
  DateTime dueDate;
  DateTime createdOn;
  bool? completedStatus;

  TaskItem({required this.id, this.title, this.note,required this.dueDate, required this.createdOn, this.completedStatus});

}

class SortAndFilterParams{

    bool? filterCompleteStatus; // null = All, false = Active, true = Completed
    DateTime? filterDueDate; // null = don't filter, set = filter
    DateTime? filterCreationDate; // null = don't filter, set = filter

    bool? sortDueDate;
    bool? sortCreationDate;

    SortAndFilterParams({this.filterCompleteStatus, this.sortDueDate, this.sortCreationDate });

}