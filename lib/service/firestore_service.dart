import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_noorisys/model/task_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> updateUserProfile(
      String uid, String name, String dob, String profileImageUrl) async {
    await _db.collection('users').doc(uid).set({
      'name': name,
      'dob': dob,
      'profileImageUrl': profileImageUrl,
    });
  }

  Future<DocumentSnapshot> getUserProfile(String uid) async {
    return await _db.collection('users').doc(uid).get();
  }

  Future<void> addTask(TaskModel task) async {
    String id = _db.collection('tasks').doc().id;
    task.id = id;
    await _db.collection('tasks').doc(id).set(task.toMap());
  }

  Future<void> updateTask(TaskModel task) async {
    await _db.collection('tasks').doc(task.id.toString()).update(task.toMap());
  }

  Future<void> deleteTask(String id) async {
    await _db.collection('tasks').doc(id).delete();
  }

  Future<List<TaskModel>> getTasks(String uid) async {
    final querySnapshot =
        await _db.collection('tasks').where('uid', isEqualTo: uid).get();

    return querySnapshot.docs
        .map((doc) => TaskModel.fromMap(doc.data()))
        .toList();
  }
}
