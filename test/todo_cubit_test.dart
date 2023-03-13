import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_to_cubit/cubit/theme/theme_cubit.dart';
import 'package:to_to_cubit/cubit/todo/todo_cubit.dart';
import 'package:to_to_cubit/models/todo_model.dart';
import 'package:to_to_cubit/repository/todos_repository.dart';

void main() {
  late ToDoCubit toDoCubit;
  late ThemeCubit themeCubit;

  setUp(() {
    toDoCubit = ToDoCubit(FakeToDosRepository());
    themeCubit = ThemeCubit();
  });

  group('getToDos()', () {
    List<ToDo> tToDos = [ToDo(toDoId: 1, comment: "comment")];

    blocTest<ToDoCubit, ToDoState>(
      'emits [ToDosLoading, ToDosLoaded] when '
      'getToDos() is called successfully.',
      build: () => toDoCubit,
      skip: 0,
      act: (cubit) => cubit.getToDos(),
      expect: () => [
        const ToDosLoading(),
        ToDosLoaded(tToDos)
      ],
      // verify: (_) async {
      //   verify(() => FakeToDosRepository().fetchToDos()).called(1);
      // },
    );
  });

  group('toggleTheme()', () {

    blocTest<ThemeCubit, ThemeState>(
      'emits [ThemeDark] (as initial theme is "Light") when '
      'toggleTheme() is called successfully.',
      build: () => themeCubit,
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [
        const ThemeDark(Icons.light_mode)
      ],
    );
  });

  group('setInitialTheme()', () {

    blocTest<ThemeCubit, ThemeState>(
      'emits [ThemeLight] when '
      'setInitialTheme("light") is called successfully.',
      build: () => themeCubit,
      act: (cubit) => cubit.setInitialTheme("light"),
      expect: () => [
        const ThemeLight(Icons.dark_mode)
      ],
    );

    blocTest<ThemeCubit, ThemeState>(
      'emits [ThemeDark] when '
      'setInitialTheme("dark") is called successfully.',
      build: () => themeCubit,
      act: (cubit) => cubit.setInitialTheme("dark"),
      expect: () => [
        const ThemeDark(Icons.light_mode)
      ],
    );
  });
}
