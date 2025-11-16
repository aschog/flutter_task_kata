import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_kata/domain/entities/task.dart';
import 'package:flutter_task_kata/presentation/cubit/task_cubit.dart';
import 'package:flutter_task_kata/presentation/views/task_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<TaskCubit>()])
import 'task_screen_test.mocks.dart';

void main() {
  late MockTaskCubit mockCubit;

  const initalState = TaskState(tasks: [], isLoading: false);

  Widget makeTestable(Widget child) {
    return MaterialApp(
      home: BlocProvider<TaskCubit>.value(value: mockCubit, child: child),
    );
  }

  setUp(() {
    mockCubit = MockTaskCubit();
    when(mockCubit.state).thenReturn(initalState);
  });

  testWidgets('shows empty message when no tasks', (tester) async {
    await tester.pumpWidget(makeTestable(const TaskScreen()));

    expect(find.text('No tasks yet'), findsOneWidget);
  });

  testWidgets('renders tasks', (tester) async {
    when(mockCubit.state).thenReturn(
      const TaskState(
        tasks: [
          Task(title: 'A'),
          Task(title: 'B', isDone: true),
        ],
        isLoading: false,
      ),
    );

    await tester.pumpWidget(makeTestable(const TaskScreen()));

    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
  });

  testWidgets('tapping a task toggles it', (tester) async {
    when(
      mockCubit.state,
    ).thenReturn(const TaskState(tasks: [Task(title: 'A')], isLoading: false));

    await tester.pumpWidget(makeTestable(const TaskScreen()));

    await tester.tap(find.text('A'));
    verify(mockCubit.toggleTaskAction('A')).called(1);
  });

  testWidgets('adding a task calls addTaskAction', (tester) async {
    await tester.pumpWidget(makeTestable(const TaskScreen()));

    await tester.enterText(find.byType(TextField), 'New Task');
    await tester.tap(find.byIcon(Icons.add));

    verify(mockCubit.addTaskAction('New Task')).called(1);
  });
}
