import 'package:flutter_task_kata/data/repositories/in_memory_task_repository.dart';
import 'package:flutter_task_kata/domain/entities/task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adds, laods, and toggles tasks asynchronously', () async {
    final repo = InMemoryTaskRepository();

    const task = Task(id: '1', title: 'Learn TDD');
    await repo.addTask(task);
    final list1 = await repo.getTasks();

    expect(list1.length, 1);
    expect(list1.first.title, 'Learn TDD');
    expect(list1.first.isDone, false);
  });
}
