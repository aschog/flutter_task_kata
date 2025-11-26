import 'package:flutter_task_kata/domain/entities/task.dart';
import 'package:flutter_task_kata/domain/repositories/task_repository.dart';
import 'package:flutter_task_kata/domain/usecases/add_task.dart';
import 'package:flutter_task_kata/domain/usecases/get_tasks.dart';
import 'package:flutter_task_kata/domain/usecases/toggle_task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([TaskRepository])
import 'usecases_test.mocks.dart';

void main() {
  late MockTaskRepository mockRepo;

  setUp(() {
    mockRepo = MockTaskRepository();
  });

  test('AddTask calls repo.addTask', () async {
    final usecase = AddTask(mockRepo);
    when(mockRepo.addTask(any)).thenAnswer((_) async {});
    final result = await usecase.call('X');
    expect(result.title, 'X');
    verify(mockRepo.addTask(any)).called(1);
  });

  test('GetTasks calls repo.getTasks', () async {
    final usecase = GetTasks(mockRepo);
    when(mockRepo.getTasks()).thenAnswer((_) async => <Task>[]);
    await usecase.call();
    verify(mockRepo.getTasks()).called(1);
  });

  test('ToggleTask calls repo.toggleTask', () async {
    final usecase = ToggleTask(mockRepo);
    when(mockRepo.toggleTask(any)).thenAnswer((_) async {});
    await usecase.call('X');
    verify(mockRepo.toggleTask('X')).called(1);
  });
}
