import 'package:flutter_task_kata/domain/entities/task.dart';

abstract class TaskRepository {
  Future<void> addTask(String title);
  Future<void> toggleTask(String title);
  Future<List<Task>> getTasks();
}
