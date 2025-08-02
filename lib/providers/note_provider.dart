import 'package:flutter/material.dart';
import 'package:noteskeeper/models/note.dart';

// Enum to define sorting options
enum NoteSortOrder {
  dateModifiedAscending,
  dateModifiedDescending,
  dateCreatedAscending,
  dateCreatedDescending,
}


class NoteProvider with ChangeNotifier {
  final List<Note> _notes = [];
  String _searchQuery = '';
  NoteSortOrder _currentSortOrder = NoteSortOrder.dateModifiedDescending;

  NoteSortOrder get currentSortOrder => _currentSortOrder;

  List<Note> get notes {
    // 1. Apply search filter
    List<Note> filteredNotes = _notes.where((note) {
      final queryLower = _searchQuery.toLowerCase();
      return note.title.toLowerCase().contains(queryLower) ||
          note.description.toLowerCase().contains(queryLower);
    }).toList();

    // 2. Apply sorting
    filteredNotes.sort((a, b) {
      if (_currentSortOrder == NoteSortOrder.dateModifiedAscending) {
        return a.updatedAt.compareTo(b.updatedAt);
      } else if (_currentSortOrder == NoteSortOrder.dateModifiedDescending) {
        return b.updatedAt.compareTo(a.updatedAt);
      } else if (_currentSortOrder == NoteSortOrder.dateCreatedAscending) {
        return a.createdAt.compareTo(b.createdAt);
      } else {
        return b.createdAt.compareTo(a.createdAt);
      }
    });

    return filteredNotes;
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateSortOrder(NoteSortOrder newOrder) {
    _currentSortOrder = newOrder;
    notifyListeners();
  }

  void addNote(Note note) {
    _notes.add(note);
    notifyListeners();
  }

  void updateNote(Note updatedNote) {
    final index = _notes.indexWhere((note) => note.id == updatedNote.id);
    if (index != -1) {
      _notes[index].update(title: updatedNote.title, description: updatedNote.description);
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((note) => note.id == id);
    notifyListeners();
  }
}
