import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:taskit/data/models/task_item.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:taskit/domain/task_repository.dart';

class TaskRepositoryImpl extends TaskRepository{

    FlutterSecureStorage storage;

    TaskRepositoryImpl({ this.storage  = const FlutterSecureStorage() } );

    @override
    Future<void> addTask(TaskItem task) async {
        await storage.write(
            key: task.id,
            value: task.toJson(),
        );
    }

    @override
    Future<void> removeTaskById(String id) async {
        await storage.delete(key: id);
    }

    @override
    Future<TaskItem?> getTaskById(String id) async {
        final jsonStr = await storage.read(key: id);
        if (jsonStr == null) return null;
        return TaskItem.fromJson(jsonStr);
    }

    @override
    Future<List<TaskItem>> getAllTasks() async {
        final all = await storage.readAll();
        return all.entries
            .map((entry) => TaskItem.fromJson(entry.value))
            .toList();
    }
}
