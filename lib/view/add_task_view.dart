import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/task_model.dart';
import '../pod/task_pod.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  final TaskModel? task;

  AddTaskScreen({this.task});
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;
  int _priority = 1;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void _pickDueDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  _addTask(WidgetRef ref) async {
    if (_formKey.currentState!.validate() && _dueDate != null) {
      final newTask = TaskModel(
        uid: auth.currentUser!.uid,
        id: DateTime.now().toIso8601String(),
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _dueDate!,
        isComplete: 0,
        priority: _priority,
      );
      await ref.read(taskProvider.notifier).addTask(newTask).then((val) {
        Navigator.pop(context);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _dueDate = widget.task!.dueDate;
      _priority = widget.task!.priority!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Text(_dueDate == null
                      ? 'No due date chosen!'
                      : ' ${(_dueDate!.toLocal()).toString().split(' ')[0]}'),
                  Spacer(),
                  ElevatedButton(
                    onPressed: _pickDueDate,
                    child: Text('Pick Due Date'),
                  ),
                ],
              ),
              DropdownButtonFormField<int>(
                value: _priority,
                decoration: InputDecoration(labelText: 'Priority'),
                items: [1, 2, 3, 4, 5]
                    .map((int value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              Consumer(
                  child: Text('Add Task'),
                  builder: (context, ref, child) {
                    return ElevatedButton(
                      onPressed: () => _addTask(ref),
                      child: child,
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
