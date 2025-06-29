import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:taskit/data/models/task_item.dart';
import 'package:taskit/data/repository/task_repository_impl.dart';
import 'package:taskit/domain/task_repository.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late TaskRepository taskRepository;
  late MockFlutterSecureStorage mockStorage;
  late TaskItem task;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    taskRepository = TaskRepositoryImpl(storage: mockStorage);
    task = TaskItem(
      id: '1',
      title: 'Test Task',
      note: 'This is a test task.',
      dueDate: DateTime.parse('2025-06-27'),
      createdOn: DateTime.parse('2025-06-27'),
    );
  });

  group('TaskRepository CRUD Operations', () {
    test('adds a task', () async {
      when(() => mockStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      )).thenAnswer((_) async {});

      await taskRepository.addTask(task);

      verify(() => mockStorage.write(key: task.id, value: task.toJson())).called(1);
    });

    test('edits (overwrites) a task', () async {
      when(() => mockStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      )).thenAnswer((_) async {});

      await taskRepository.addTask(task);

      verify(() => mockStorage.write(key: task.id, value: task.toJson())).called(1);
    });

    test('removes a task by ID', () async {
      when(() => mockStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async {});

      await taskRepository.removeTaskById(task.id);

      verify(() => mockStorage.delete(key: task.id)).called(1);
    });

    test('gets a task by ID', () async {
      when(() => mockStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => task.toJson());

      final result = await taskRepository.getTaskById(task.id);

      expect(result, isNotNull);
      expect(result!.id, task.id);
      expect(result.title, task.title);
      expect(result.note, task.note);
    });

    test('returns null for non-existent task', () async {
      when(() => mockStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => null);

      final result = await taskRepository.getTaskById('unknown-id');

      expect(result, isNull);
    });

    test('gets all tasks', () async {
      final anotherTask = TaskItem(
        id: '2',
        title: 'Task 2',
        note: 'Second task',
        dueDate: DateTime.now(),
        createdOn: DateTime.now(),
      );

      final fakeData = {
        'task_1': task.toJson(),
        'task_2': anotherTask.toJson(),
      };

      when(() => mockStorage.readAll()).thenAnswer((_) async => fakeData);

      final result = await taskRepository.getAllTasks();

      expect(result.length, 2);
      expect(result.any((t) => t.id == task.id), isTrue);
      expect(result.any((t) => t.id == anotherTask.id), isTrue);
    });
  });
}
