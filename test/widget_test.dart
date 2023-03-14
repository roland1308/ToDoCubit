import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_to_cubit/cubit/theme/theme_cubit.dart';
import 'package:to_to_cubit/cubit/todo/todo_cubit.dart';
import 'package:to_to_cubit/pages/home_page.dart';
import 'package:to_to_cubit/repository/todos_repository.dart';

void main() {

  Widget createWidgetUnderTest() {
    return BlocProvider(
      create: (context) => ThemeCubit()..setInitialTheme("light"),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) => MaterialApp(
          title: 'List Page',
          home: BlocProvider(
              create: (context) => ToDoCubit(FakeToDosRepository())..getToDos(),
              child: HomePage()),
        ),
      ),
    );
  }

  testWidgets(
    "loader, one To Do and Add Button showed",
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byKey(const Key("loader")), findsOneWidget);
      await tester.pump(const Duration(seconds: 7));
      expect(find.byKey(const Key("ToDoWidget")), findsOneWidget);
      expect(find.byKey(const Key("addButton")), findsOneWidget);
    },
  );
}
