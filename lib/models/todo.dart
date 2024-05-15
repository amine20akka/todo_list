import 'package:flutter/foundation.dart' show immutable;
import 'package:riverpod/riverpod.dart';
import 'package:uuid/uuid.dart';

@immutable
class Todo {
  const Todo({
    required this.description,
    required this.id,
    this.completed = false,
  });

  final String id;
  final String description;
  final bool completed;
}

/// An object that controls a list of [Todo].
/// We are using [`StateNotifier`]
/// as it is recommended for managing state which may change in reaction to user interaction (e.g. adding todo, delete todo, mark it as completed...).
///
/// State is immutable, hence why a copy of state is created
/// on any modification method.
const _uuid = Uuid();

class TodoList extends StateNotifier<List<Todo>> {
  TodoList([List<Todo>? initialTodos]) : super(initialTodos ?? []);

  /// Adds `todo` item to list.
  Todo add(String description) {
    // Since our state is immutable, we are not allowed to do `state.add(todo)`.
    Todo todo = Todo(
      id: _uuid.v4(),
      description: description,
    );
    state = [...state, todo];

    return todo;
  }

  /// Toggles `todo` item between completed or not completed.
  Todo toggle(String id) {
    final newState = [...state];
    final todoToReplaceIndex = state.indexWhere((todo) => todo.id == id);
    final Todo todoEdited = Todo(
      id: newState[todoToReplaceIndex].id,
      completed: !newState[todoToReplaceIndex].completed,
      description: newState[todoToReplaceIndex].description,
    );
    if (todoToReplaceIndex != -1) {
      newState[todoToReplaceIndex] = todoEdited;
    }

    state = newState;

    return todoEdited;
  }

  /// Edits a `todo` item.
  Todo edit({required String id, required String description}) {
    final newState = [...state];
    final todoToReplaceIndex = state.indexWhere((todo) => todo.id == id);

    Todo todoEdited = Todo(
      id: newState[todoToReplaceIndex].id,
      completed: newState[todoToReplaceIndex].completed,
      description: description,
    );

    if (todoToReplaceIndex != -1) {
      newState[todoToReplaceIndex] = todoEdited;
    }

    state = newState;

    return todoEdited;
  }

  /// Removes the `todo` item with the specified ID.
  void remove(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }
}
