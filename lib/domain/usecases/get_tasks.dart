import 'package:flutter_task_kata/domain/entities/task.dart';
import 'package:flutter_task_kata/domain/repositories/task_repository.dart';

class GetTasks {
  GetTasks(this.repo);
  final TaskRepository repo;
  Future<List<Task>> call() => repo.getTasks();
}
