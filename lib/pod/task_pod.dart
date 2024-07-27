import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helper/database_helper.dart';
import '../model/task_model.dart';
import '../service/firestore_service.dart';
import '../service/sync_service.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, List<TaskModel>?>(
    (ref) => TaskNotifier());

class TaskNotifier extends StateNotifier<List<TaskModel>?> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final FirestoreService _firestoreService = FirestoreService();
  final SyncService _syncService = SyncService();

  TaskNotifier() : super([]) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    await _syncService.syncTasks();
    List<TaskModel> list = await _dbHelper.getTasks();
    state = list;
  }

  Future<void> addTask(TaskModel task) async {
    await _firestoreService.addTask(task);
    await _dbHelper.insertTask(task);
    state = [...state!, task];
  }

  Future<void> updateTask(TaskModel task) async {
    await _dbHelper.updateTask(task);
    await _firestoreService.updateTask(task);
    state = [
      for (final t in state!)
        if (t.id == task.id) task else t
    ];
  }

  Future<void> deleteTask(String id) async {
    await _dbHelper.deleteTask(id);
    await _firestoreService.deleteTask(id);
    state = state!.where((task) => task.id != id).toList();
  }

  Future<void> markTaskComplete(String id) async {
    final task = state!.firstWhere((task) => task.id == id);
    task.isComplete = task.isComplete == 0 ? 1 : 0;
    await updateTask(task);
  }

  Future<void> clearTask() async {
    await _dbHelper.clearDatabase();
    await _loadTasks;
  }
}
