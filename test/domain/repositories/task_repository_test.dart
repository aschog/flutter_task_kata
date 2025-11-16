import 'package:flutter_task_kata/domain/entities/task.dart';
import 'package:flutter_task_kata/domain/repositories/task_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class DummyRepo implements TaskRepository {
  final List<Task> _list = <Task>[];

  @override
  Future<void> addTask(String title) async => _list.add(Task(title: title));

  @override
  Future<List<Task>> getTasks() async => _list;

  @override
  Future<void> toggleTask(String title) async {}
}

void main() {
  test('task repository contract works', () async {
    final repo = DummyRepo();
    await repo.addTask('A');
    final tasks = await repo.getTasks();
    expect(tasks.first.title, 'A');
  });
}
