import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/models/user.dart';
import 'package:todo_list/service/auth_service.dart';

/// Creates a [TodoList].
///
/// We are using [StateNotifierProvider] here as a `List<Todo>` is a complex
/// object, with advanced business logic like how to edit a todo.
final todoListProvider = StateNotifierProvider<TodoList, List<Todo>>((ref) {
  return TodoList();
});

/// Enum with possible filters of the `todo` list.
enum TodoListFilter {
  all,
  active,
  completed,
}

/// The currently active filter.
///
/// Notice we are using [StateProvider] here as there.
/// It's just a single value so there is no logic to be implemented.
final todoListFilter = StateProvider((_) => TodoListFilter.all);

/// The number of uncompleted todos
///
/// We are using [Provider].
/// There are a number of advantages, mainly this value being cached,
/// even if multiple widgets are reading this value - it will only be computed once.
///
/// This will also optimise unneeded rebuilds if the todo-list changes, but the
/// number of uncompleted todos doesn't (such as when editing a todo).
final uncompletedTodosCount = Provider<int>((ref) {
  return ref.watch(todoListProvider).where((todo) => !todo.completed).length;
});

/// The list of todos after applying a [todoListFilter].
final filteredTodos = Provider<List<Todo>>((ref) {
  final filter = ref.watch(todoListFilter);
  final todos = ref.watch(todoListProvider);

  switch (filter) {
    case TodoListFilter.completed:
      return todos.where((todo) => todo.completed).toList();
    case TodoListFilter.active:
      return todos.where((todo) => !todo.completed).toList();
    case TodoListFilter.all:
      return todos;
  }
});

final authServiceProvider = Provider((ref) => AuthService());
final authenticatedUserProvider = StreamProvider<CustomUser?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.user;
});


