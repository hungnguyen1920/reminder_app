import 'package:flutter/material.dart';
import '../models/reminder.dart';
import '../database/database_helper.dart';

class ReminderDetailScreen extends StatefulWidget {
  final Reminder reminder;

  const ReminderDetailScreen({Key? key, required this.reminder})
    : super(key: key);

  @override
  _ReminderDetailScreenState createState() => _ReminderDetailScreenState();
}

class _ReminderDetailScreenState extends State<ReminderDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  bool _isEditing = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.reminder.title);
    _descriptionController = TextEditingController(
      text: widget.reminder.description,
    );
    _selectedDate = widget.reminder.dateTime;
    _selectedTime = TimeOfDay.fromDateTime(widget.reminder.dateTime);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _hasChanges = true;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _hasChanges = true;
      });
    }
  }

  Future<void> _saveChanges() async {
    final dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final updatedReminder = Reminder(
      id: widget.reminder.id,
      title: _titleController.text,
      description: _descriptionController.text,
      dateTime: dateTime,
      userId: widget.reminder.userId,
    );

    await DatabaseHelper.instance.updateReminder(updatedReminder.toMap());
    if (mounted) {
      setState(() {
        _isEditing = false;
        _hasChanges = false;
      });
    }
  }

  Future<void> _discardChanges() async {
    if (_hasChanges) {
      final result = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Discard Changes'),
              content: const Text(
                'Are you sure you want to discard your changes?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Yes'),
                ),
              ],
            ),
      );

      if (result == true && mounted) {
        setState(() {
          _isEditing = false;
          _hasChanges = false;
          _titleController.text = widget.reminder.title;
          _descriptionController.text = widget.reminder.description;
          _selectedDate = widget.reminder.dateTime;
          _selectedTime = TimeOfDay.fromDateTime(widget.reminder.dateTime);
        });
      }
    } else {
      setState(() {
        _isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder Details'),
        actions: [
          if (!_isEditing)
            TextButton(
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
              child: const Text('Update'),
            )
          else ...[
            TextButton(
              onPressed: _hasChanges ? _discardChanges : null,
              child: const Text('Discard'),
            ),
            TextButton(
              onPressed: _hasChanges ? _saveChanges : null,
              child: const Text('Save'),
            ),
          ],
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            enabled: _isEditing,
            onChanged:
                _isEditing
                    ? (value) {
                      setState(() {
                        _hasChanges = true;
                      });
                    }
                    : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            enabled: _isEditing,
            onChanged:
                _isEditing
                    ? (value) {
                      setState(() {
                        _hasChanges = true;
                      });
                    }
                    : null,
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Date'),
            subtitle: Text(_selectedDate.toString().split(' ')[0]),
            trailing: const Icon(Icons.calendar_today),
            onTap: _isEditing ? () => _selectDate(context) : null,
          ),
          ListTile(
            title: const Text('Time'),
            subtitle: Text(_selectedTime.format(context)),
            trailing: const Icon(Icons.access_time),
            onTap: _isEditing ? () => _selectTime(context) : null,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
