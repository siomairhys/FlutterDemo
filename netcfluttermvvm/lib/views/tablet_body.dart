import 'package:flutter/material.dart';

class TabletBody extends StatelessWidget {
  const TabletBody({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return const Center(child: Text('Tablet Portrait View'));
        } else {
          return const Center(child: Text('Tablet Landscape View'));
        }
      },
    );
  }
}