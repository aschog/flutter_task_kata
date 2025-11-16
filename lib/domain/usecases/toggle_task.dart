import 'package:flutter_task_kata/domain/repositories/task_repository.dart';

class ToggleTask {
  ToggleTask(this.repo);
  final TaskRepository repo;
  Future<void> call(String title) => repo.toggleTask(title);
}
