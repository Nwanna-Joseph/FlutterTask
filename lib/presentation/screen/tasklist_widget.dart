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

  final List<TaskItem> items = List.generate(
      100,
      (index) => TaskItem(
          id: "${index}",
          dueDate: DateTime.now(),
          createdOn: DateTime.now(),
          title: "${index}"));
  final List<AnimationController> _controllers = [];
  final List<Animation<Offset>> _animations = [];

  TaskListWidget({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controllerWidget(context),
      appBar: AppBar(
        title: const Text("Tasks List"),
      ),
    );
  }

  Widget controllerWidget(BuildContext context) {
    // return Obx( () => tasksList(context, tasksController.filteredAndSortedResults.value.toList()));
    // return tasksList(context, items);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headers(context),
              noTasksFound(),
              refreshing(),
            ],
          ),
        ),
        Expanded(child: Obx( () => tasksList(context, tasksController.filteredAndSortedResults.value.toList())))
        // headers(context),
        // noTasksFound(),
        // refreshing(),
        // Obx(() =>
        //     tasksList(context, tasksController.filteredAndSortedResults.value.toList())),
      ],
    );
  }

  Widget headers(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: (){
              // Get.changeTheme(ThemeData.dark());
              Get.changeTheme(ThemeData.light());
            }, icon: const Icon(Icons.light)),

        IconButton(
            onPressed: (){ openFilterAndSortDialog(context); }, icon: const Icon(Icons.sort_outlined)),
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
      ],
    );
  }

  Widget noTasksFound() {
    return const Center(child: Text('No tasks available'));
  }

  Widget tasksList(BuildContext context, List<TaskItem> tasks) {
    // return Text("ok :${tasks.length}");
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (contextIn, index) {
        return listItem(context, tasks[index]);
        return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
                horizontalOffset: 50.0,
                verticalOffset: 10,
                child:
                FadeInAnimation(
                    child: listItem(context, tasks[index])
                )
            ));
      },
    );
  }

  Widget listItem(BuildContext context, TaskItem task) {
    return ListTile(
      leading: const Icon(Icons.check_circle_outline),
      title: Text("${task.title} : ${task.completedStatus}"),
      trailing: Container(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  openEditDialog(context, task);
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  openDeleteDialog(context, task);
                },
                icon: const Icon(Icons.delete)),
          ],
        ),
      ),
      onTap: () {
        // Handle item tap if needed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tapped on: ${task.title}')),
        );
      },
    );
  }

  Widget refreshing() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
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

  void openFilterAndSortDialog(BuildContext context) {
    showFilterAndSortDialog(tasksController.sortAndFilterParams.value,context,(filter, sort) {

      bool? filterCompleteStatus;
      bool? sortDueDate;
      bool? sortCreationDate;

      if(filter == "Completed"){
        filterCompleteStatus = true;
      }
      if(filter == "Ongoing"){
        filterCompleteStatus = false;
      }
      if(sort == "Due date"){
        sortDueDate = true;
      }
      if(sort == "Creation date"){
        sortCreationDate = true;
      }

      tasksController.sortAndFilter(SortAndFilterParams(
        filterCompleteStatus: filterCompleteStatus,
        sortCreationDate: sortCreationDate,
        sortDueDate: sortDueDate
      ));

    });
  }
}
