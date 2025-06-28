import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:taskit/data/task_item.dart';
import 'package:taskit/domain/task_repository.dart';

class TasksController extends GetxController {
  late TextEditingController userNameTextController;
  late TaskRepository tasksRepository = TaskRepository();

  RxString topUsername = ''.obs;
  List<TaskItem> tasks = [];

  RxList<TaskItem> filteredAndSortedResults = <TaskItem>[].obs;

  Rx<SortAndFilterParams> sortAndFilterParams = SortAndFilterParams().obs;

  void addTask(TaskItem taskItem) async {
    await tasksRepository.addTask(taskItem);
    fetchTasksFromDevice();
  }

  Future<void> deleteTask(TaskItem taskItem) async {
    await tasksRepository.removeTask(taskItem);
    fetchTasksFromDevice();
  }

  Future<void> editTask(TaskItem taskItem) async {
    await tasksRepository.addTask(taskItem);
    fetchTasksFromDevice();
  }

  sortAndFilter(SortAndFilterParams sortAndFilterParams) {
    this.sortAndFilterParams.value = sortAndFilterParams;
    var filter = tasks.where((task) {
      var filterCompleteStatus =true;
      var filterDueDate = true;
      var filterCreationDate = true;

      if(sortAndFilterParams.filterCompleteStatus != null){
        filterCompleteStatus = sortAndFilterParams.filterCompleteStatus == task.completedStatus;
      }

      if(sortAndFilterParams.filterDueDate != null){
        filterCompleteStatus = sortAndFilterParams.filterDueDate == task.dueDate;
      }

      if(sortAndFilterParams.filterCreationDate != null){
        filterCompleteStatus = sortAndFilterParams.filterCreationDate == task.createdOn;
      }

      return filterCompleteStatus && filterDueDate && filterCreationDate;

    }).toList();

    if(sortAndFilterParams.sortCreationDate != null){
      filter.sort( (taskA, taskB) {
          if(sortAndFilterParams.sortCreationDate == true){
            return taskA.createdOn.millisecondsSinceEpoch - taskB.createdOn.millisecondsSinceEpoch;
          }else{
            return taskB.createdOn.millisecondsSinceEpoch - taskA.createdOn.millisecondsSinceEpoch;
          }
      } );
    }

    if(sortAndFilterParams.sortDueDate != null){
      filter.sort( (taskA, taskB) {
        if(sortAndFilterParams.sortDueDate == true){
          return taskA.dueDate.millisecondsSinceEpoch - taskB.dueDate.millisecondsSinceEpoch;
        }else{
          return taskB.dueDate.millisecondsSinceEpoch - taskA.dueDate.millisecondsSinceEpoch;
        }
      } );
    }


    filteredAndSortedResults.value = filter;
  }

  Future<void> fetchTasksFromDevice() async {
    var tasksJson = await tasksRepository.getTasks();
    print(tasksJson);
    tasks = List<TaskItem>.from(
        tasksJson.keys.map((key) => TaskItem.fromJson(tasksJson[key] ?? "{}")));
    sortAndFilter(sortAndFilterParams.value);
  }
}
