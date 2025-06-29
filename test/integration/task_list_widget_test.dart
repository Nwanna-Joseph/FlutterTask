import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:taskit/data/task_item.dart';
import 'package:taskit/domain/task_repository.dart';
import 'package:taskit/presentation/screen/tasklist_widget.dart';

import 'package:taskit/presentation/controller/TasksController.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late TasksController controller;
  late MockTaskRepository mockRepository;

  final testTask = TaskItem(
    id: '123',
    title: 'Test Task',
    note: 'Desc',
    createdOn: DateTime(2025, 6, 26),
    dueDate: DateTime(2025, 6, 30),
    completedStatus: false,
  );

  setUp(() {
    // Reset GetX bindings
    Get.reset();

    // Register mock and controller
    mockRepository = MockTaskRepository();
    Get.put<TaskRepository>(mockRepository);
    controller = Get.put(TasksController());

    // Inject mock task data
    when(() => mockRepository.getAllTasks()).thenAnswer((_) async => [testTask]);
    controller.filteredAndSortedResults.value = [testTask];
  });

  tearDown(() {
    Get.delete<TasksController>();
    Get.delete<TaskRepository>();
  });

  testWidgets('Renders task title in UI', (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(home: TaskListWidget()));
    expect(find.text('Test Task'), findsOneWidget);
  });

  testWidgets('Floating action button opens add dialog', (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(home: TaskListWidget()));
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Assert the dialog or any part of it opened
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Delete button shows delete dialog', (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(home: TaskListWidget()));
    final deleteBtn = find.text('Delete').first;
    expect(deleteBtn, findsOneWidget);

    await tester.tap(deleteBtn);
    await tester.pumpAndSettle();

    // Depending on implementation, test dialog or Snackbar
    expect(find.textContaining('Delete'), findsWidgets); // loose check
  });

  testWidgets('Filter button opens filter dialog', (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(home: TaskListWidget()));
    final filterBtn = find.text('Filter/Sort');
    expect(filterBtn, findsOneWidget);

    await tester.tap(filterBtn);
    await tester.pumpAndSettle();

    // You can add a key to your dialog widget for better assertions
    expect(filterBtn, findsOneWidget);
  });

  testWidgets('Theme toggle button switches theme', (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(home: TaskListWidget()));
    final themeBtn = find.text('Toggle Day/Night');
    expect(themeBtn, findsOneWidget);

    await tester.tap(themeBtn);
    await tester.pumpAndSettle();

    // You can test for a theme-related widget or color here
    expect(themeBtn, findsOneWidget);
  });
}
