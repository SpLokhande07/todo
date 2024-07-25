import 'package:equatable/equatable.dart';

class TaskModel extends Equatable {
  String id;
  String uid; // Add this field
  String title;
  String description;
  DateTime? dueDate;
  bool isComplete;

  TaskModel({
    required this.id,
    required this.uid, // Initialize this field
    required this.title,
    required this.description,
    this.dueDate,
    required this.isComplete,
  });

  TaskModel copyWith({
    String? id,
    String? uid,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isComplete,
  }) {
    return TaskModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  factory TaskModel.fromMap(Map<String, dynamic> json) => TaskModel(
        id: json['id'] ?? "",
        uid: json['uid'] ?? "",
        title: json['title'] ?? "",
        description: json['description'] ?? "",
        dueDate: DateTime.parse(json['dueDate']),
        isComplete: json['isComplete'] == 1,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'uid': uid,
        'title': title,
        'description': description,
        'dueDate': dueDate?.toIso8601String(),
        'isComplete': isComplete,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [id, uid, title, description, dueDate, isComplete];
}
