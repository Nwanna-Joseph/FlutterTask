import 'package:flutter/material.dart';
import 'package:taskit/data/models/task_item.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onConfirm;

  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.description,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(); // Dismiss dialog
          },
        ),
        ElevatedButton(
          child: Text('Confirm'),
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
            onConfirm(); // Execute callback
          },
        ),
      ],
    );
  }
}

showDeleteDialog(BuildContext context, TaskItem task, VoidCallback onDelete) {
  showDialog(
    context: context,
    builder: (context) => ConfirmDialog(
      title: 'Delete Task',
      description: 'Are you sure you want to delete ${task.title}?',
      onConfirm: onDelete,
    ),
  );
}
