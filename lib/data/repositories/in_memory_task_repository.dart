import 'dart:math';

import 'package:flutter_task_kata/domain/entities/task.dart';
import 'package:flutter_task_kata/domain/repositories/task_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TaskRepository)
class InMemoryTaskRepository implements TaskRepository {
  final List<Task> _tasks = [];
  final _rand = Random();

  Future<void> _simulateDelay() async {
    final ms = _rand.nextInt(500);
    await Future.delayed(Duration(milliseconds: ms));
  }

  @override
  Future<void> addTask(String title) async {
    await _simulateDelay();
    _tasks.add(Task(title: title));
  }

  @override
  Future<List<Task>> getTasks() async {
    await _simulateDelay();
    return List.unmodifiable(_tasks);
  }

  @override
  Future<void> toggleTask(String title) async {
    await _simulateDelay();

    final index = _tasks.indexWhere((task) => task.title == title);
    if (index == -1) return;

    final updated = _tasks[index].toggle();
    _tasks[index] = updated;
  }
}
