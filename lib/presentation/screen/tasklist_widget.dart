import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskit/presentation/controller/TasksController.dart';
import 'package:taskit/presentation/screen/dialog/task_action_dialog.dart';
import 'package:taskit/presentation/screen/dialog/task_add_task_dialog.dart';
import 'package:taskit/presentation/screen/dialog/tasks_list_filter.dart';

class TaskListWidget extends StatelessWidget {
  final TasksController tasksController = Get.put(TasksController());

  TaskListWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    return controllerWidget();
  }

  Widget controllerWidget() {
    return Obx(() =>
        SingleChildScrollView(
          child: Column(
            children: [
              headers(),
              noTasksFound(),
              tasksList(tasksController.filteredAndSortedResults),
              refreshing(),
            ],
          ),
        )
    );
  }


  Widget headers(){
    return Container(
      child: Row(
        children: [
          IconButton(onPressed: openFilterAndSortDialog , icon: Icon(Icons.filter)),
          FilledButton(onPressed: openAddDialog, child: const Row(
            children: [
              Icon(Icons.add),
              Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
              Text("Add")
            ],
          ), ),
          IconButton(onPressed: openFilterAndSortDialog , icon: Icon(Icons.download)),
        ],
      ),
    );
  }

  Widget noTasksFound() {
    return Container(
      child: const Center(child: Text('No tasks available')),
    );
  }

  Widget tasksList(tasks) {
    return Container(
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: Text(tasks[index]),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle item tap if needed
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped on: ${tasks[index]}')),
              );
            },
          );
        },
      ),
    );
  }

  Widget refreshing() {
    return Container();
  }

  void openAddDialog(){
    showAddDialog();
  }

  void openActionDialog(){
    showActionDialog();
  }

  void openFilterAndSortDialog(){
    showFilterAndSortDialog();
  }

}