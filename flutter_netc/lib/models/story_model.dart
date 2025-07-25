// Model class representing a story or task
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
}
