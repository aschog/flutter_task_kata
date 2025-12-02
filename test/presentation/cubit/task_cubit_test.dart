import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_task_kata/domain/entities/task.dart';
import 'package:flutter_task_kata/domain/usecases/add_task.dart';
import 'package:flutter_task_kata/domain/usecases/get_tasks.dart';
import 'package:flutter_task_kata/domain/usecases/task_usecases.dart';
import 'package:flutter_task_kata/domain/usecases/toggle_task.dart';
import 'package:flutter_task_kata/presentation/cubit/task_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([AddTask, GetTasks, ToggleTask])
import 'task_cubit_test.mocks.dart';

void main() {
  final getIt = GetIt.instance;

  late MockAddTask mockAdd;
  late MockGetTasks mockGet;
  late MockToggleTask mockToggle;

  setUp(() {
    getIt.reset();

    mockAdd = MockAddTask();
    mockGet = MockGetTasks();
    mockToggle = MockToggleTask();

    getIt.registerLazySingleton<AddTask>(() => mockAdd);
    getIt.registerLazySingleton<GetTasks>(() => mockGet);
    getIt.registerLazySingleton<ToggleTask>(() => mockToggle);

    getIt.registerLazySingleton<TaskUseCases>(() => TaskUseCases(
          addTask: getIt(),
          getTasks: getIt(),
          toggleTask: getIt(),
        ));
    getIt.registerFactory<TaskCubit>(() => TaskCubit(getIt()));
  });

  tearDown(() {
    getIt.reset();
  });

  group('TaskCubit', () {
    blocTest<TaskCubit, TaskState>(
      'loads task',
      build: () {
        when(mockGet()).thenAnswer((_) async => [const Task(id: '1', title: 'A')]);
        return getIt<TaskCubit>();
      },
      act: (cubit) => cubit.loadTasks(),
      expect: () => [
        const TaskState(tasks: [], isLoading: true),
        const TaskState(
          tasks: [Task(id: '1', title: 'A')],
          isLoading: false,
        ),
      ],
      verify: (_) {
        verify(mockGet()).called(1);
      },
    );

    blocTest<TaskCubit, TaskState>(
      'add new task',
      build: () {
        const t = Task(id: '1', title: 'New Task');
        when(mockAdd('New Task')).thenAnswer((_) async => t);
        return getIt<TaskCubit>();
      },
      act: (cubit) => cubit.addTaskAction('New Task'),
      expect: () => [
        const TaskState(tasks: [], isLoading: true),
        const TaskState(
          tasks: [Task(id: '1', title: 'New Task')],
          isLoading: false,
        ),
      ],
    );

    blocTest<TaskCubit, TaskState>(
      'toggles a task',
      seed: () => const TaskState(
        tasks: [Task(id: '1', title: 'A')],
        isLoading: false,
      ),
      build: () {
        when(mockToggle('1')).thenAnswer((_) async {});
        return getIt<TaskCubit>();
      },
      act: (cubit) => cubit.toggleTaskAction('1'),
      expect: () => [
        const TaskState(
          tasks: [Task(id: '1', title: 'A')],
          isLoading: true,
        ),
        const TaskState(
          tasks: [Task(id: '1', title: 'A', isDone: true)],
          isLoading: false,
        ),
      ],
    );
  });
}