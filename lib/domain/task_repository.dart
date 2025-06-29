import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:taskit/data/task_item.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TaskRepository {

    FlutterSecureStorage storage;

    TaskRepository({ this.storage  = const FlutterSecureStorage() } );

    /// Fetch all tasks as a map of id -> jsonString
    Future<Map<String, String>> getTasks() async {
        return await storage.readAll();
    }

    /// Add a task by writing its JSON to secure storage
    Future<void> addTask(TaskItem task) async {
        await storage.write(key: task.id, value: task.toJson());
    }

    /// Remove a task by its id
    Future<void> removeTask(TaskItem task) async {
        await storage.delete(key: task.id);
    }

    /// Edit task is same as add (overwrite)
    Future<void> editTask(TaskItem task) async {
        await storage.write(key: task.id, value: task.toJson());
    }

    /// Get a single task
    Future<TaskItem?> getTaskById(String id) async {
        final json = await storage.read(key: id);
        if (json == null) return null;
        return TaskItem.fromJson(json);
    }
}
