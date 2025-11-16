import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_kata/data/repositories/in_memory_task_repository.dart';
import 'package:flutter_task_kata/domain/usecases/add_task.dart';
import 'package:flutter_task_kata/domain/usecases/get_tasks.dart';
import 'package:flutter_task_kata/domain/usecases/toggle_task.dart';
import 'package:flutter_task_kata/presentation/cubit/task_cubit.dart';
import 'package:flutter_task_kata/presentation/views/task_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final repo = InMemoryTaskRepository();

  final getTasks = GetTasks(repo);
  final addTask = AddTask(repo);
  final toggleTaks = ToggleTask(repo);

  runApp(MyApp(getTasks: getTasks, addTask: addTask, toggleTask: toggleTaks));
}

class MyApp extends StatelessWidget {
  final GetTasks getTasks;
  final AddTask addTask;
  final ToggleTask toggleTask;

  const MyApp({
    super.key,
    required this.getTasks,
    required this.addTask,
    required this.toggleTask,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Kata',
      home: BlocProvider(
        create: (_) => TaskCubit(
          getTasks: getTasks,
          addTask: addTask,
          toggleTask: toggleTask,
        ),
        child: const TaskScreen(),
      ),
    );
  }
}
