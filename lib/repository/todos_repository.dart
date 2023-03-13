import 'dart:math';

import '../models/todo_model.dart';

class ToDosRepository {
  Future<List<ToDo>> fetchToDos() async {
  return [];
  }
}

class FakeToDosRepository implements ToDosRepository {
  @override
  Future<List<ToDo>> fetchToDos() {
    // Simulate network delay
    return Future.delayed(
      const Duration(seconds: 5),
      () {
        final random = Random();

        //Simulate some network exception
        if (random.nextBool()) {
          throw NetworkException();
        }

        // Return "fetched" ToDos
        return <ToDo>[ToDo(toDoId: 1, comment: "comment")];
      },
    );
  }
}

class NetworkException implements Exception {}