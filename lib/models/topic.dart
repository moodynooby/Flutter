import 'package:uuid/uuid.dart';

class Topic {
  final String id;
  final String name;
  final bool isCompleted;
  final DateTime? completedAt;

  Topic({
    String? id,
    required this.name,
    this.isCompleted = false,
    this.completedAt,
  }) : id = id ?? const Uuid().v4();

  Topic copyWith({
    String? name,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return Topic(
      id: id,
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      name: json['name'],
      isCompleted: json['isCompleted'],
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }
}