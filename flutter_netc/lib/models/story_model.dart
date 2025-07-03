// Model class representing a story or task
import 'dart:convert';

import 'package:intl/intl.dart';

DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

class StoryModel {
  final int id;
  final String title;
  final String responsible;
  final DateTime dateTime;
  final String priority;
  final String severity;
  final String itPhase;
  final List<String> imagePaths; // Changed to a list to handle multiple images

  // Constructor to initialize all required fields
  StoryModel({
    required this.id,
    required this.title,
    required this.responsible,
    required this.dateTime,
    this.priority = 'Medium',
    this.severity = 'Medium',
    this.itPhase = 'Analysis',
    required this.imagePaths,
  });

  // Creates a copy of the current instance with optional modifications
  StoryModel copyWith({
    int? id,
    String? title,
    String? responsible,
    DateTime? dateTime,
    String? priority,
    String? severity,
    String? itPhase,
    List<String>? imagePaths,
  }) {
    return StoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      responsible: responsible ?? this.responsible,
      dateTime: dateTime ?? this.dateTime,
      priority: priority ?? this.priority,
      severity: severity ?? this.severity,
      itPhase: itPhase ?? this.itPhase,
      imagePaths: imagePaths ?? this.imagePaths,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'responsible': responsible,
      'dateTime': dateTime.toIso8601String(), // Convert DateTime to ISO string
      'priority': priority,
      'severity': severity,
      'itPhase': itPhase,
      'imagePaths': jsonEncode(
        imagePaths,
      ), // Convert List<String> to JSON String
    };
  }

  factory StoryModel.fromSqfliteDatabase(Map<String, dynamic> map) =>
      StoryModel(
        id: map['id']?.toInt() ?? 0,
        title: map['title'] ?? '',
        responsible: map['responsible'] ?? '',
        dateTime: DateTime.parse(map['dateTime']),
        priority: map['priority'] ?? 'Medium',
        severity: map['severity'] ?? 'Medium',
        itPhase: map['itPhase'] ?? 'Analysis',
        imagePaths: List<String>.from(jsonDecode(map['imagePaths'])),
      );
}
