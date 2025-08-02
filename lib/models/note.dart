import 'package:uuid/uuid.dart';

class Note {
  final String id;
  String title;
  String description;
  final DateTime createdAt;
  DateTime updatedAt;

  Note({
    String? id,
    required this.title,
    required this.description,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Update a note's content and its updated time
  void update({String? title, String? description}) {
    if (title != null) this.title = title;
    if (description != null) this.description = description;
    this.updatedAt = DateTime.now(); // Update time when note is modified
  }

  // Optional: For debugging or if want to print note details
  @override
  String toString() {
    return 'Note(id: $id, title: $title, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}