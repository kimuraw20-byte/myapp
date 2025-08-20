import 'package:flutter/material.dart';
import 'package:academia_flow/models/note.dart';
import 'package:academia_flow/services/storage_service.dart';

class AddNoteScreen extends StatefulWidget {
  final String subjectId;
  final Note? editNote;

  const AddNoteScreen({
    super.key,
    required this.subjectId,
    this.editNote,
  });

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.editNote != null) {
      _titleController.text = widget.editNote!.title;
      _contentController.text = widget.editNote!.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState?.validate() ?? false) {
      final note = Note(
        id: widget.editNote?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        subjectId: widget.subjectId,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        createdAt: widget.editNote?.createdAt ?? DateTime.now(),
      );

      await StorageService.addNote(note);

      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editNote == null ? 'Add Note' : 'Edit Note'),
        actions: [
          TextButton(
            onPressed: _saveNote,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Note Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Note Content',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter some content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveNote,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(widget.editNote == null ? 'Create Note' : 'Update Note'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}