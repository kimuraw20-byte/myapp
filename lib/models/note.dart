import 'dart:convert';

class Note {
  final String id;
  final String subjectId;
  final String title;
  final String content;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'subjectId': subjectId,
    'title': title,
    'content': content,
    'createdAt': createdAt.millisecondsSinceEpoch,
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'],
    subjectId: json['subjectId'],
    title: json['title'],
    content: json['content'],
    createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
  );

  String toJsonString() => json.encode(toJson());

  factory Note.fromJsonString(String jsonString) =>
      Note.fromJson(json.decode(jsonString));
}