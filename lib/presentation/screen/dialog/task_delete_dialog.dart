import 'package:flutter/material.dart';
import 'package:taskit/domain/entities/task_item.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onConfirm;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.description,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(); // Dismiss dialog
          },
        ),
        ElevatedButton(
          child: const Text('Confirm'),
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
