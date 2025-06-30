import 'package:flutter/material.dart';
import 'package:netcfluttermvvm/views/mobile/story_page.dart';


class MobileBody extends StatelessWidget {
  const MobileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return const StoryPage(); // Portrait layout
        } else {
          return const StoryPage(); // Or a different widget for landscape
        }
      },
    );
  }
}