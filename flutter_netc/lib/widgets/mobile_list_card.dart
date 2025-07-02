
import 'package:flutter/material.dart';
import 'package:netcfluttermvvm/models/story_model.dart';
import 'package:intl/intl.dart';
import 'package:netcfluttermvvm/widgets/build_tag.dart';

class MobileListCard extends StatelessWidget {
  const MobileListCard(this.story, {super.key});
  final StoryModel story;

  @override
  Widget build(context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                    '${story.id}', // Pad ID with leading zeros
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
                      buildTag('priority', story.priority),
                      buildTag('severity', story.severity),
                      buildTag('itPhase', story.itPhase),
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
                    story.title,
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
                        "Responsible By: ${(limitWords(story.responsible, 12))}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        "Modified On: ${DateFormat('MMM-dd-yyyy HH:mm').format(story.dateTime.toLocal())}",
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
    );
  }
}
// Helper function to limit a string to a certain number of characters, adding "..." if truncated
String limitWords(String text, int maxChars) {
  if (text.length <= maxChars) return text;
  return '${text.substring(0, maxChars)}...';
}