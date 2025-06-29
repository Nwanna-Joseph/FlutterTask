import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get/get.dart';
import 'package:taskit/domain/entities/task_item.dart';
import 'package:taskit/presentation/controller/tasks_controller.dart';
import 'package:taskit/domain/repositories/task_repository.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late TasksController controller;
  late MockTaskRepository mockRepository;

  final sampleTask = TaskItem(
    id: '1',
    title: 'Test Task',
    note: 'A task for testing',
    dueDate: DateTime(2025, 7, 1),
    createdOn: DateTime(2025, 6, 27),
    completedStatus: false,
  );

  setUp(() {
    mockRepository = MockTaskRepository();
    Get.reset();
    Get.put<TaskRepository>(mockRepository);
    controller = TasksController();
  });

  test('addTask calls repository and refreshes tasks', () async {
    when(() => mockRepository.addTask(sampleTask)).thenAnswer((_) async {});
    when(() => mockRepository.getAllTasks()).thenAnswer((_) async => [sampleTask]);

    await controller.addTask(sampleTask);

    verify(() => mockRepository.addTask(sampleTask)).called(1);
    expect(controller.filteredAndSortedResults.length, 1);
    expect(controller.filteredAndSortedResults.first.id, sampleTask.id);
  });

  test('deleteTask calls repository and refreshes tasks', () async {
    when(() => mockRepository.removeTaskById(sampleTask.id)).thenAnswer((_) async {});
    when(() => mockRepository.getAllTasks()).thenAnswer((_) async => []);

    await controller.deleteTask(sampleTask);

    verify(() => mockRepository.removeTaskById(sampleTask.id)).called(1);
    expect(controller.filteredAndSortedResults.isEmpty, isTrue);
  });

  test('editTask calls repository and refreshes tasks', () async {
    when(() => mockRepository.addTask(sampleTask)).thenAnswer((_) async {});
    when(() => mockRepository.getAllTasks()).thenAnswer((_) async => [sampleTask]);

    await controller.editTask(sampleTask);

    verify(() => mockRepository.addTask(sampleTask)).called(1);
    expect(controller.filteredAndSortedResults.length, 1);
  });

  test('fetchTasksFromDevice populates controller with tasks', () async {
    when(() => mockRepository.getAllTasks()).thenAnswer((_) async => [sampleTask]);

    await controller.fetchTasksFromDevice();

    expect(controller.filteredAndSortedResults.length, 1);
    expect(controller.filteredAndSortedResults.first.title, 'Test Task');
  });

  test('sortAndFilter sorts tasks by creation date ascending', () async {
    final olderTask = TaskItem(
      id: '2',
      title: 'Older Task',
      note: '',
      dueDate: DateTime(2025, 7, 1),
      createdOn: DateTime(2025, 6, 1),
      completedStatus: false,
    );

    when(() => mockRepository.getAllTasks()).thenAnswer((_) async => [sampleTask,olderTask]);
    await controller.fetchTasksFromDevice();
    controller.sortAndFilter(SortAndFilterParams(sortCreationDate: true));

    expect(controller.filteredAndSortedResults.first.id, '2');
  });

  test('sortAndFilter filters tasks by completedStatus', () async {
    final completedTask = TaskItem(
      id: '2',
      title: 'Done Task',
      note: '',
      dueDate: DateTime(2025, 7, 1),
      createdOn: DateTime(2025, 6, 1),
      completedStatus: true,
    );

    when(() => mockRepository.getAllTasks()).thenAnswer((_) async => [sampleTask,completedTask]);
    await controller.fetchTasksFromDevice();
    controller.sortAndFilter(SortAndFilterParams(filterCompleteStatus: true));

    expect(controller.filteredAndSortedResults.length, 1);
    expect(controller.filteredAndSortedResults.first.completedStatus, isTrue);
  });

  test('fetchTasksFromDevice handles empty task list', () async {
    when(() => mockRepository.getAllTasks()).thenAnswer((_) async => []);

    await controller.fetchTasksFromDevice();

    expect(controller.filteredAndSortedResults, isEmpty);
  });

  test('sortAndFilter handles tasks with same createdOn date', () async {
    final task2 = TaskItem(
      id: '2',
      title: 'Same Date Task',
      note: '',
      dueDate: sampleTask.dueDate,
      createdOn: sampleTask.createdOn,
      completedStatus: false,
    );

    when(() => mockRepository.getAllTasks()).thenAnswer((_) async => [sampleTask, task2]);

    await controller.fetchTasksFromDevice();
    controller.sortAndFilter(SortAndFilterParams(sortCreationDate: true));

    // Order is not guaranteed, but it should return both
    expect(controller.filteredAndSortedResults.length, 2);
    expect(controller.filteredAndSortedResults.any((t) => t.id == '1'), isTrue);
    expect(controller.filteredAndSortedResults.any((t) => t.id == '2'), isTrue);
  });


  test('sortAndFilter sorts by due date descending', () async {
    final task2 = TaskItem(
      id: '2',
      title: 'Later Due Task',
      note: '',
      dueDate: DateTime(2025, 8, 1),
      createdOn: DateTime(2025, 6, 1),
      completedStatus: false,
    );

    when(() => mockRepository.getAllTasks()).thenAnswer((_) async => [sampleTask, task2]);

    await controller.fetchTasksFromDevice();
    controller.sortAndFilter(SortAndFilterParams(sortDueDate: false));

    expect(controller.filteredAndSortedResults.first.id, '2');
  });

}
