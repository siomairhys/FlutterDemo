// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netcfluttermvvm/widgets/app_bar.dart';
import 'package:netcfluttermvvm/widgets/tablet_list_header.dart';
import '../viewmodels/story_provider.dart';
import 'story_detail_page.dart';
import '../widgets/story_form.dart';
import '../widgets/mobile_list_card.dart';
import 'package:netcfluttermvvm/widgets/tablet_list_card.dart';
import '../responsive/responsive_layout.dart';

class StoryPage extends ConsumerWidget {
  const StoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watches the list of stories using Riverpod provider
    final stories = ref.watch(storyProvider);
    final isTablet = MediaQuery.of(context).size.width >= 904;

    return Scaffold(
      // Custom App Bar
      appBar: const CustomStyledAppBar(),
      backgroundColor: Colors.white,
      // Body: Scrollable list of story cards
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: stories.length + (isTablet ? 1 : 0), // Extra count for header
        itemBuilder: (_, i) {
          if (isTablet) {
            if (i == 0) {
              return const TabletListHeader();
            }

            final index = i - 1;

            // Safeguard in case stories is empty
            if (index >= stories.length) {
              return const SizedBox.shrink();
            }

            final story = stories[index];

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => StoryDetailPage(storyId: story.id)),
                );
              },
              // child:  MobileListCard(s),
              child:  ResponsiveLayout(
                mobileBody: MobileListCard(story),
                tabletBody: TabletListCard(story),
              ),
            );
          }
          else {
            final story = stories[i];

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => StoryDetailPage(storyId: story.id)),
                );
              },
              // child:  MobileListCard(s),
              child:  ResponsiveLayout(
                mobileBody: MobileListCard(story),
                tabletBody: TabletListCard(story),
              ),
            );
          }
        },
      ),

      // Floating Action Button to create a new story
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const StoryFormDialog(), // Open story form dialog
        ),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// Helper function to limit a string to a certain number of characters, adding "..." if truncated
// String limitWords(String text, int maxChars) {
//   if (text.length <= maxChars) return text;
//   return text.substring(0, maxChars) + '...';
// }