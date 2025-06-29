import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskit/domain/entities/task_item.dart';

class TaskCard extends StatelessWidget {
  final TaskItem taskItem;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.taskItem,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Due on: ${DateFormat('yy-MM-dd').format(taskItem.dueDate)}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Expanded(child: SizedBox()),
                Text(
                  taskItem.completedStatus == true ? 'Done' : 'Ongoing',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Text(
              "${taskItem.title}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              "Note: ${taskItem.note}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 14,
              ),
            ),
            Row(
              children: [
                Text(
                  "Created on: ${DateFormat('yy-MM-dd').format(taskItem.createdOn)}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const Expanded(child: SizedBox()),
                Wrap(
                  spacing: 0,
                  children: [
                    GestureDetector(
                      onTap: onEdit,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Edit',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface), // small text
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onDelete,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Delete',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface), // small text
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
