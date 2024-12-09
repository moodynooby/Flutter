import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subject_provider.dart';

class AddTopicDialog extends StatefulWidget {
  final String subjectId;

  const AddTopicDialog({super.key, required this.subjectId});

  @override
  State<AddTopicDialog> createState() => _AddTopicDialogState();
}

class _AddTopicDialogState extends State<AddTopicDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Topic'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Topic Name',
            hintText: 'Enter topic name',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a topic name';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _submitForm,
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Provider.of<SubjectProvider>(context, listen: false)
          .addTopic(widget.subjectId, _nameController.text.trim());
      Navigator.pop(context);
    }
  }
}