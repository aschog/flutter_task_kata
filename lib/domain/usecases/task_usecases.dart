import 'package:flutter_task_kata/domain/usecases/add_task.dart';
import 'package:flutter_task_kata/domain/usecases/get_tasks.dart';
import 'package:flutter_task_kata/domain/usecases/toggle_task.dart';
import 'package:injectable/injectable.dart';

@injectable
class TaskUseCases {
  final AddTask addTask;
  final GetTasks getTasks;
  final ToggleTask toggleTask;

  TaskUseCases({
    required this.addTask,
    required this.getTasks,
    required this.toggleTask,
  });
}
