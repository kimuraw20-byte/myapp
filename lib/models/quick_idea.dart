import 'dart:convert';

class QuickIdea {
  final String id;
  final String subjectId;
  final String text;
  final DateTime createdAt;

  QuickIdea({
    required this.id,
    required this.subjectId,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'subjectId': subjectId,
    'text': text,
    'createdAt': createdAt.millisecondsSinceEpoch,
  };

  factory QuickIdea.fromJson(Map<String, dynamic> json) => QuickIdea(
    id: json['id'],
    subjectId: json['subjectId'],
    text: json['text'],
    createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
  );

  String toJsonString() => json.encode(toJson());

  factory QuickIdea.fromJsonString(String jsonString) =>
      QuickIdea.fromJson(json.decode(jsonString));
}