import 'package:flutter/material.dart';

class TaskListWidget extends StatelessWidget {
  final List<String> tasks;

  const TaskListWidget({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? const Center(child: Text('No tasks available'))
        : ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.check_circle_outline),
          title: Text(tasks[index]),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Handle item tap if needed
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tapped on: ${tasks[index]}')),
            );
          },
        );
      },
    );
  }
}
