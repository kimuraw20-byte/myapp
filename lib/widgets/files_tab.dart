import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:academia_flow/models/study_file.dart';
import 'package:academia_flow/services/storage_service.dart';

class FilesTab extends StatefulWidget {
  final String subjectId;

  const FilesTab({super.key, required this.subjectId});

  @override
  State<FilesTab> createState() => _FilesTabState();
}

class _FilesTabState extends State<FilesTab> {
  List<StudyFile> files = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    final allFiles = await StorageService.getStudyFiles();
    setState(() {
      files = allFiles.where((file) => file.subjectId == widget.subjectId).toList();
      files.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      isLoading = false;
    });
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      
      if (result != null) {
        final pickedFile = result.files.single;
        final appDir = await StorageService.getAppDocumentsPath();
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}';
        final newPath = '$appDir/$fileName';
        
        // Copy file to app directory
        await File(pickedFile.path!).copy(newPath);
        
        final studyFile = StudyFile(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          subjectId: widget.subjectId,
          name: pickedFile.name,
          path: newPath,
          type: 'document',
          createdAt: DateTime.now(),
        );
        
        await StorageService.addStudyFile(studyFile);
        await _loadFiles();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking file: $e')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        final appDir = await StorageService.getAppDocumentsPath();
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${image.name}';
        final newPath = '$appDir/$fileName';
        
        // Copy image to app directory
        await File(image.path).copy(newPath);
        
        final studyFile = StudyFile(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          subjectId: widget.subjectId,
          name: image.name,
          path: newPath,
          type: 'image',
          createdAt: DateTime.now(),
        );
        
        await StorageService.addStudyFile(studyFile);
        await _loadFiles();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _deleteFile(String fileId) async {
    await StorageService.deleteStudyFile(fileId);
    await _loadFiles();
  }

  IconData _getFileIcon(String type) {
    switch (type) {
      case 'image':
        return Icons.image;
      case 'document':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: files.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_open,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No files yet',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload images or documents using the + button',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(
                      _getFileIcon(file.type),
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      file.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      'Added: ${_formatDate(file.createdAt)}\nType: ${file.type}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (file.type == 'image')
                          IconButton(
                            onPressed: () => _showImageDialog(file.path),
                            icon: const Icon(Icons.visibility),
                          ),
                        IconButton(
                          onPressed: () => _showDeleteDialog(file.id),
                          icon: Icon(Icons.delete, color: Colors.red[400]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFileOptions(),
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showAddFileOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Upload Image'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Upload Document'),
              onTap: () {
                Navigator.pop(context);
                _pickFile();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showImageDialog(String imagePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(
              File(imagePath),
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, size: 100),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(String fileId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete File'),
        content: const Text('Are you sure you want to delete this file?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteFile(fileId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}