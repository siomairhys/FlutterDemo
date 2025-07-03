// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/app_bar.dart';
import '../widgets/tablet_list_header.dart';
import '../viewmodels/story_provider_sqflite.dart';
import 'story_detail_page.dart';
import 'story_form.dart';
import '../widgets/mobile_list_card.dart';
import '../widgets/tablet_list_card.dart';
import '../responsive/responsive_layout.dart';

class StoryPage extends ConsumerStatefulWidget {
  const StoryPage({super.key});

  @override
  ConsumerState<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends ConsumerState<StoryPage> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stories = ref.watch(storyProvider);
    final isTablet = MediaQuery.of(context).size.width >= 904;

    return Scaffold(
      appBar: const CustomStyledAppBar(),
      backgroundColor: Colors.white,

      body: ListView.builder(
        controller: _scrollController, // ✅ attach controller
        padding: const EdgeInsets.all(8),
        itemCount: stories.length + (isTablet ? 1 : 0),
        itemBuilder: (_, i) {
          if (isTablet && i == 0) return const TabletListHeader();
          final index = isTablet ? i - 1 : i;

          if (index >= stories.length) return const SizedBox.shrink();
          final story = stories[index];

          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StoryDetailPage(
                  storyId: story.id,
                  onUpdated: _scrollToTop, // ✅ pass scroll callback
                ),
              ),
            ),
            child: ResponsiveLayout(
              mobileBody: MobileListCard(story),
              tabletBody: TabletListCard(story),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => StoryFormDialog(
            onSave: (callback) async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );
              await callback();
              if (context.mounted) Navigator.of(context).pop(); // close loading
              _scrollToTop(); // ✅ scroll to top
            },
          ),
        ),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
