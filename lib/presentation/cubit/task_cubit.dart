import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_task_kata/domain/entities/task.dart';
import 'package:flutter_task_kata/domain/usecases/task_usecases.dart';
import 'package:injectable/injectable.dart';

class TaskState extends Equatable {
  final List<Task> tasks;
  final bool isLoading;
  final String? error;

  const TaskState({
    required this.tasks,
    required this.isLoading,
    this.error,
  });

  const TaskState.initial()
      : this(tasks: const [], isLoading: false, error: null);

  TaskState copyWith({
    List<Task>? tasks,
    bool? isLoading,
    String? Function()? error,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: error != null ? error() : this.error,
    );
  }

  @override
  List<Object?> get props => [tasks, isLoading, error];
}

@injectable
class TaskCubit extends Cubit<TaskState> {
  final TaskUseCases _useCases;

  TaskCubit(this._useCases) : super(const TaskState.initial());

  Future<void> addTaskAction(String title) async {
    emit(state.copyWith(isLoading: true, error: () => null));

    try {
      final newTask = await _useCases.addTask(title);
      final currentTasks = List<Task>.from(state.tasks);
      currentTasks.add(newTask);
      emit(state.copyWith(tasks: currentTasks, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: () => "Failed to add task"));
    }
  }

  Future<void> loadTasks() async {
    emit(state.copyWith(isLoading: true, error: () => null));

    try {
      final tasks = await _useCases.getTasks();
      emit(TaskState(tasks: tasks, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: () => "Failed to load tasks"));
    }
  }

  Future<void> toggleTaskAction(String id) async {
    emit(state.copyWith(isLoading: true, error: () => null));

    try {
      await _useCases.toggleTask(id);
      final currentTasks = state.tasks.map((t) {
        if (t.id == id) return t.toggle();
        return t;
      }).toList();

      emit(state.copyWith(tasks: currentTasks, isLoading: false));
    } catch (e) {
      emit(
          state.copyWith(isLoading: false, error: () => "Failed to toggle task"));
    }
  }
}