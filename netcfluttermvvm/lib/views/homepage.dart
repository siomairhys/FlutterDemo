import 'package:flutter/material.dart';
import 'package:netcfluttermvvm/Views/tablet_body.dart';
import 'package:netcfluttermvvm/views/mobile_body.dart';
import 'package:netcfluttermvvm/responsive/responsive_layout.dart';


class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build (BuildContext context) {
    return Scaffold (
      body: ResponsiveLayout(
        mobileBody: const MobileBody(),
        tabletBody: const TabletBody(),
      ),
    );
  }
  }