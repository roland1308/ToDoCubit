import 'package:flutter/material.dart';
import 'package:to_to_cubit/pages/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_to_cubit/repository/todos_repository.dart';

import 'cubit/theme/theme_cubit.dart';
import 'cubit/todo/todo_cubit.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => ThemeCubit()..setInitialTheme("light"),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'To Do YourStep',
        theme: state is ThemeDark
            ? ThemeData(
          buttonTheme: const ButtonThemeData(
            buttonColor: Colors.deepPurple, //  <-- dark color
            textTheme: ButtonTextTheme
                .primary, //  <-- this auto selects the right color
          ),
          colorScheme: const ColorScheme.dark().copyWith(
            secondary: Colors.purpleAccent,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: Colors.blueGrey,
        )
            : ThemeData(),
        home: BlocProvider(
            create: (context) => ToDoCubit(FakeToDosRepository())..getToDos(),
            child: HomePage()),
      ),
    );
  }
}
