import 'package:uuid/uuid.dart';
import 'topic.dart';

class Subject {
  final String id;
  final String name;
  final List<Topic> topics;
  final DateTime createdAt;

  Subject({
    String? id,
    required this.name,
    List<Topic>? topics,
  })  : id = id ?? const Uuid().v4(),
        topics = topics ?? [],
        createdAt = DateTime.now();

  double get completionPercentage {
    if (topics.isEmpty) return 0;
    int completedTopics = topics.where((topic) => topic.isCompleted).length;
    return (completedTopics / topics.length) * 100;
  }

  Subject copyWith({
    String? name,
    List<Topic>? topics,
  }) {
    return Subject(
      id: id,
      name: name ?? this.name,
      topics: topics ?? this.topics,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'topics': topics.map((topic) => topic.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      name: json['name'],
      topics: (json['topics'] as List)
          .map((topicJson) => Topic.fromJson(topicJson))
          .toList(),
    );
  }
}