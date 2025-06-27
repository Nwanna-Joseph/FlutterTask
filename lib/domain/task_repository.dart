import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:taskit/data/task_item.dart';

class TaskRepository {

    static const storageService = FlutterSecureStorage();

    Future<Map<String, String>> getTasks(){
        return storageService.readAll();
    }

    Future addTask(TaskItem task){
        return storageService.write(key: task.id, value: "");
    }

    Future removeTask(TaskItem task){
        return storageService.delete(key: task.id);
    }

    Future editTasks(TaskItem task){
        return storageService.write(key: task.id, value: "");
    }

}