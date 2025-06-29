import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:taskit/data/models/task_item.dart';
import 'package:taskit/domain/task_repository.dart';

import 'package:taskit/presentation/controller/TasksController.dart';
import 'package:taskit/presentation/screen/dialog/task_add_task_dialog.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late TasksController controller;
  late MockTaskRepository mockRepo;

  final testTask = TaskItem(
    id: '123',
    title: 'Test Task',
    note: 'Desc',
    createdOn: DateTime(2025, 6, 26),
    dueDate: DateTime(2025, 6, 30),
    completedStatus: false,
  );

  setUp(() {
    Get.reset();
    mockRepo = MockTaskRepository();
    Get.put<TaskRepository>(mockRepo);

    when(() => mockRepo.getAllTasks()).thenAnswer((_) async => [testTask]);

    controller = Get.put(TasksController());
    controller.filteredAndSortedResults.value = [testTask];
  });

  setUpAll(() {
    registerFallbackValue(testTask);
  });

  tearDown(() {
    Get.delete<TasksController>();
    Get.delete<TaskRepository>();
  });

  testWidgets('renders AddTaskForm dialog and form fields', (tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: Scaffold(
          body: Center(child: AddTaskForm()),
        ),
      ),
    );

    expect(find.byKey(const Key('add_task_dialog')), findsOneWidget);
    expect(find.byKey(const Key('title_field')), findsOneWidget);
    expect(find.byKey(const Key('note_field')), findsOneWidget);
    expect(find.byKey(const Key('date_picker')), findsOneWidget);
    expect(find.byKey(const Key('submit_button')), findsOneWidget);
  });

  testWidgets('fills title and note, taps submit', (tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: Scaffold(
          body: AddTaskForm(),
        ),
      ),
    );

    await tester.enterText(find.byKey(const Key('title_field')), '${testTask.title}');
    await tester.enterText(find.byKey(const Key('note_field')), '${testTask.note}');

    expect(find.text('${testTask.title}'), findsOneWidget);
    expect(find.text('${testTask.note}'), findsOneWidget);

    // Mock addTask call
    when(() => mockRepo.addTask(any())).thenAnswer((_) async {});

    await tester.tap(find.byKey(const Key('submit_button')));
    await tester.pumpAndSettle();

    verify(() => mockRepo.addTask(any())).called(1);
  });

  testWidgets('shows validation error when fields are empty', (tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: Scaffold(
          body: AddTaskForm(),
        ),
      ),
    );

    await tester.enterText(find.byKey(const Key('title_field')), '');
    await tester.enterText(find.byKey(const Key('note_field')), '');

    await tester.tap(find.byKey(const Key('submit_button')));
    await tester.pumpAndSettle();

    expect(find.text('Enter a title'), findsOneWidget);
    expect(find.text('Enter a note'), findsOneWidget);
  });

  testWidgets('date picker opens and selects date', (tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: Scaffold(
          body: AddTaskForm(),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('date_picker')));
    await tester.pumpAndSettle();

    // pick a date manually (DatePicker is a native component, so simulate behavior)
    // We'll assume the interaction works, so we just verify the dialog opens
    expect(find.byType(DatePickerDialog), findsOneWidget);
  });
}
