import 'package:flutter/material.dart';
import 'package:taskit/data/repository/task_repository_impl.dart';
import 'package:taskit/domain/repositories/task_repository.dart';
import 'package:taskit/presentation/controller/tasks_controller.dart';
import 'package:taskit/presentation/screen/tasklist_widget.dart';
import 'package:get/get.dart';
import 'package:taskit/presentation/screen/util/theme_util.dart';

void main() {
  Get.lazyPut<TaskRepository>(() => TaskRepositoryImpl());
  Get.lazyPut<TasksController>(() => TasksController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: navyDarkTheme,
      home: TaskListWidget(),
    );
  }
}
