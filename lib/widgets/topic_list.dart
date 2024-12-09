import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/subject.dart';
import '../providers/subject_provider.dart';

class TopicList extends StatelessWidget {
  final Subject subject;

  const TopicList({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    if (subject.topics.isEmpty) {
      return const Text(
        'No topics added yet',
        style: TextStyle(fontStyle: FontStyle.italic),
      );
    }

    return Column(
      children: subject.topics.map((topic) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Checkbox(
            value: topic.isCompleted,
            onChanged: (bool? value) {
              Provider.of<SubjectProvider>(context, listen: false)
                  .toggleTopicCompletion(subject.id, topic.id);
            },
          ),
          title: Text(
            topic.name,
            style: TextStyle(
              decoration: topic.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              Provider.of<SubjectProvider>(context, listen: false)
                  .deleteTopic(subject.id, topic.id);
            },
          ),
        );
      }).toList(),
    );
  }
}