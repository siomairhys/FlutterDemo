import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netcfluttermvvm/views/story_page.dart';

// Make sure the path and filename match the actual location and casing of your HomePage widget file.
//pleas approve my push
//this is a new commit

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: StoryPage());
  }
}
