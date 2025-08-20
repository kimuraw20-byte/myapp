import 'package:flutter/material.dart';
import 'package:academia_flow/models/subject.dart';
import 'package:academia_flow/widgets/notes_tab.dart';
import 'package:academia_flow/widgets/files_tab.dart';
import 'package:academia_flow/widgets/ideas_tab.dart';
import 'package:academia_flow/widgets/quizzes_tab.dart';

class SubjectDetailScreen extends StatelessWidget {
  final Subject subject;

  const SubjectDetailScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(subject.name),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.note), text: 'Notes'),
              Tab(icon: Icon(Icons.folder), text: 'Files'),
              Tab(icon: Icon(Icons.lightbulb), text: 'Ideas'),
              Tab(icon: Icon(Icons.quiz), text: 'Quizzes'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            NotesTab(subjectId: subject.id),
            FilesTab(subjectId: subject.id),
            IdeasTab(subjectId: subject.id),
            QuizzesTab(subjectId: subject.id),
          ],
        ),
      ),
    );
  }
}