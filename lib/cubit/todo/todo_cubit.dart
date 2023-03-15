import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/todo_model.dart';
import '../../repository/todos_repository.dart';

part 'todo_state.dart';

class ToDoCubit extends Cubit<ToDoState> {
  final ToDosRepository _toDosRepository;

  ToDoCubit(this._toDosRepository) : super(const ToDosLoading());

  Future<void> getToDos() async {
    emit(const ToDosLoading());
    try {
      final toDos = await _toDosRepository.fetchToDos();
      if (toDos.isNotEmpty) {
        emit(ToDosLoaded(toDos));
      } else {
        emit(const ToDosEmpty());
      }
    } on NetworkException {
      emit(const ToDosDBError("Couldn't fetch data. Is the device online?"));
    }
  }

  Future<void> addToDo(String comment) async {
    if (state is ToDosEmpty) {
      emit(const ToDosLoaded([]));
    }
    final currentState = state;
    if (currentState is ToDosLoaded) {
      final toDo = <String, dynamic>{
        "comment": comment,
        "toDoId": DateTime.now().millisecondsSinceEpoch,
      };
      bool addResult = await ToDosRepository().addTodo(toDo);
      if (addResult) {
        final List<ToDo> stateToDos = List.from(currentState.toDos);
        stateToDos.add(ToDo.fromJson(toDo));
        emit(ToDosLoaded(stateToDos));
      } else {
        emit(const ToDosDBError(
            "An error occurred while adding To Do, please retry."));
      }
    }
  }

  Future<void> removeTodo(ToDo toDo) async {
    final currentState = state;
    if (currentState is ToDosLoaded) {
      bool removeResut = await ToDosRepository().removeTodo(toDo);
      if (removeResut) {
        final List<ToDo> stateToDos = List.from(currentState.toDos);
        stateToDos.remove(toDo);
        if (stateToDos.isNotEmpty) {
          emit(ToDosLoaded(stateToDos));
        } else {
          emit(const ToDosEmpty());
        }
      } else {
        emit(const ToDosDBError(
            "An error occurred while removing To Do, please retry."));
      }
    }
  }

  void editToDo(ToDo toDo) {
    final currentState = state;
    if (currentState is ToDosLoaded) {
      emit(ToDosEditing(currentState.toDos, toDo.toDoId));
    }
  }

  void updateTodo(int toDoId, String newComment) async {
    final currentState = state;
    if (currentState is ToDosEditing) {
      bool updateResult =
          await ToDosRepository().updateTodo(toDoId, newComment);
      if (updateResult) {
        currentState
            .toDos[currentState.toDos
                .indexWhere((element) => element.toDoId == toDoId)]
            .comment = newComment;
        emit(ToDosLoaded(currentState.toDos));
      } else {
        emit(const ToDosDBError(
            "An error occurred while updating To Do, please retry."));
      }
    }
  }
}
