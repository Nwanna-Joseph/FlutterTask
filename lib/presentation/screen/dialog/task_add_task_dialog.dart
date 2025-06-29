import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskit/data/task_item.dart';
import 'package:taskit/presentation/controller/TasksController.dart';

class AddTaskForm extends StatefulWidget {

   TasksController tasksController = Get.find();

   AddTaskForm();

  @override
  _AddTaskFormState createState() => _AddTaskFormState();

}

class _AddTaskFormState extends State<AddTaskForm> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final TasksController tasksController = Get.find();

  init(){
    _titleController.text = "Simple Title";
    _noteController.text = "Simple Note";
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
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
      final note = _noteController.text;
      final date = _selectedDate;

      // You can now use `title` and `date` to create a task
      print("Task Added: $title on $date");

      tasksController.addTask(TaskItem(
          id: DateTime.now().toString(),
          title: title,
          note: note,
          dueDate: date,
          createdOn: DateTime.now(),
          completedStatus: false)
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task Added at ${DateTime.now()}')),
      );
    } else {
      // Show some error if date is not selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title Input
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Task Title'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 16),
      
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note Attachment:'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Add a note:' : null,
              ),
              const SizedBox(height: 16),
      
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
              const SizedBox(height: 24),
      
              // Submit Button
              ElevatedButton(
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

showAddDialog(BuildContext context){
  showDialog(context: context, builder: (context) => AddTaskForm());
}