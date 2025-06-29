import 'package:flutter/material.dart';
import 'package:taskit/domain/entities/task_item.dart';

class FilterSortDialog extends StatefulWidget {
  final String initialFilter;
  final String initialSort;
  final Function(String filter, String sort) onApply;

  const FilterSortDialog({
    super.key,
    required this.initialFilter,
    required this.initialSort,
    required this.onApply,
  });

  @override
  createState() => _FilterSortDialogState();
}

class _FilterSortDialogState extends State<FilterSortDialog> {
  late String _selectedFilter;
  late String _selectedSort;

  final List<String> filterOptions = ['Default', 'Ongoing', 'Completed'];
  final List<String> sortOptions = ['Default','Due date', 'Creation date'];

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter;
    _selectedSort = widget.initialSort;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter & Sort'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Filter Dropdown
          DropdownButtonFormField<String>(
            value: _selectedFilter,
            decoration: InputDecoration(labelText: 'Filter by'),
            items: filterOptions.map((String option) {
              return DropdownMenuItem(value: option, child: Text(option));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedFilter = value!;
              });
            },
          ),
          SizedBox(height: 16),

          // Sort Dropdown
          DropdownButtonFormField<String>(
            value: _selectedSort,
            decoration: InputDecoration(labelText: 'Sort by'),
            items: sortOptions.map((String option) {
              return DropdownMenuItem(value: option, child: Text(option));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedSort = value!;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text('Apply'),
          onPressed: () {
            Navigator.of(context).pop();
            widget.onApply(_selectedFilter, _selectedSort);
          },
        ),
      ],
    );
  }
}

void showFilterAndSortDialog(SortAndFilterParams sortfilter,BuildContext context,Function(String, String) onSaveFilter) {
  showDialog(
    context: context,
    builder: (context) {
      return FilterSortDialog(
        initialFilter: 'Default',
        initialSort: 'Default',
        onApply: onSaveFilter,
      );
    },
  );
}
