import 'package:flutter/material.dart';

class AddTaskForm extends StatefulWidget {
  @override
  _AddTaskFormState createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final title = _titleController.text;
      final date = _selectedDate;

      // You can now use `title` and `date` to create a task
      print("Task Added: $title on $date");
    } else {
      // Show some error if date is not selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Title Input
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
              validator: (value) =>
              value == null || value.isEmpty ? 'Enter a title' : null,
            ),
            SizedBox(height: 16),

            // Date Picker
            InkWell(
              onTap: () => _pickDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Select Date',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  _selectedDate != null
                      ? "${_selectedDate!.toLocal()}".split(' ')[0]
                      : 'No date selected',
                  style: TextStyle(
                    color: _selectedDate != null
                        ? Colors.black87
                        : Colors.grey[600],
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
