// build_tag.dart
import 'package:flutter/material.dart';

Widget buildTag(String type, String value) {
  String label = '';
  Color color;

  switch (type) {
    case 'priority':
      label = 'Pri';
      color = value == 'High'
          ? Colors.red
          : value == 'Medium'
              ? Colors.orange
              : Colors.blue; // Low
      break;
    case 'severity':
      label = 'Sev';
      color = value == 'High'
          ? Colors.red
          : value == 'Medium'
              ? Colors.orange
              : Colors.blue;
      break;
    case 'itPhase':
      label = value; // Show full I/T phase
      color = value == 'Analysis'
          ? Colors.green
          : value == 'Design'
              ? Colors.green
              : Colors.green; // I/T
      break;
    default:
      label = value;
      color = Colors.grey;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
