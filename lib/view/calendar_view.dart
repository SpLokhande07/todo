import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../pod/task_pod.dart';
import '../widgets/task_tile.dart';
import 'add_task_view.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final taskList = ref.watch(taskProvider);
    final tasksForSelectedDay = taskList
        .where((task) => isSameDay(task.dueDate, _selectedDay))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: <Widget>[
          TableCalendar(
            focusedDay: _selectedDay,
            firstDay: DateTime.now(),
            lastDay: DateTime(DateTime.now().year + 1, DateTime.now().month, 1),
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasksForSelectedDay.length,
              itemBuilder: (context, index) {
                final task = tasksForSelectedDay[index];
                return TaskTile(
                  task: task,
                  deleteTask: () async {
                    await ref.read(taskProvider.notifier).deleteTask(task.id);
                  },
                  markTaskStatusChange: () async {
                    await ref
                        .read(taskProvider.notifier)
                        .markTaskComplete(task.id);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
