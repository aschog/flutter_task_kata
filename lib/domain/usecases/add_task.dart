import 'package:flutter_task_kata/domain/entities/task.dart';
import 'package:flutter_task_kata/domain/repositories/task_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@injectable
class AddTask {
  AddTask(this.repo);
  final TaskRepository repo;
  Future<Task> call(String title) async {
    final task = Task(id: const Uuid().v4(), title: title);
    await repo.addTask(task);
    return task;
  }
}
