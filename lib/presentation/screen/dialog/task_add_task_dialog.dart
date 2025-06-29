import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskit/domain/entities/task_item.dart';
import 'package:taskit/presentation/controller/tasks_controller.dart';

class AddTaskForm extends StatefulWidget {
  const AddTaskForm({super.key});

  @override
  createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _tasksController = Get.find<TasksController>();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _titleController.text = "Simple Title";
    _noteController.text = "Simple Note";
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final task = TaskItem(
        id: DateTime.now().toIso8601String(),
        title: _titleController.text,
        note: _noteController.text,
        dueDate: _selectedDate,
        createdOn: DateTime.now(),
        completedStatus: false,
      );

      _tasksController.addTask(task);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task Added at ${DateTime.now()}')),
      );

      Navigator.of(context).pop(); // Close the dialog
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      key: const Key('add_task_dialog'),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: const Key('title_field'),
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Task Title'),
                validator: (value) =>
                (value == null || value.isEmpty) ? 'Enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('note_field'),
                controller: _noteController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(labelText: 'Task Note'),
                validator: (value) =>
                (value == null || value.isEmpty) ? 'Enter a note' : null,
              ),
              const SizedBox(height: 16),
              InkWell(
                key: const Key('date_picker'),
                onTap: () => _pickDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Due Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _selectedDate.toLocal().toString().split(' ')[0],
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                key: const Key('submit_button'),
                onPressed: _submitForm,
                child: const Text('Save Task to Device'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Show dialog with key
void showAddDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => const AddTaskForm(),
  );
}
