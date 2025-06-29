import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:taskit/data/task_item.dart';
import 'dart:convert';

import 'package:taskit/domain/task_repository.dart';


class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late TaskRepository taskRepository;
  late MockFlutterSecureStorage mockStorage;
  late TaskItem task;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    taskRepository = TaskRepository(storage: mockStorage); // Add this factory constructor
    task = TaskItem(
      id: '1',
      title: 'Test Task',
      note: 'This is a test task.',
      dueDate: DateTime.parse('2025-06-27'),
      createdOn: DateTime.parse('2025-06-27'),
    );
  });

  group('TaskRepository', () {
    test('should add a task', () async {
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      await taskRepository.addTask(task);

      verify(() => mockStorage.write(key: task.id, value: task.toJson())).called(1);
    });

    test('should get all tasks', () async {
      final fakeData = {
        '1': task.toJson(),
        '2': TaskItem(
          id: '2',
          title: 'Task 2',
          note: 'Second task',
          dueDate: DateTime.now(),
          createdOn: DateTime.now(),
        ).toJson(),
      };

      when(() => mockStorage.readAll()).thenAnswer((_) async => fakeData);

      final result = await taskRepository.getTasks();

      expect(result.length, 2);
      expect(result['1'], task.toJson());
    });

    test('should remove a task', () async {
      when(() => mockStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async {});

      await taskRepository.removeTask(task);

      verify(() => mockStorage.delete(key: task.id)).called(1);
    });

    test('should edit a task (overwrite)', () async {
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      await taskRepository.editTask(task);

      verify(() => mockStorage.write(key: task.id, value: task.toJson())).called(1);
    });

    test('should get a task by id', () async {
      when(() => mockStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => task.toJson());

      final result = await taskRepository.getTaskById(task.id);

      expect(result, isNotNull);
      expect(result!.id, task.id);
      expect(result.title, task.title);
    });

    test('should return null if task id does not exist', () async {
      when(() => mockStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => null);

      final result = await taskRepository.getTaskById('non-existent-id');

      expect(result, isNull);
    });
  });
}
