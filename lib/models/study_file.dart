import 'dart:convert';

class StudyFile {
  final String id;
  final String subjectId;
  final String name;
  final String path;
  final String type;
  final DateTime createdAt;

  StudyFile({
    required this.id,
    required this.subjectId,
    required this.name,
    required this.path,
    required this.type,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'subjectId': subjectId,
    'name': name,
    'path': path,
    'type': type,
    'createdAt': createdAt.millisecondsSinceEpoch,
  };

  factory StudyFile.fromJson(Map<String, dynamic> json) => StudyFile(
    id: json['id'],
    subjectId: json['subjectId'],
    name: json['name'],
    path: json['path'],
    type: json['type'],
    createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
  );

  String toJsonString() => json.encode(toJson());

  factory StudyFile.fromJsonString(String jsonString) =>
      StudyFile.fromJson(json.decode(jsonString));
}