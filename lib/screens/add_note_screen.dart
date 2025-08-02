import 'package:flutter/material.dart';
import 'package:noteskeeper/models/note.dart';
import 'package:noteskeeper/providers/note_provider.dart';
import 'package:provider/provider.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (title.isNotEmpty || description.isNotEmpty) {
      final newNote = Note(
        title: title,
        description: description,
      );
      Provider.of<NoteProvider>(context, listen: false).addNote(newNote);
      Navigator.of(context).pop();
    } else {
      // Optionally show a message if both fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note cannot be empty!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Note'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              maxLines: 1, // Restrict title to a single line
            ),
            const SizedBox(height: 16),
            Expanded( // Use Expanded for description to fill remaining space
              child: TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true, // Aligns hint text to the top for multiline
                ),
                maxLines: null, // Allows multiple lines for description
                keyboardType: TextInputType.multiline,
                expands: true, // Allows TextField to expand with content
                textAlignVertical: TextAlignVertical.top, // Aligns text to the top
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveNote,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white, // White text
                minimumSize: const Size(double.infinity, 50), // Full width button
              ),
              child: const Text('Save Note', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}