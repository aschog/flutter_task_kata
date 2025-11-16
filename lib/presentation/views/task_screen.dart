import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_kata/presentation/cubit/task_cubit.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TaskCubit>();
    final state = cubit.state;

    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: Column(
        children: [
          if (state.tasks.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No tasks yet'),
            ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('task-input'),
                    controller: controller,
                    decoration: const InputDecoration(hintText: 'Enter task'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final text = controller.text.trim();
                    if (text.isNotEmpty) {
                      cubit.addTaskAction(text);
                      controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];

                return ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isDone
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  onTap: () => cubit.toggleTaskAction(task.title),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
