import 'package:flutter_task_kata/domain/repositories/task_repository.dart';

class AddTask {
  AddTask(this.repo);
  final TaskRepository repo;
  Future<void> call(String title) => repo.addTask(title);
}
