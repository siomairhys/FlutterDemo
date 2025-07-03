import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:netcfluttermvvm/widgets/build_tag.dart';
import 'package:netcfluttermvvm/views/story_detail_page.dart';
import 'package:netcfluttermvvm/Models/story_model.dart';

Widget buildStoryCard(BuildContext context, StoryModel s) {
  final formattedDate = DateFormat('MMM-dd-yyyy HH:mm').format(s.dateTime.toLocal());

  // Helper function to limit a string to a certain number of characters, adding "..." if truncated
  String limitWords(String text, int maxChars) {
    if (text.length <= maxChars) return text;
    return '${text.substring(0, maxChars)}...';
  }

  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => StoryDetailPage(storyId: s.id)),
      );
    },
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Top Row: ID + Tags =====
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${s.id}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Wrap(
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

            // ===== Bottom Row: Project name + Metadata =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Fortrea",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Responsible By: ${limitWords(s.responsible, 12)}",
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
}
