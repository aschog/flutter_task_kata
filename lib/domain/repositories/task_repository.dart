import 'package:flutter_task_kata/domain/entities/task.dart';

abstract class TaskRepository {
  Future<void> addTask(Task task);
  Future<void> toggleTask(String id);
  Future<List<Task>> getTasks();
}
