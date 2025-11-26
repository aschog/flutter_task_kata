import 'package:flutter_task_kata/domain/entities/task.dart';
import 'package:flutter_task_kata/domain/repositories/task_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class DummyRepo implements TaskRepository {
  final List<Task> _list = <Task>[];

  @override
  Future<void> addTask(Task task) async => _list.add(task);

  @override
  Future<List<Task>> getTasks() async => _list;

  @override
  Future<void> toggleTask(String id) async {}
}

void main() {
  test('task repository contract works', () async {
    final repo = DummyRepo();
    const task = Task(id: '1', title: 'A');
    await repo.addTask(task);
    final tasks = await repo.getTasks();
    expect(tasks.first.title, 'A');
  });
}
