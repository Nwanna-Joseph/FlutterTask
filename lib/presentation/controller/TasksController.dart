
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:taskit/data/task_item.dart';
import 'package:taskit/domain/task_repository.dart';

class TasksController extends GetxController{

  late TextEditingController userNameTextController;
  late TaskRepository tasksRepository;

  RxString topUsername = ''.obs;
  RxList<TaskItem> tasks = <TaskItem>[].obs ;

  void addTask(label, launchTime){

  }

  void deleteTask(taskId){

  }

  void editTask(taskId){

  }

}