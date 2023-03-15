import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:to_to_cubit/pages/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_to_cubit/repository/todos_repository.dart';
import 'package:to_to_cubit/sharedpreferences/shared_preferences_manager.dart';

import 'cubit/theme/theme_cubit.dart';
import 'cubit/todo/todo_cubit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String themeMode = await SharedPreferencesManager().getThemeMode();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    BlocProvider(
      create: (context) => ThemeCubit()..setInitialTheme(themeMode),
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
        title: 'To Do - With Cubit',
        theme: state is ThemeDark
            ? ThemeData(
          buttonTheme: const ButtonThemeData(
            buttonColor: Colors.deepPurple,
            textTheme: ButtonTextTheme
                .primary,
          ),
          colorScheme: const ColorScheme.dark().copyWith(
            secondary: Colors.purpleAccent,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: Colors.blueGrey,
        )
            : ThemeData(),
        home: BlocProvider(
            create: (context) => ToDoCubit(ToDosRepository())..getToDos(),
            child: HomePage()),
      ),
    );
  }
}
