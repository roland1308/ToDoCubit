part of 'todo_cubit.dart';

abstract class ToDoState extends Equatable{
  const ToDoState();
}

class ToDosLoading extends ToDoState {
  const ToDosLoading();

  @override
  List<Object?> get props => [];
}

class ToDosEmpty extends ToDoState {
  const ToDosEmpty();

  @override
  List<Object?> get props => [];
}

class ToDosLoaded extends ToDoState {
  final List<ToDo> toDos;

  const ToDosLoaded(this.toDos);

  @override
  List<Object?> get props => [toDos];
}

class ToDosError extends ToDoState {
  final String message;

  const ToDosError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class ToDosEditing extends ToDoState {
  final List<ToDo> toDos;
  final int editedId;

  const ToDosEditing(this.toDos, this.editedId);

  @override
  List<Object?> get props => [toDos, editedId];
}

