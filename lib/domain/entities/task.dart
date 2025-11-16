import 'package:equatable/equatable.dart';

class Task extends Equatable {
  const Task({required this.title, this.isDone = false});
  final String title;
  final bool isDone;

  Task toggle() => Task(title: title, isDone: !isDone);

  @override
  List<Object> get props => [title, isDone];
}
