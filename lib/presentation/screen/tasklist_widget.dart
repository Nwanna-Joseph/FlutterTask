import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:taskit/data/task_item.dart';
import 'package:taskit/presentation/controller/TasksController.dart';
import 'package:taskit/presentation/screen/dialog/task_add_task_dialog.dart';
import 'package:taskit/presentation/screen/dialog/task_delete_dialog.dart';
import 'package:taskit/presentation/screen/dialog/task_edit_task_dialog.dart';
import 'package:taskit/presentation/screen/dialog/tasks_list_filter.dart';

class TaskListWidget extends StatelessWidget {
  final TasksController tasksController = Get.put(TasksController());

  final List<String> items = List.generate(10, (index) => 'Item ${index + 1}');
  final List<AnimationController> _controllers = [];
  final List<Animation<Offset>> _animations = [];

  TaskListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return controllerWidget(context);
  }

  Widget controllerWidget(BuildContext context) {
    return Obx(() => SingleChildScrollView(
          child: Column(
            children: [
              headers(context),
              noTasksFound(),
              tasksList(tasksController.filteredAndSortedResults),
              refreshing(),
            ],
          ),
        ));
  }

  Widget headers(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: openFilterAndSortDialog, icon: const Icon(Icons.filter)),
        FilledButton(
          onPressed: () {
            openAddDialog(
                context,
                TaskItem(
                    id: "",
                    createdOn: DateTime.now(),
                    dueDate: DateTime.now()));
          },
          child: const Row(
            children: [
              Icon(Icons.add),
              Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
              Text("Add")
            ],
          ),
        ),
        IconButton(
            onPressed: openFilterAndSortDialog,
            icon: const Icon(Icons.download)),
      ],
    );
  }

  Widget noTasksFound() {
    return const Center(child: Text('No tasks available'));
  }

  Widget tasksList(List<TaskItem> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
                horizontalOffset: 50.0,
                verticalOffset: 10,
                child: FadeInAnimation(
                    child: ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: Text(
                  "${tasks[index].title} : ${tasks[index].completedStatus}"),
              trailing: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        openEditDialog(context, tasks[index]);
                      },
                      icon: const Icon(Icons.edit)),
                  IconButton(
                      onPressed: () {
                        openDeleteDialog(context, tasks[index]);
                      },
                      icon: const Icon(Icons.delete)),
                ],
              ),
              onTap: () {
                // Handle item tap if needed
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tapped on: ${tasks[index]}')),
                );
              },
            ))));
      },
    );
  }

  Widget refreshing() {
    return Container();
  }

  void openAddDialog(BuildContext context, TaskItem taskItem) {
    showAddDialog(context);
  }

  void openDeleteDialog(BuildContext context, TaskItem taskItem) {
    showDeleteDialog(context, () {
      tasksController.deleteTask(taskItem);
    });
  }

  void openEditDialog(BuildContext context, TaskItem taskItem) {
    showEditDialog(context, taskItem);
  }

  void openFilterAndSortDialog() {
    showFilterAndSortDialog();
  }
}
