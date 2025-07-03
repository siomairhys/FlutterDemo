import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/sqflite/story_db_repo.dart';
import '../models/story_model.dart';

// Provider that exposes the list of stories managed by StoryNotifier
final storyProvider = StateNotifierProvider<StoryNotifier, List<StoryModel>>((
  ref,
) {
  return StoryNotifier();
});

// Notifier class that holds and manages the list of stories
class StoryNotifier extends StateNotifier<List<StoryModel>> {
  StoryNotifier() : super([]) {
    setStories();
  }

  //Future<List<StoryModel>>? futureStories; //sqflite implementation
  final storyDB = StoryDB(); //sqflite implementation

  // Set initial stories
  Future<void> setStories() async {
    final stories = await storyDB.fetchAll();
    print('##################setStories');
    print(stories);
    state = stories;
  }

  // Fix: Add new story to the top
  Future<void> add(StoryModel story) async {
    print('##################addStory');
    //print(story.dateTime.toString());
    await storyDB.create(story: story);
    setStories();
  }

  // Insert new or updated story at the top
  void updateStory(StoryModel updatedStory) {
    state = [updatedStory, ...state.where((s) => s.id != updatedStory.id)];
  }

  // Fix: Update and move story to top
  Future<void> update(StoryModel updated) async {
    print('##################updateStory');
    print(updated.toMap().toString());
    //state = [updated, ...state.where((s) => s.id != updated.id)];
    await storyDB.update(id: updated.id, story: updated);
    setStories();
  }

  Future<void> delete(int id) async {
    await storyDB.delete(id);
    setStories();
  }

  Future<StoryModel?> getById(int id) async {
    final story = await storyDB.fetchById(id);
    print('##################getById');
    print(story.toMap().toString());
    return story;
  }
}
