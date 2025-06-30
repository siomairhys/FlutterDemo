// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netcfluttermvvm/widgets/build_tag.dart';
import 'package:netcfluttermvvm/widgets/app_bar.dart';
import '../../viewmodels/story_provider.dart';
import 'story_detail_page.dart';
import 'story_form.dart';
import 'package:intl/intl.dart';

class StoryPage extends ConsumerWidget {
  const StoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watches the list of stories using Riverpod provider
    final stories = ref.watch(storyProvider);

    return Scaffold(
      // Custom App Bar
      appBar: const CustomStyledAppBar(),
      backgroundColor: Colors.white,
      // Body: Scrollable list of story cards
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: stories.length,
        itemBuilder: (_, i) {
          final s = stories[i];

          // ===== Global Vars =====
          // Format date as 'Jan-10-2025 21:45' (24-hour time)
          final formattedDate = DateFormat('MMM-dd-yyyy HH:mm').format(s.dateTime.toLocal());

          return InkWell(
            // Navigate to StoryDetailPage when a card is tapped
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StoryDetailPage(storyId: s.id), // Pass story ID
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.grey.shade300,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),

              // Card content
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== Top Row: ID + Tags =====
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Story ID badge (pill style)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${s.id}', // Pad ID with leading zeros
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Wrap(
                            alignment: WrapAlignment.end, // <-- Align left
                            spacing: 5,
                            runSpacing: 6,
                            children: [
                              buildTag('priority', s.priority),
                              buildTag('severity', s.severity),
                              buildTag('itPhase', s.itPhase),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ===== Middle Row: Icon + Title =====
                    Row(
                      children: [
                        const Icon(Icons.build, size: 24, color: Colors.blue),
                        const SizedBox(width: 8),
                        // Story title text
                        Expanded(
                          child: Text(
                            s.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ===== Bottom Row: Project name + Last Modified date =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Project name badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "Fortrea", // Replace with dynamic if needed
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12), // Optional: add spacing between badge and column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Responsible By: ${(limitWords(s.responsible, 12))}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                "Modified On: $formattedDate",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
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
String limitWords(String text, int maxChars) {
  if (text.length <= maxChars) return text;
  return text.substring(0, maxChars) + '...';
}