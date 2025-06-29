import 'package:taskit/data/task_item.dart';

abstract class TaskRepository {
    /// Fetch all tasks
    Future<List<TaskItem>> getAllTasks();

    /// Add or overwrite a task
    Future<void> addTask(TaskItem task);

    /// Remove task by ID
    Future<void> removeTaskById(String id);

    /// Get task by ID
    Future<TaskItem?> getTaskById(String id);
}
