import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future createUser(String email) async {
    return await userCollection.doc(uid).set({
      'email': email,
    });
  }

  CustomUser _customUserFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    return CustomUser(
      uid: uid,
      email: data!['email'],
    );
  }

  Stream<CustomUser> get user {
    return userCollection.doc(uid).snapshots().map(_customUserFromSnapshot);
  }

  Future<List<Todo>> getTodos() async {
    try {
      // Query the TodoList collection
      QuerySnapshot querySnapshot =
          await userCollection.doc(uid).collection('todoList').get();

      // Convert the documents into Todo objects
      List<Todo> todos = querySnapshot.docs.map((doc) {
        return Todo(
          id: doc.id,
          description: doc['description'],
          completed: doc['completed'],
        );
      }).toList();

      return todos;
    } catch (e) {
      print('Error fetching todos: $e');
      return [];
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      await userCollection.doc(uid).collection('todoList').doc(todo.id).set({
        'id': todo.id,
        'description': todo.description,
        'completed': todo.completed,
      });
    } catch (e) {
      print('Error adding todo item: $e');
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      await userCollection.doc(uid).collection('todoList').doc(todo.id).update({
        'id': todo.id,
        'description': todo.description,
        'completed': todo.completed,
      });
    } catch (e) {
      print('Error adding todo item: $e');
    }
  }

  Future<void> deleteTodo(String todoId) async {
    try {
      await userCollection.doc(uid).collection('todoList').doc(todoId).delete();
    } catch (e) {
      print('Error deleting todo item: $e');
    }
  }
}
