// ignore_for_file: use_build_context_synchronously

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/authentication/authenticate.dart';
import 'package:todo_list/service/auth_service.dart';
import 'package:todo_list/service/database_service.dart';
import 'package:todo_list/service/firebase_options.dart';

import 'providers.dart';
import 'models/todo.dart';

/// Keys for components for testing
final bottomNavigationBarKey = UniqueKey();
final addTodoKey = UniqueKey();

// coverage:ignore-start
Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that Flutter bindings have been initialized

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: App()));
}
// coverage:ignore-end

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Authentication(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends HookConsumerWidget {
  final String uid;
  Home({super.key, required this.uid});

  final _authService = AuthService();
  late final _databaseService = DatabaseService(uid: uid);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(filteredTodos);
    final newTodoController = useTextEditingController();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'My TODO Planner',
                style: TextStyle(
                  color: Color.fromARGB(115, 6, 4, 28),
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: 40.0,
                height: 40.0,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(224, 243, 248, 251),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                child: PopupMenuButton<Widget>(
                  iconSize: 22.0,
                  icon: const Icon(Icons.person),
                  popUpAnimationStyle: AnimationStyle(
                      duration: const Duration(milliseconds: 400)),
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<Widget>>[
                    PopupMenuItem<Widget>(
                      child: ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text('Logout'),
                        onTap: () async {
                          Navigator.pop(context);
                          await _authService.signOut();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 137, 177, 246),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          children: [
            TextField(
              key: addTodoKey,
              controller: newTodoController,
              decoration: const InputDecoration(
                labelText: 'Type a new TODO',
              ),
              onSubmitted: (value) async {
                Todo todo = ref.read(todoListProvider.notifier).add(value);
                await _databaseService.addTodo(todo);
                newTodoController.clear();
              },
            ),
            const SizedBox(height: 42),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                '${ref.watch(uncompletedTodosCount)} TODOs left',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            if (todos.isNotEmpty) const Divider(height: 0),
            for (var i = 0; i < todos.length; i++) ...[
              if (i > 0) const Divider(height: 0),
              ProviderScope(
                overrides: [
                  _currentTodo.overrideWithValue(todos[i]),
                ],
                child: const TodoItem(),
              ),
            ],
          ],
        ),
        bottomNavigationBar: const Menu(),
        floatingActionButton: FloatingActionButton(
          tooltip: "Add a TODO",
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  actions: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 137, 177, 246),
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: TextButton(
                        onPressed: () async {
                          Todo todo = ref
                              .read(todoListProvider.notifier)
                              .add(newTodoController.text);
                          await _databaseService.addTodo(todo);
                          newTodoController.clear();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Add',
                          style:
                              TextStyle(color: Color.fromARGB(181, 6, 4, 28)),
                        ),
                      ),
                    )
                  ],
                  backgroundColor: const Color.fromARGB(248, 232, 237, 238),
                  title: const Center(
                      child: Text(
                    'Add a new TODO',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  content: TextField(
                    key: addTodoKey,
                    controller: newTodoController,
                    decoration: const InputDecoration(
                      labelText: 'Type a new TODO',
                    ),
                  ),
                );
              },
            );
          },
          backgroundColor: const Color.fromARGB(255, 138, 177, 245),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

/// Bottom menu widget
class Menu extends HookConsumerWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(todoListFilter);

    int currentIndex() {
      switch (filter) {
        case TodoListFilter.completed:
          return 2;
        case TodoListFilter.active:
          return 1;
        case TodoListFilter.all:
          return 0;
      }
    }

    return BottomNavigationBar(
      key: bottomNavigationBarKey,
      elevation: 0.0,
      onTap: (value) {
        if (value == 0) {
          ref.read(todoListFilter.notifier).state = TodoListFilter.all;
        }
        if (value == 1) {
          ref.read(todoListFilter.notifier).state = TodoListFilter.active;
        }
        if (value == 2) {
          ref.read(todoListFilter.notifier).state = TodoListFilter.completed;
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.list), label: 'All', tooltip: 'All'),
        BottomNavigationBarItem(
          icon: Icon(Icons.circle),
          label: 'Active',
          tooltip: 'Active',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.done),
          label: 'Completed',
          tooltip: 'Completed',
        ),
      ],
      currentIndex: currentIndex(),
      selectedItemColor: Colors.amber[800],
    );
  }
}

/// A provider which exposes the [Todo] displayed by a [TodoItem].
///
/// By retrieving the [Todo] through a provider instead of through its
/// constructor, this allows [TodoItem] to be instantiated using the `const` keyword.
///
/// This encapsulation ensures that when adding/removing/editing todos,
/// only what the impacted widgets rebuilds, instead of the entire list of items.
final _currentTodo = Provider<Todo>((ref) => throw UnimplementedError());

class TodoItem extends HookConsumerWidget {
  const TodoItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the authenticated user stream
    final authenticatedUserAsync = ref.watch(authenticatedUserProvider);

    // Extract the authenticated user from AsyncValue
    final authenticatedUser = authenticatedUserAsync.when(
      data: (user) => user, // Use the user data if available
      loading: () => null, // Return null while loading
      error: (_, __) => null, // Handle error case
    );

    late String uid = '';
    // Check if authenticatedUser is null
    if (authenticatedUser != null) {
      uid = authenticatedUser.uid;
    }

    final databaseService = DatabaseService(uid: uid);

    final todo = ref.watch(_currentTodo);
    final itemFocusNode = useFocusNode();
    final itemIsFocused = useIsFocused(itemFocusNode);

    final textEditingController = useTextEditingController();
    final textFieldFocusNode = useFocusNode();

    return Material(
      color: Colors.white,
      elevation: 6,
      child: Focus(
        focusNode: itemFocusNode,
        onFocusChange: (focused) async {
          if (focused) {
            textEditingController.text = todo.description;
          } else {
            // Commit changes only when the textfield is unfocused, for performance
            Todo todoEdited = ref
                .read(todoListProvider.notifier)
                .edit(id: todo.id, description: textEditingController.text);
            await databaseService.updateTodo(todoEdited);
          }
        },
        child: ListTile(
          onTap: () {
            itemFocusNode.requestFocus();
            textFieldFocusNode.requestFocus();
          },
          leading: Checkbox(
              value: todo.completed,
              onChanged: (value) async {
                Todo todoEdited =
                    ref.read(todoListProvider.notifier).toggle(todo.id);
                await databaseService.updateTodo(todoEdited);
              }),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await databaseService.deleteTodo(todo.id);
              ref.read(todoListProvider.notifier).remove(todo.id);
            },
          ),
          title: itemIsFocused
              ? TextField(
                  autofocus: true,
                  focusNode: textFieldFocusNode,
                  controller: textEditingController,
                )
              : Text(todo.description),
        ),
      ),
    );
  }
}

bool useIsFocused(FocusNode node) {
  final isFocused = useState(node.hasFocus);

  useEffect(
    () {
      void listener() {
        isFocused.value = node.hasFocus;
      }

      node.addListener(listener);
      return () => node.removeListener(listener);
    },
    [node],
  );

  return isFocused.value;
}
