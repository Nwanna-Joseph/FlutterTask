import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:taskit/data/models/task_item.dart';
import 'package:taskit/domain/task_repository.dart';
import 'package:taskit/presentation/controller/TasksController.dart';
import 'package:taskit/presentation/screen/dialog/task_add_task_dialog.dart';
import 'package:taskit/presentation/screen/dialog/task_delete_dialog.dart';
import 'package:taskit/presentation/screen/dialog/task_edit_task_dialog.dart';
import 'package:taskit/presentation/screen/dialog/tasks_list_filter.dart';
import 'package:taskit/presentation/screen/widgets/text_widget.dart';
import 'package:taskit/presentation/screen/widgets/task_card.dart';
import 'package:taskit/data/repository/task_repository_impl.dart';

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
      // backgroundColor: Colors.red,
      // foregroundColor: Colors.white,
      // shadowColor: Colors.grey.shade400,
      elevation: 4,
      actions: [
        TextButton.icon(
          onPressed: () {
            if(Get.isDarkMode){
              Get.changeThemeMode(ThemeMode.light);
            }else{
              Get.changeThemeMode(ThemeMode.dark);
            }
          },
          label: Text(
            'Toggle Day/Night',
            style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface), // small text
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // optional: rounded corners
            ),
          ),
        ),
        Container(
          width: 2,
          color: Colors.red,
          height: 20,
        ),
        TextButton.icon(
          onPressed: () {
            openFilterAndSortDialog(context);
          },
          // icon: const Icon(Icons.filter_list, size: 16),
          label: Text(
            'Filter/Sort',
            style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface), // small text
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            // side: BorderSide(color: Theme.of(context).colorScheme.onSurface), // 👈 border here
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // optional: rounded corners
            ),
          ),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // noTasksFound(),
            // refreshing(),
          ],
        ),
        Expanded(
            child: Obx(() => tasksList(context,
                tasksController.filteredAndSortedResults.value.toList())))
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
                    FadeInAnimation(child: listItem(context, tasks[index]))));
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
    return ListTile(
      leading: task.completedStatus == true ? const Icon(Icons.check) : const Icon(Icons.warning),
      title: Text("${task.title}",),
      trailing: Wrap(
        spacing: 0,
        children: [
          TextButton.icon(
            onPressed: () {
              openEditDialog(context, task);
            },
            // icon: const Icon(Icons.filter_list, size: 16),
            label: Text(
              'Edit',
              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface), // small text
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              // side: BorderSide(color: Theme.of(context).colorScheme.onSurface), // 👈 border here
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // optional: rounded corners
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              openDeleteDialog(context, task);
            },
            // icon: const Icon(Icons.filter_list, size: 16),
            label: Text(
              'Delete',
              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface), // small text
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              // side: BorderSide(color: Theme.of(context).colorScheme.onSurface), // 👈 border here
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // optional: rounded corners
              ),
            ),
          ),
          Visibility(
            visible: false,
            child: IconButton(
                onPressed: () {
                  openEditDialog(context, task);
                },
                icon: const Icon(Icons.edit)),
          ),
          Visibility(
            visible: false,
            child: IconButton(
                onPressed: () {
                  openDeleteDialog(context, task);
                },
                icon: const Icon(Icons.delete)),
          ),
        ],
      ),
      onTap: () {
        // Handle item tap if needed
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Tapped on: ${task.title}')),
        // );
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
