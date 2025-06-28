import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskit/data/task_item.dart';
import 'package:taskit/presentation/controller/TasksController.dart';

class EditTaskForm extends StatefulWidget {

  TaskItem taskItem;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  EditTaskForm(this.taskItem, {super.key}){
    _titleController.text =  "${taskItem.title}";
    _noteController.text =  "${taskItem.note}";
    _selectedDate =taskItem.dueDate ;
  }

  @override
  createState() => _EditTaskFormState();

}

class _EditTaskFormState extends State<EditTaskForm> {

  final _formKey = GlobalKey<FormState>();

  final TasksController tasksController = Get.find();

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget._selectedDate ,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != widget._selectedDate) {
      setState(() {
        widget._selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && widget._selectedDate != null) {
      final title = widget._titleController.text;
      final note = widget._noteController.text;
      final date = widget._selectedDate;

      // You can now use `title` and `date` to create a task
      print("Task Modified: $title on $date");

      tasksController.editTask(TaskItem(
          id: widget.taskItem.id,
          title: title,
          note: note,
          dueDate: date,
          createdOn: widget.taskItem.createdOn,
          completedStatus: false )
      );
      Get.back();
    } else {
      // Show some error if date is not selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
    }
  }

  void markAsCompleted(){
    widget.taskItem.completedStatus = true;
    tasksController.editTask(widget.taskItem);
    Get.back();
  }

  void markAsUncompleted(){
    widget.taskItem.completedStatus = false;
    tasksController.editTask(widget.taskItem);
    Get.back();
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
                controller: widget._titleController,
                decoration: const InputDecoration(labelText: 'Task Title'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: widget._noteController,
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
                    widget._selectedDate != null
                        ? "${widget._selectedDate!.toLocal()}".split(' ')[0]
                        : 'No date selected',
                    style: TextStyle(
                      color: widget._selectedDate != null
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
                child: const Text('Save Update to Device'),
              ),
              const SizedBox(height: 24),

              Visibility(
                visible: widget.taskItem.completedStatus == false,
                child: ElevatedButton(
                  onPressed: markAsCompleted,
                  child: const Text('Mark task as Completed'),
                ),
              ),

              Visibility(
                visible: widget.taskItem.completedStatus == true,
                child: ElevatedButton(
                  onPressed: markAsUncompleted,
                  child: const Text('Mark task as Uncompleted'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showEditDialog(BuildContext context, TaskItem taskItem){
  showDialog(context: context, builder: (context) => EditTaskForm(taskItem));
}