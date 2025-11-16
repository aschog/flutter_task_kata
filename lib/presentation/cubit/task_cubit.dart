import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_task_kata/domain/entities/task.dart';
import 'package:flutter_task_kata/domain/usecases/add_task.dart';
import 'package:flutter_task_kata/domain/usecases/get_tasks.dart';
import 'package:flutter_task_kata/domain/usecases/toggle_task.dart';

class TaskState extends Equatable {
  final List<Task> tasks;
  final bool isLoading;

  const TaskState({required this.tasks, required this.isLoading});

  const TaskState.initial() : this(tasks: const [], isLoading: false);

  TaskState copyWith({List<Task>? tasks, bool? isLoading}) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [tasks, isLoading];
}

class TaskCubit extends Cubit<TaskState> {
  final AddTask addTask;
  final GetTasks getTasks;
  final ToggleTask toggleTask;

  TaskCubit({
    required this.getTasks,
    required this.addTask,
    required this.toggleTask,
  }) : super(const TaskState.initial());

  Future<void> addTaskAction(String title) async {
    emit(state.copyWith(isLoading: true));

    await addTask(title);
    final tasks = await getTasks();
    emit(TaskState(tasks: tasks, isLoading: false));
  }

  Future<void> loadTasks() async {
    emit(state.copyWith(isLoading: true));

    final tasks = await getTasks();
    emit(TaskState(tasks: tasks, isLoading: false));
  }

  Future<void> toggleTaskAction(String title) async {
    emit(state.copyWith(isLoading: true));

    await toggleTask(title);
    final tasks = await getTasks();
    emit(TaskState(tasks: tasks, isLoading: false));
  }
}
