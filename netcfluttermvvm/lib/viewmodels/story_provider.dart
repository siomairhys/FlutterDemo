import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Models/story_model.dart';

// Provider that exposes the list of stories managed by StoryNotifier
final storyProvider = StateNotifierProvider<StoryNotifier, List<StoryModel>>(
  (ref) => StoryNotifier(),
);

// Notifier class that holds and manages the list of stories
class StoryNotifier extends StateNotifier<List<StoryModel>> {
  // Initializes the state as an empty list of stories
  StoryNotifier() : super([]);

  // Add a new story to the list
  void add(StoryModel story) {
    // Creates a new list including the new story
    state = [...state, story];
  }

  // Update an existing story by matching its id
  void update(StoryModel updated) {
    state = [
      for (final s in state)
        if (s.id == updated.id) updated else s, // Replace if ID matches, otherwise keep existing
    ];
  }

  // Remove a story by its id
  void delete(int id) {
    // Filters out the story with the matching id
    state = state.where((s) => s.id != id).toList();
  }

  // Retrieve a specific story by its id
  StoryModel? getById(int id) {
    // Returns the first story that matches the id, throws exception if not found
    return state.firstWhere(
      (s) => s.id == id,
      orElse: () => throw Exception('Not found'),
    );
  }
}
