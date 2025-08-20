import 'dart:convert';

class Question {
  final String text;
  final List<String> options;
  final int correctAnswer;

  Question({
    required this.text,
    required this.options,
    required this.correctAnswer,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'options': options,
    'correctAnswer': correctAnswer,
  };

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    text: json['text'],
    options: List<String>.from(json['options']),
    correctAnswer: json['correctAnswer'],
  );
}

class Quiz {
  final String id;
  final String subjectId;
  final String title;
  final List<Question> questions;
  final DateTime createdAt;

  Quiz({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.questions,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'subjectId': subjectId,
    'title': title,
    'questions': questions.map((q) => q.toJson()).toList(),
    'createdAt': createdAt.millisecondsSinceEpoch,
  };

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
    id: json['id'],
    subjectId: json['subjectId'],
    title: json['title'],
    questions: (json['questions'] as List)
        .map((q) => Question.fromJson(q))
        .toList(),
    createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
  );

  String toJsonString() => json.encode(toJson());

  factory Quiz.fromJsonString(String jsonString) =>
      Quiz.fromJson(json.decode(jsonString));
}