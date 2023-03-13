import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/theme/theme_cubit.dart';
import '../cubit/todo/todo_cubit.dart';
import '../views/all_todos.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<ToDoCubit, ToDoState>(
        listener: (context, state) {
          if (state is ToDosError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (_, toDoState) {
          return Scaffold(
              appBar: AppBar(
                title: const Text("To Do - Cubit"),
                actions: [
                  BlocBuilder<ThemeCubit, ThemeState>(builder: (_, themeState) {
                    return IconButton(
                        onPressed: () {
                          final themeCubit = context.read<ThemeCubit>();
                          themeCubit.toggleTheme();
                        },
                        icon: Icon(themeState.themeIcon));
                  })
                ],
              ),
              floatingActionButton: toDoState is ToDosLoaded
                  ? FloatingActionButton(
                      onPressed: () => addNewComment(context),
                      tooltip: 'Add Item',
                      child: const Icon(Icons.add))
                  : Container(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              body: correctView(toDoState, context));
        },
      ),
    );
  }

  Future<void> addNewComment(BuildContext context) async {}

  Widget correctView(ToDoState state, BuildContext context) {
    if (state is ToDosLoaded) {
      return AllToDos(
        toDos: state.toDos,
        scrollController: _scrollController,
        context: context,
      );
    } else if (state is ToDosEditing) {
      return AllToDos(
        toDos: state.toDos,
        scrollController: _scrollController,
        context: context,
      );
    } else if (state is ToDosLoading) {
      return buildLoading();
    } else if (state is ToDosEmpty) {
      return buildEmptyList(context);
    } else {
      // (state is ToDosError)
      return buildEmptyList(context);
    }
  }

  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildEmptyList(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Nothing planned yet"),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                addNewComment(context);
              },
              child: const Text("Add now"))
        ],
      ),
    );
  }
}
