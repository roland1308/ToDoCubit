import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/todo_model.dart';

class ToDosRepository {
  Future<List<ToDo>> fetchToDos() async {
    final db = FirebaseFirestore.instance;
    List<ToDo> toDos = [];
    try {
      await db.collection("todos").get().then((event) {
        toDos = List<ToDo>.from(event.docs.map((x) => ToDo.fromJson(x.data())));
      });
      toDos.sort((td1, td2) {
        return td1.toDoId.compareTo(td2.toDoId);
      });
      return toDos;
    } on Exception {
      throw NetworkException();
    }
  }

  Future<bool> addTodo(Map<String, dynamic> newToDo) async {
    final db = FirebaseFirestore.instance;
    try {
      await db.collection("todos").add(newToDo);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeTodo(ToDo toDo) async {
    final db = FirebaseFirestore.instance;
    try {
      await db
          .collection("todos")
          .where("toDoId", isEqualTo: toDo.toDoId)
          .get()
          .then((snapshot) {
        snapshot.docs[0].reference.delete();
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateTodo(int toDoId, String newComment) async {
    final db = FirebaseFirestore.instance;
    try {
      await db
          .collection("todos")
          .where("toDoId", isEqualTo: toDoId)
          .get()
          .then((snapshot) {
        snapshot.docs[0].reference
            .update({"toDoId": toDoId, "comment": newComment});
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}

class FakeToDosRepository implements ToDosRepository {
  @override
  Future<List<ToDo>> fetchToDos() {
    // Simulate network delay
    return Future.delayed(
      const Duration(seconds: 5),
      () {
        /// Simulate some network exception
        final random = Random();
        if (random.nextBool()) {
          throw NetworkException();
        }

        /// Return "fetched" ToDos
        return <ToDo>[ToDo(toDoId: 1, comment: "comment")];
      },
    );
  }

  @override
  Future<bool> addTodo(Map<String, dynamic> newToDo) {
    // TODO: implement addTodo
    throw UnimplementedError();
  }

  @override
  Future<bool> removeTodo(ToDo toDo) {
    // TODO: implement removeTodo
    throw UnimplementedError();
  }

  @override
  Future<bool> updateTodo(int toDoId, String newComment) {
    // TODO: implement updateTodo
    throw UnimplementedError();
  }

}

class NetworkException implements Exception {}
