# 🧩 Clean Code Flutter Task Tracker Kata (TDD + Cubit)

> A **Clean Architecture + TDD practice kata** in Flutter.  
> Each step is a Red → Green → Refactor loop (~15–20 min).  
> Focus: Cubit state management, clean separation of layers, and small daily cycles.

---

## 🧱 Project Structure

```
lib/
├── core/exceptions.dart
├── domain/
│   └── entities/task.dart
├── data/
│   └── repositories/in_memory_task_repository.dart
├── presentation/
│   ├── cubit/task_cubit.dart
│   └── views/task_screen.dart
└── main.dart
test/
├── domain/task_test.dart
├── data/in_memory_repo_test.dart
├── presentation/task_cubit_test.dart
└── presentation/task_screen_test.dart
```

---

## ⚙️ Setup

1. Ensure Flutter SDK ≥ 3.0.0
2. Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.0.3
  mocktail: ^0.3.0
```
3. Run:
```bash
flutter pub get
```

---

# 🧪 Cycle 1 — Domain Entity: Task

### 🎯 Goal
Immutable `Task` entity that can toggle done/undone.

### 🔴 Test (`test/domain/task_test.dart`)
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_task_kata/domain/entities/task.dart';

void main() {
  test('Task toggles immutably', () {
    final t = Task(title: 'Learn TDD');
    expect(t.title, 'Learn TDD');
    expect(t.isDone, false);

    final toggled = t.toggle();
    expect(t.isDone, false);
    expect(toggled.isDone, true);
  });
}
```

### 🟢 Code (`lib/domain/entities/task.dart`)
```dart
class Task {
  final String title;
  final bool isDone;

  const Task({required this.title, this.isDone = false});

  Task toggle() => Task(title: title, isDone: !isDone);
}
```

---

# 🧪 Cycle 2 — Data Layer: InMemory Repository

### 🎯 Goal
Add and toggle tasks using an in-memory list.

### 🔴 Test (`test/data/in_memory_repo_test.dart`)
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_task_kata/data/repositories/in_memory_task_repository.dart';

void main() {
  test('in-memory repo add and toggle', () {
    final repo = InMemoryTaskRepository();
    expect(repo.getTasks().length, 0);

    repo.addTask('A');
    expect(repo.getTasks().length, 1);
    expect(repo.getTasks().first.title, 'A');

    repo.toggleTask('A');
    expect(repo.getTasks().first.isDone, true);
  });
}
```

### 🟢 Code (`lib/data/repositories/in_memory_task_repository.dart`)
```dart
import '../../domain/entities/task.dart';

class InMemoryTaskRepository {
  final List<Task> _tasks = [];

  List<Task> getTasks() => List.unmodifiable(_tasks);

  void addTask(String title) {
    _tasks.add(Task(title: title));
  }

  void toggleTask(String title) {
    final idx = _tasks.indexWhere((t) => t.title == title);
    if (idx != -1) _tasks[idx] = _tasks[idx].toggle();
  }
}
```

---

# 🧪 Cycle 3 — Presentation Logic: TaskCubit

### 🎯 Goal
Cubit wraps repository and emits updated task list.

### 🔴 Test (`test/presentation/task_cubit_test.dart`)
```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_task_kata/presentation/cubit/task_cubit.dart';
import 'package:flutter_task_kata/data/repositories/in_memory_task_repository.dart';
import 'package:flutter_task_kata/domain/entities/task.dart';

void main() {
  group('TaskCubit', () {
    blocTest<TaskCubit, List<Task>>(
      'emits state with one task after addTask',
      build: () => TaskCubit(InMemoryTaskRepository()),
      act: (cubit) => cubit.addTask('Test'),
      expect: () => [isA<List<Task>>()],
    );

    blocTest<TaskCubit, List<Task>>(
      'toggles a task',
      build: () => TaskCubit(InMemoryTaskRepository())..addTask('X'),
      act: (cubit) => cubit.toggleTask('X'),
      verify: (cubit) => expect(cubit.state.first.isDone, true),
    );
  });
}
```

### 🟢 Code (`lib/presentation/cubit/task_cubit.dart`)
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../../data/repositories/in_memory_task_repository.dart';

class TaskCubit extends Cubit<List<Task>> {
  final InMemoryTaskRepository repository;

  TaskCubit(this.repository) : super(repository.getTasks());

  void addTask(String title) {
    repository.addTask(title);
    emit(repository.getTasks());
  }

  void toggleTask(String title) {
    repository.toggleTask(title);
    emit(repository.getTasks());
  }
}
```

---

# 🧪 Cycle 4 — UI: TaskScreen

### 🎯 Goal
Minimal UI to display and toggle tasks.

### 🔴 Test (`test/presentation/task_screen_test.dart`)
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_kata/presentation/cubit/task_cubit.dart';
import 'package:flutter_task_kata/presentation/views/task_screen.dart';
import 'package:flutter_task_kata/data/repositories/in_memory_task_repository.dart';

void main() {
  testWidgets('adds and toggles tasks from UI', (tester) async {
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => TaskCubit(InMemoryTaskRepository()),
        child: const MaterialApp(home: TaskScreen()),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Learn TDD');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Learn TDD'), findsOneWidget);

    await tester.tap(find.text('Learn TDD'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });
}
```

### 🟢 Code (`lib/presentation/views/task_screen.dart`)
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/task_cubit.dart';
import '../../domain/entities/task.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});
  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final controller = TextEditingController();

  void _addTask() {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    context.read<TaskCubit>().addTask(text);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clean Task Tracker')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: _addTask, child: const Text('Add')),
          ]),
        ),
        Expanded(
          child: BlocBuilder<TaskCubit, List<Task>>(
            builder: (context, tasks) {
              if (tasks.isEmpty) return const Center(child: Text('No tasks yet.'));
              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, i) {
                  final task = tasks[i];
                  return ListTile(
                    leading: Icon(
                      task.isDone ? Icons.check_circle : Icons.circle_outlined,
                      color: task.isDone ? Colors.green : Colors.grey,
                    ),
                    title: Text(task.title,
                        style: TextStyle(
                            decoration: task.isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none)),
                    onTap: () => context.read<TaskCubit>().toggleTask(task.title),
                  );
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}
```

---

# 🧩 Cycle 5 — Integration & Main Entry

### 🟢 Code (`lib/main.dart`)
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/in_memory_task_repository.dart';
import 'presentation/cubit/task_cubit.dart';
import 'presentation/views/task_screen.dart';

void main() {
  final repo = InMemoryTaskRepository();
  runApp(
    BlocProvider(
      create: (_) => TaskCubit(repo),
      child: const MaterialApp(home: TaskScreen()),
    ),
  );
}
```

Run the app:
```bash
flutter run
```

---

## 🧠 Daily Kata Rhythm

| Time | Step | Example |
|------|------|----------|
| 0–2 min | Write failing test | Red |
| 2–8 min | Implement minimal code | Green |
| 8–12 min | Refactor & run again | Clean |
| 12–15 min | Review & commit | Done |

---

## ✅ Clean Code Checklist

- One responsibility per class  
- Clear naming (`addTask()`, not `doStuff()`)  
- Short methods (<10 lines)  
- Immutable domain models  
- Stateless widgets where possible  
- No logic inside UI layer  

---

## 🧠 Extra Practice Variations

- Add delete functionality (TDD it)
- Add async save (simulate network delay)
- Refactor repository to depend on abstract `TaskRepository`
- Write a mock repo test using `mocktail`

---

Keep practicing daily. Small, consistent TDD loops = mastery. 🚀
