import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_noorisys/helper/database_helper.dart';
import 'package:todo_noorisys/widgets/task_tile.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
          bool showDate = task.dueDate!.compareTo(DateTime.now()) >= 0 ||
              task.dueDate!.isAtSameMomentAs(DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day));
          print("##############################");
          print("${task.dueDate!}.compareTo(${DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          )}): ${task.dueDate!.compareTo(DateTime.now())}");
          print(
              "${task.dueDate!.isAtSameMomentAs(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))}");
          print("##############################");

          return showDate
              ? TaskTile(
                  task: task,
                  deleteTask: () async {
                    await ref.read(taskProvider.notifier).deleteTask(task.id);
                  },
                  markTaskStatusChange: () async {
                    await ref
                        .read(taskProvider.notifier)
                        .markTaskComplete(task.id);
                  },
                )
              : const SizedBox();
        },
      ),
      floatingActionButton: fab(
        icon: Icons.add,
        onTap: () {
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

  Widget fab({required IconData icon, required Function() onTap}) {
    return FloatingActionButton(
      child: Icon(icon),
      onPressed: onTap,
    );
  }
}
