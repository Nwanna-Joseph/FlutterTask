import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:taskit/data/models/task_models.dart';
import 'package:taskit/domain/entities/task_item.dart';
import 'package:taskit/domain/repositories/task_repository.dart';

class TaskRepositoryImpl extends TaskRepository{

    FlutterSecureStorage storage;

    TaskRepositoryImpl({ this.storage  = const FlutterSecureStorage() } );

    @override
    Future<void> addTask(TaskItem task) async {
        var taskModel = TaskModel(
            id: task.id,
            title: task.title,
            note: task.note,
            dueDate: task.dueDate,
            createdOn: task.createdOn,
            completedStatus: task.completedStatus,
        );
        await storage.write(
            key: task.id,
            value: taskModel.toJson(),
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
        return TaskModel.fromJson(jsonStr);
    }

    @override
    Future<List<TaskItem>> getAllTasks() async {
        final all = await storage.readAll();
        return all.entries
            .map((entry) => TaskModel.fromJson(entry.value))
            .toList();
    }
}
