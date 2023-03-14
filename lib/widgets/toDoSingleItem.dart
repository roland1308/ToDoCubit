import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/todo/todo_cubit.dart';
import '../models/todo_model.dart';

class TodoSingleItem extends StatefulWidget {
  TodoSingleItem({
    required this.toDo,
  }) : super(key: ObjectKey(toDo));

  final ToDo toDo;

  @override
  State<TodoSingleItem> createState() => _TodoSingleItemState();
}

class _TodoSingleItemState extends State<TodoSingleItem> {
  final TextEditingController _textEditingController =
      TextEditingController(text: "");

  double _opacity = 1;

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = widget.toDo.comment;
    return BlocBuilder<ToDoCubit, ToDoState>(builder: (_, state) {
      if (state is ToDosEditing && state.editedId == widget.toDo.toDoId) {
        return buildEditToDo();
      } else {
        return buildNormalToDo(context);
      }
    });
  }

  Widget buildNormalToDo(BuildContext context) {
    return AnimatedOpacity(
      onEnd: () {
        if (mounted) {
          final toDoCubit = context.read<ToDoCubit>();
          toDoCubit.removeTodo(widget.toDo);
        }
      },
      opacity: _opacity,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      child: ListTile(
        key: Key("ToDoWidget"),
        onTap: () {
          final toDoCubit = context.read<ToDoCubit>();
          toDoCubit.editToDo(widget.toDo);
        },
        leading: CircleAvatar(
          child: Text(widget.toDo.comment[0].toUpperCase()),
        ),
        title: Text(widget.toDo.comment),
        trailing: IconButton(
          onPressed: () => removeSingleItem(),
          icon: const Icon(
            Icons.remove_circle,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget buildEditToDo() {
    return ListTile(
      key: Key("editTile"),
      leading: const CircleAvatar(
        backgroundColor: Colors.red,
        child: Icon(Icons.edit),
      ),
      title: TextField(
        autofocus: true,
        controller: _textEditingController,
        decoration: const InputDecoration(hintText: 'Type your comment'),
      ),
      trailing: IconButton(
        onPressed: () {
          if (_textEditingController.text != "") {
            final todoCubit = context.read<ToDoCubit>();
            todoCubit.updateTodo(
              widget.toDo.toDoId,
              _textEditingController.text,
            );
          }
        },
        icon: const Icon(
          Icons.send_and_archive,
          color: Colors.green,
        ),
      ),
    );
  }

  Future<void> removeSingleItem() async {
    setState(() {
      _opacity = 0;
    });
  }
}
