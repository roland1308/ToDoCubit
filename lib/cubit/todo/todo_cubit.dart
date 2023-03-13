import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      emit(const ToDosError("Couldn't fetch weather. Is the device online?"));
    }
  }
}
