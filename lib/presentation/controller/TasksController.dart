import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:taskit/data/task_item.dart';
import 'package:taskit/domain/task_repository.dart';

class TasksController extends GetxController {
  final TaskRepository tasksRepository = Get.find<TaskRepository>();
  final userNameTextController = TextEditingController();

  final RxString topUsername = ''.obs;
  final RxList<TaskItem> filteredAndSortedResults = <TaskItem>[].obs;
  final Rx<SortAndFilterParams> sortAndFilterParams = SortAndFilterParams().obs;

  List<TaskItem> _allTasks = [];

  @override
  void onReady() {
    super.onReady();
    fetchTasksFromDevice();
  }

  @override
  void onClose() {
    userNameTextController.dispose();
    super.onClose();
  }

  Future<void> addTask(TaskItem taskItem) async {
    await tasksRepository.addTask(taskItem);
    await fetchTasksFromDevice();
  }

  Future<void> deleteTask(TaskItem taskItem) async {
    await tasksRepository.removeTaskById(taskItem.id);
    await fetchTasksFromDevice();
  }

  Future<void> editTask(TaskItem taskItem) async {
    await tasksRepository.addTask(taskItem); // Assuming overwrite
    await fetchTasksFromDevice();
  }

  Future<void> fetchTasksFromDevice() async {
    _allTasks = await tasksRepository.getAllTasks();
    applySortAndFilter();
  }

  void applySortAndFilter() {
    final params = sortAndFilterParams.value;

    var results = _allTasks.where((task) {
      final matchStatus = params.filterCompleteStatus == null || task.completedStatus == params.filterCompleteStatus;
      final matchDueDate = params.filterDueDate == null || task.dueDate == params.filterDueDate;
      final matchCreationDate = params.filterCreationDate == null || task.createdOn == params.filterCreationDate;

      return matchStatus && matchDueDate && matchCreationDate;
    }).toList();

    if (params.sortCreationDate != null) {
      results.sort((a, b) => params.sortCreationDate!
          ? a.createdOn.compareTo(b.createdOn)
          : b.createdOn.compareTo(a.createdOn));
    }

    if (params.sortDueDate != null) {
      results.sort((a, b) => params.sortDueDate!
          ? a.dueDate.compareTo(b.dueDate)
          : b.dueDate.compareTo(a.dueDate));
    }

    filteredAndSortedResults.value = results;
  }

  void sortAndFilter(SortAndFilterParams params) {
    sortAndFilterParams.value = params;
    applySortAndFilter();
  }
}
