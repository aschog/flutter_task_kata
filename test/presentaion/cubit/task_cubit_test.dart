import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_task_kata/domain/entities/task.dart';
import 'package:flutter_task_kata/domain/usecases/add_task.dart';
import 'package:flutter_task_kata/domain/usecases/get_tasks.dart';
import 'package:flutter_task_kata/domain/usecases/toggle_task.dart';
import 'package:flutter_task_kata/presentation/cubit/task_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([AddTask, GetTasks, ToggleTask])
import 'task_cubit_test.mocks.dart';

void main() {
  late MockAddTask mockAdd;
  late MockGetTasks mockGet;
  late MockToggleTask mockToggle;

  setUp(() {
    mockAdd = MockAddTask();
    mockGet = MockGetTasks();
    mockToggle = MockToggleTask();
  });

  group('TaskCubit', () {
    blocTest<TaskCubit, TaskState>(
      'loads task',
      build: () {
        when(mockGet()).thenAnswer((_) async => [const Task(title: 'A')]);
        return TaskCubit(
          getTasks: mockGet,
          addTask: mockAdd,
          toggleTask: mockToggle,
        );
      },
      act: (cubit) => cubit.loadTasks(),
      expect: () => [
        const TaskState(tasks: [], isLoading: true),
        const TaskState(tasks: [Task(title: 'A')], isLoading: false),
      ],
      verify: (_) {
        verify(mockGet()).called(1);
      },
    );

    blocTest<TaskCubit, TaskState>(
      'add new task',
      build: () {
        when(mockAdd('New Task')).thenAnswer((_) async {});
        when(
          mockGet(),
        ).thenAnswer((_) async => [const Task(title: 'New Task')]);
        return TaskCubit(
          getTasks: mockGet,
          addTask: mockAdd,
          toggleTask: mockToggle,
        );
      },
      act: (cubit) => cubit.addTaskAction('New Task'),
      expect: () => [
        const TaskState(tasks: [], isLoading: true),
        const TaskState(tasks: [Task(title: 'New Task')], isLoading: false),
      ],
    );

    blocTest<TaskCubit, TaskState>(
      'toggles a task',
      build: () {
        when(mockToggle('A')).thenAnswer((_) async {});
        when(
          mockGet(),
        ).thenAnswer((_) async => [const Task(title: 'A', isDone: true)]);
        return TaskCubit(
          getTasks: mockGet,
          addTask: mockAdd,
          toggleTask: mockToggle,
        );
      },
      act: (cubit) => cubit.toggleTaskAction('A'),
      expect: () => [
        const TaskState(tasks: [], isLoading: true),
        const TaskState(
          tasks: [Task(title: 'A', isDone: true)],
          isLoading: false,
        ),
      ],
    );
  });
}
