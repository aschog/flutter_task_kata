import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_kata/presentation/cubit/task_cubit.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: BlocConsumer<TaskCubit, TaskState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        key: const Key('task-input'),
                        controller: _controller,
                        decoration: const InputDecoration(hintText: 'Enter task'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        final text = _controller.text.trim();
                        if (text.isNotEmpty) {
                          context.read<TaskCubit>().addTaskAction(text);
                          _controller.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
              if (state.isLoading && state.tasks.isEmpty)
                const Expanded(
                    child: Center(child: CircularProgressIndicator())),
              if (state.tasks.isEmpty && !state.isLoading)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No tasks yet'),
                ),
              if (state.tasks.isNotEmpty)
                Expanded(
                  child: Stack(
                    children: [
                      ListView.builder(
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
                            onTap: () => context
                                .read<TaskCubit>()
                                .toggleTaskAction(task.id),
                          );
                        },
                      ),
                      if (state.isLoading)
                        const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}