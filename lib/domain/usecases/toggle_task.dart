import 'package:flutter_task_kata/domain/repositories/task_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ToggleTask {
  ToggleTask(this.repo);
  final TaskRepository repo;
  Future<void> call(String title) => repo.toggleTask(title);
}
