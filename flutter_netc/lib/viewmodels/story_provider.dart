import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/story_model.dart';

// Provider that exposes the list of stories managed by StoryNotifier
final storyProvider = StateNotifierProvider<StoryNotifier, List<StoryModel>>(
  (ref) => StoryNotifier(),
);

// Notifier class that holds and manages the list of stories
class StoryNotifier extends StateNotifier<List<StoryModel>> {
  StoryNotifier() : super([]);

  // Insert new or updated story at the top
  void updateStory(StoryModel updatedStory) {
    state = [
      updatedStory,
      ...state.where((s) => s.id != updatedStory.id),
    ];
  }

  // Set initial stories
  void setStories(List<StoryModel> stories) {
    state = stories;
  }

  // Fix: Add new story to the top
  void add(StoryModel story) {
    state = [
      story,
      ...state.where((s) => s.id != story.id),
    ];
  }

  // Fix: Update and move story to top
  void update(StoryModel updated) {
    state = [
      updated,
      ...state.where((s) => s.id != updated.id),
    ];
  }

  void delete(int id) {
    state = state.where((s) => s.id != id).toList();
  }

  StoryModel? getById(int id) {
    return state.firstWhere(
      (s) => s.id == id,
      orElse: () => throw Exception('Not found'),
    );
  }  
}