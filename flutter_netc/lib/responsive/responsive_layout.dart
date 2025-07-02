import 'package:flutter/material.dart';


class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget tabletBody;

const ResponsiveLayout({
  super.key,
  required this.mobileBody,
  required this.tabletBody,});

  static bool isMobile(BuildContext context) =>
    MediaQuery.sizeOf(context).width < 904;
  
  static bool isTablet(BuildContext context) =>
    MediaQuery.sizeOf(context).width <1200 &&
    MediaQuery.sizeOf(context).width >= 904;

@override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    if (size.width >= 904) {
      return tabletBody; // Return tablet layout
    } else {
      return mobileBody; // Return mobile layout
    }
  }
}
