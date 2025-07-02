import 'package:flutter/material.dart';

// Custom AppBar widget that matches a specific UI style
class CustomStyledAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomStyledAppBar({super.key});

  // Sets the height of the custom app bar
  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,              // Background color of the app bar
      automaticallyImplyLeading: false,           // Hides default back button if available
      elevation: 0,                                // Removes the shadow/elevation
      title: SizedBox(
        height: 40,                                
        child: Row(
          children: [
            // "Stories" pill-style label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20), 
              alignment: Alignment.center,                         
              decoration: BoxDecoration(
                color: Colors.grey.shade300,                              
                borderRadius: BorderRadius.horizontal(
                  left: const Radius.circular(20),                 
                  right: const Radius.circular(20),                
                ),
              ),
              child: const Text(
                "NetC STORIES",                                     // Text shown inside the pill
                style: TextStyle(
                  color: Colors.black,                              
                  fontWeight: FontWeight.w500,                    
                ),
              ),
            ),

            // Spacer to push the pill to the left and fill remaining space
            // Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
