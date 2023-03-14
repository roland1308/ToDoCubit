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
      emit(const ToDosError("Couldn't fetch data. Is the device online?"));
    }
  }

  Future<void> addTodo(String comment) async {
    if (state is ToDosEmpty) {
      emit(const ToDosLoaded([]));
    }
    final currentState = state;
    if (currentState is ToDosLoaded) {
      final todo = <String, dynamic>{
        "comment": comment,
        "toDoId": DateTime.now().millisecondsSinceEpoch,
      };
      try {
        final List<ToDo> stateToDos = List.from(currentState.toDos);
        stateToDos.add(ToDo.fromJson(todo));
        emit(ToDosLoaded(stateToDos));
      } catch (e) {
        emit(ToDosError(e.toString()));
      }
    }
  }

  void removeTodo(ToDo toDo) {
    final currentState = state;
    if (currentState is ToDosLoaded) {
      try {
        final List<ToDo> stateToDos = List.from(currentState.toDos);
        stateToDos.remove(toDo);
        if (stateToDos.isNotEmpty) {
          emit(ToDosLoaded(stateToDos));
        } else {
          emit(const ToDosEmpty());
        }
      } catch (e) {
        emit(ToDosError(e.toString()));
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
      currentState
          .toDos[currentState.toDos
          .indexWhere((element) => element.toDoId == toDoId)]
          .comment = newComment;
      emit(ToDosLoaded(currentState.toDos));
    }
  }

}
