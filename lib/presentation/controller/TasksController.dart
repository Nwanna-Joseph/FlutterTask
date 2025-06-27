
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:taskit/data/task_item.dart';
import 'package:taskit/domain/task_repository.dart';

class TasksController extends GetxController{

  late TextEditingController userNameTextController;
  late TaskRepository tasksRepository = TaskRepository();

  RxString topUsername = ''.obs;
  RxList<TaskItem> tasks = <TaskItem>[].obs ;

  RxList<TaskItem> filteredAndSortedResults = <TaskItem>[].obs ;
  Rx<SortAndFilterParams> sortAndFilterParams = SortAndFilterParams().obs;

  void addTask(label, launchTime) async {
    var tasks = await tasksRepository.addTask(TaskItem());
  }

  void deleteTask(taskId){
    // tasksRepository.removeTask();
  }

  void editTask(taskId){
    // tasksRepository.editTasks();
  }

  void sortAndFilter(){

  }

  void fetchTasksFromDevice(){
    // tasks.value = await tasksRepository.getTasks();
    // filteredAndSortedResults.value = sortAndFilter();
  }

}