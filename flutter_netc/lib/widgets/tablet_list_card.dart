import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:netcfluttermvvm/models/story_model.dart';
import 'package:netcfluttermvvm/widgets/build_tag.dart';

class TabletListCard extends StatelessWidget {
  final StoryModel story;

  const TabletListCard(this.story, {super.key});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMM yyyy – HH:mm').format(story.dateTime.toLocal());

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const {
          0: FlexColumnWidth(1.5),     // ID
          1: FixedColumnWidth(100),   // Priority
          2: FixedColumnWidth(100),   // Severity
          3: FixedColumnWidth(95),   // State
          4: FlexColumnWidth(3.0),     // Title
          5: FlexColumnWidth(1.5),     // Responsible
          6: FlexColumnWidth(1.5),     // Modified On
          7: FixedColumnWidth(95),   // Project
        },
        children: [
          TableRow(
            children: [
              Text('${story.id}'),

              Align(
                alignment: Alignment.centerLeft,
                child: buildTag('priority', story.priority),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: buildTag('severity', story.severity),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: buildTag('itPhase', story.itPhase),
              ),

              Text(
                story.title,
                style: const TextStyle(
                  color: Colors.blue,
                  // decoration: TextDecoration.underline,
                ),
              ),

              Text(story.responsible),
              Text(formattedDate),

              Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  label: const Text("FORTREA"),
                  backgroundColor: Colors.purple,
                  labelStyle: const TextStyle(color: Colors.white),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
