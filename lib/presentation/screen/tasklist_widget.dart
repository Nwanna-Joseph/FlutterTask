import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskit/domain/entities/task_item.dart';
import 'package:taskit/presentation/controller/tasks_controller.dart';
import 'package:taskit/presentation/screen/dialog/task_add_task_dialog.dart';
import 'package:taskit/presentation/screen/dialog/task_delete_dialog.dart';
import 'package:taskit/presentation/screen/dialog/task_edit_task_dialog.dart';
import 'package:taskit/presentation/screen/dialog/tasks_list_filter.dart';
import 'package:taskit/presentation/screen/widgets/text_widget.dart';
import 'package:taskit/presentation/screen/widgets/task_card.dart';

class TaskListWidget extends StatelessWidget {
  final TasksController tasksController = Get.put(TasksController());

  TaskListWidget({
    super.key,
  });

  Widget floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        openAddDialog(
            context,
            TaskItem(
                id: "", createdOn: DateTime.now(), dueDate: DateTime.now()));
      },
      tooltip: 'Add',
      child: const Icon(Icons.add),
    );
  }

  PreferredSizeWidget appbar(BuildContext context) {
    return AppBar(
      title: boldText("Tasks List"),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: Get.isDarkMode
                ? const LinearGradient(colors: [Colors.black, Colors.blueGrey])
                : LinearGradient(colors: [const Color(0xFFE1BEE7), Colors.grey.shade100])
        ),
      ),
      elevation: 4,
      actions: [
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Toggle Day/Night',
              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface), // small text
            ),
          ),
          onTap: () {
            if(Get.isDarkMode){
              Get.changeThemeMode(ThemeMode.light);
            }else{
              Get.changeThemeMode(ThemeMode.dark);
            }

          },
        ),
        Container(
          width: 2,
          color: Colors.red,
          height: 20,
        ),
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Filter/Sort',
              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface), // small text
            ),
          ),
          onTap: () {
            openFilterAndSortDialog(context);
          },
        ),
      ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(10), // height = padding you want
          child: SizedBox(), // Empty space acts as bottom padding
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: scaffoldBody(context),
      floatingActionButton: floatingActionButton(context),
      resizeToAvoidBottomInset: true,
      appBar: appbar(context),
    );
  }

  Widget scaffoldBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Obx(() => tasksList(context,
                tasksController.filteredAndSortedResults.toList())))
      ],
    );
  }

  Widget noTasksFound() {
    return const Center(child: Text('No tasks available'));
  }

  Widget tasksList(BuildContext context, List<TaskItem> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (contextIn, index) {
        return listItem(context, tasks[index]);
      },
    );
  }

  Widget listItem(BuildContext context, TaskItem task) {
    return TaskCard(taskItem: task, onDelete: () {
      openDeleteDialog(context, task);
    },
    onEdit: () {
      openEditDialog(context, task);
    },);
  }

  Widget refreshing() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void openAddDialog(BuildContext context, TaskItem taskItem) {
    showAddDialog(context);
  }

  void openDeleteDialog(BuildContext context, TaskItem taskItem) {
    showDeleteDialog(context, taskItem, () {
      tasksController.deleteTask(taskItem);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task Deleted at ${DateTime.now()}')),
          );
    });
  }

  void openEditDialog(BuildContext context, TaskItem taskItem) {
    showEditDialog(context, taskItem);

  }

  void openFilterAndSortDialog(BuildContext context) {
    showFilterAndSortDialog(tasksController.sortAndFilterParams.value, context,
        (filter, sort) {
      bool? filterCompleteStatus;
      bool? sortDueDate;
      bool? sortCreationDate;

      if (filter == "Completed") {
        filterCompleteStatus = true;
      }
      if (filter == "Ongoing") {
        filterCompleteStatus = false;
      }
      if (sort == "Due date") {
        sortDueDate = true;
      }
      if (sort == "Creation date") {
        sortCreationDate = true;
      }

      tasksController.sortAndFilter(SortAndFilterParams(
          filterCompleteStatus: filterCompleteStatus,
          sortCreationDate: sortCreationDate,
          sortDueDate: sortDueDate));
    });
  }
}
