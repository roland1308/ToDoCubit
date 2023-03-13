import 'package:flutter/material.dart';

import '../models/todo_model.dart';
import '../widgets/toDoSingleItem.dart';

class AllToDos extends StatelessWidget {
  const AllToDos({
    super.key,
    required this.scrollController,
    required this.toDos,
    required this.context,
  });

  final ScrollController scrollController;
  final List<ToDo> toDos;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return ListView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: toDos.map((ToDo toDo) {
          return Card(
            child: TodoSingleItem(
              toDo: toDo,
              onTodoEdited: () {
              },
            ),
          );
        }).toList());
  }
}
