import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helper/connection_helper.dart';
import '../pod/task_pod.dart';
import 'add_task_view.dart';
import 'calendar_view.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  TaskListScreen();

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  late ConnectionHelper _connectionHelper;

  @override
  void initState() {
    super.initState();
    _connectionHelper = ConnectionHelper(context)..initialize();
  }

  @override
  void dispose() {
    _connectionHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskList = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: taskList.length,
        itemBuilder: (context, index) {
          final task = taskList[index];
          bool showDate = task.dueDate!.compareTo(DateTime.now()) <= 0;
          return showDate
              ? ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: Checkbox(
                    value: task.isComplete,
                    onChanged: (value) {
                      ref.read(taskProvider.notifier).markTaskComplete(task.id);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddTaskScreen(),
                      ),
                    );
                  },
                )
              : const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(),
            ),
          );
        },
      ),
    );
  }
}
