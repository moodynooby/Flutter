import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/subject.dart';
import '../providers/subject_provider.dart';
import 'add_topic_dialog.dart';
import 'topic_list.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;

  const SubjectCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  subject.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('Add Topic'),
                      onTap: () => _showAddTopicDialog(context),
                    ),
                    PopupMenuItem(
                      child: const Text('Delete Subject'),
                      onTap: () => _deleteSubject(context),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: subject.completionPercentage / 100,
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 4),
            Text(
              '${subject.completionPercentage.toStringAsFixed(1)}% Complete',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            TopicList(subject: subject),
          ],
        ),
      ),
    );
  }

  void _showAddTopicDialog(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 100),
      () => showDialog(
        context: context,
        builder: (context) => AddTopicDialog(subjectId: subject.id),
      ),
    );
  }

  void _deleteSubject(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        Provider.of<SubjectProvider>(context, listen: false)
            .deleteSubject(subject.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${subject.name} deleted')),
        );
      },
    );
  }
}