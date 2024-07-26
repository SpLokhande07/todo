import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_noorisys/model/task_model.dart';

import '../view/add_task_view.dart';

class TaskTile extends StatefulWidget {
  final TaskModel task;
  final Function markTaskStatusChange;
  final Function deleteTask;

  const TaskTile(
      {super.key,
      required this.task,
      required this.deleteTask,
      required this.markTaskStatusChange});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
      title: Text(widget.task.title),
      subtitle: Text(widget.task.description),
      trailing: SizedBox(
        width: 0.3.sw,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Checkbox(
              value: widget.task.isComplete == 1,
              onChanged: (val) => widget.markTaskStatusChange,
            ),
            InkWell(
              onTap: () => widget.deleteTask(),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddTaskScreen(),
          ),
        );
      },
    );
  }
}
