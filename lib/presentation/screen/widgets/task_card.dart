import 'package:flutter/material.dart';
import 'package:taskit/data/task_item.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final TaskItem taskItem;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TaskCard({
    Key? key,
    required this.taskItem,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

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
                    fontWeight: FontWeight.w100,
                  ),
                ),
                Expanded(child: SizedBox()),
                Wrap(
                  spacing: 0,
                  children: [
                    TextButton.icon(
                      onPressed: onEdit,
                      // icon: const Icon(Icons.filter_list, size: 16),
                      label: Text(
                        'Edit',
                        style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface), // small text
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        // side: BorderSide(color: Theme.of(context).colorScheme.onSurface), // 👈 border here
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // optional: rounded corners
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: onDelete,
                      // icon: const Icon(Icons.filter_list, size: 16),
                      label: Text(
                        'Delete',
                        style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface), // small text
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        // side: BorderSide(color: Theme.of(context).colorScheme.onSurface), // 👈 border here
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // optional: rounded corners
                        ),
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: IconButton(
                          onPressed: onEdit,
                          icon: const Icon(Icons.edit)),
                    ),
                    Visibility(
                      visible: false,
                      child: IconButton(
                          onPressed: onDelete,
                          icon: const Icon(Icons.delete)),
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
