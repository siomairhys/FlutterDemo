import 'package:flutter/material.dart';

class TabletListHeader extends StatelessWidget {
  const TabletListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2),     // ID
          1: FixedColumnWidth(100),   // Priority
          2: FixedColumnWidth(100),   // Severity
          3: FixedColumnWidth(100),   // State
          4: FlexColumnWidth(4),     // Title
          5: FlexColumnWidth(1.5),     // Responsible
          6: FlexColumnWidth(2),     // Modified On
          7: FixedColumnWidth(90),   // Project
        },
        children: [
          TableRow(
            children: [
              _headerText('#'),
              _headerText('Priority'),
              _headerText('Severity'),
              _headerText('State'),
              _headerText('Title'),
              _headerText('Responsible'),
              _headerText('Modified On'),
              _headerText('Project'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerText(String text) => Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black87,
        ),
      );
}