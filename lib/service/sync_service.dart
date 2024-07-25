import 'package:firebase_auth/firebase_auth.dart';

import '../helper/database_helper.dart';
import '../model/task_model.dart';
import 'firestore_service.dart';

class SyncService {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final FirestoreService _firestoreService = FirestoreService();

  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> syncTasks() async {
    // Get local tasks
    List<TaskModel> localTasks = await _dbHelper.getTasks();

    // Get remote tasks
    List<TaskModel> remoteTasks =
        await _firestoreService.getTasks(auth.currentUser!.uid);

    // Sync local tasks to remote
    for (TaskModel task in localTasks) {
      // if (!(remoteTasks.contains(task))) {
      await _firestoreService.addTask(task);
      // }
    }

    // Sync remote tasks to local
    for (TaskModel task in remoteTasks) {
      // if (!(localTasks.contains(task))) {
      await _dbHelper.insertTask(task);
      // }
    }
  }
}
