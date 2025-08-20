import 'dart:convert';

class Subject {
  final String id;
  final String name;
  final String icon;
  final int color;

  Subject({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon': icon,
    'color': color,
  };

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
    id: json['id'],
    name: json['name'],
    icon: json['icon'],
    color: json['color'],
  );

  String toJsonString() => json.encode(toJson());

  factory Subject.fromJsonString(String jsonString) =>
      Subject.fromJson(json.decode(jsonString));
}