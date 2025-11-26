import 'package:flutter_task_kata/domain/entities/task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Task toggles immutably', () {
    const t = Task(id: '1', title: 'TDD');
    expect(t.isDone, false);

    final toggled = t.toggle();
    expect(t.isDone, false);
    expect(toggled.isDone, true);
  });
}
