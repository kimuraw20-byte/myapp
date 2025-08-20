import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:academia_flow/models/subject.dart';
import 'package:academia_flow/models/note.dart';
import 'package:academia_flow/models/quick_idea.dart';
import 'package:academia_flow/models/quiz.dart';
import 'package:academia_flow/models/study_file.dart';

class StorageService {
  static const String _subjectsKey = 'subjects';
  static const String _notesKey = 'notes';
  static const String _ideasKey = 'ideas';
  static const String _quizzesKey = 'quizzes';
  static const String _filesKey = 'files';

  static Future<void> initializeSampleData() async {
    final prefs = await SharedPreferences.getInstance();
    
    if (!prefs.containsKey(_subjectsKey)) {
      final subjects = [
        Subject(id: '1', name: 'Mathematics', icon: 'calculate', color: 0xFF2196F3),
        Subject(id: '2', name: 'Physics', icon: 'science', color: 0xFF4CAF50),
        Subject(id: '3', name: 'Chemistry', icon: 'biotech', color: 0xFFFF9800),
        Subject(id: '4', name: 'Literature', icon: 'book', color: 0xFF9C27B0),
        Subject(id: '5', name: 'History', icon: 'history_edu', color: 0xFF795548),
        Subject(id: '6', name: 'Computer Science', icon: 'computer', color: 0xFF607D8B),
      ];
      await saveSubjects(subjects);

      final sampleNotes = [
        Note(
          id: '1',
          subjectId: '1',
          title: 'Calculus Fundamentals',
          content: 'Derivatives represent the rate of change of a function. The derivative of f(x) = x² is f\'(x) = 2x.',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Note(
          id: '2',
          subjectId: '2',
          title: 'Newton\'s Laws',
          content: 'First Law: An object at rest stays at rest unless acted upon by an external force.',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];
      await saveNotes(sampleNotes);

      final sampleIdeas = [
        QuickIdea(
          id: '1',
          subjectId: '1',
          text: 'Practice integration by parts with trigonometric functions',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        QuickIdea(
          id: '2',
          subjectId: '4',
          text: 'Analyze the symbolism in Shakespeare\'s Hamlet Act 3',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ];
      await saveQuickIdeas(sampleIdeas);

      final sampleQuizzes = [
        Quiz(
          id: '1',
          subjectId: '1',
          title: 'Basic Algebra Quiz',
          questions: [
            Question(
              text: 'What is 2x + 3 = 11?',
              options: ['x = 3', 'x = 4', 'x = 5', 'x = 6'],
              correctAnswer: 1,
            ),
            Question(
              text: 'Solve for y: 3y - 6 = 9',
              options: ['y = 3', 'y = 4', 'y = 5', 'y = 6'],
              correctAnswer: 2,
            ),
          ],
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];
      await saveQuizzes(sampleQuizzes);
    }
  }

  // Subjects
  static Future<List<Subject>> getSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    final subjectsJson = prefs.getStringList(_subjectsKey) ?? [];
    return subjectsJson.map((json) => Subject.fromJsonString(json)).toList();
  }

  static Future<void> saveSubjects(List<Subject> subjects) async {
    final prefs = await SharedPreferences.getInstance();
    final subjectsJson = subjects.map((s) => s.toJsonString()).toList();
    await prefs.setStringList(_subjectsKey, subjectsJson);
  }

  // Notes
  static Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList(_notesKey) ?? [];
    return notesJson.map((json) => Note.fromJsonString(json)).toList();
  }

  static Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = notes.map((n) => n.toJsonString()).toList();
    await prefs.setStringList(_notesKey, notesJson);
  }

  static Future<void> addNote(Note note) async {
    final notes = await getNotes();
    notes.add(note);
    await saveNotes(notes);
  }

  static Future<void> deleteNote(String noteId) async {
    final notes = await getNotes();
    notes.removeWhere((note) => note.id == noteId);
    await saveNotes(notes);
  }

  // Quick Ideas
  static Future<List<QuickIdea>> getQuickIdeas() async {
    final prefs = await SharedPreferences.getInstance();
    final ideasJson = prefs.getStringList(_ideasKey) ?? [];
    return ideasJson.map((json) => QuickIdea.fromJsonString(json)).toList();
  }

  static Future<void> saveQuickIdeas(List<QuickIdea> ideas) async {
    final prefs = await SharedPreferences.getInstance();
    final ideasJson = ideas.map((i) => i.toJsonString()).toList();
    await prefs.setStringList(_ideasKey, ideasJson);
  }

  static Future<void> addQuickIdea(QuickIdea idea) async {
    final ideas = await getQuickIdeas();
    ideas.add(idea);
    await saveQuickIdeas(ideas);
  }

  static Future<void> deleteQuickIdea(String ideaId) async {
    final ideas = await getQuickIdeas();
    ideas.removeWhere((idea) => idea.id == ideaId);
    await saveQuickIdeas(ideas);
  }

  // Quizzes
  static Future<List<Quiz>> getQuizzes() async {
    final prefs = await SharedPreferences.getInstance();
    final quizzesJson = prefs.getStringList(_quizzesKey) ?? [];
    return quizzesJson.map((json) => Quiz.fromJsonString(json)).toList();
  }

  static Future<void> saveQuizzes(List<Quiz> quizzes) async {
    final prefs = await SharedPreferences.getInstance();
    final quizzesJson = quizzes.map((q) => q.toJsonString()).toList();
    await prefs.setStringList(_quizzesKey, quizzesJson);
  }

  static Future<void> addQuiz(Quiz quiz) async {
    final quizzes = await getQuizzes();
    quizzes.add(quiz);
    await saveQuizzes(quizzes);
  }

  static Future<void> deleteQuiz(String quizId) async {
    final quizzes = await getQuizzes();
    quizzes.removeWhere((quiz) => quiz.id == quizId);
    await saveQuizzes(quizzes);
  }

  // Files
  static Future<List<StudyFile>> getStudyFiles() async {
    final prefs = await SharedPreferences.getInstance();
    final filesJson = prefs.getStringList(_filesKey) ?? [];
    return filesJson.map((json) => StudyFile.fromJsonString(json)).toList();
  }

  static Future<void> saveStudyFiles(List<StudyFile> files) async {
    final prefs = await SharedPreferences.getInstance();
    final filesJson = files.map((f) => f.toJsonString()).toList();
    await prefs.setStringList(_filesKey, filesJson);
  }

  static Future<void> addStudyFile(StudyFile file) async {
    final files = await getStudyFiles();
    files.add(file);
    await saveStudyFiles(files);
  }

  static Future<void> deleteStudyFile(String fileId) async {
    final files = await getStudyFiles();
    final fileToDelete = files.firstWhere((file) => file.id == fileId);
    
    // Delete actual file from storage
    try {
      final file = File(fileToDelete.path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Handle file deletion error
    }
    
    files.removeWhere((file) => file.id == fileId);
    await saveStudyFiles(files);
  }

  static Future<String> getAppDocumentsPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}