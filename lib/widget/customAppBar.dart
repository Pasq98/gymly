import 'package:flutter/material.dart';
import 'package:gymly/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(70);

  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu), iconSize: 28, color: CustomColor.fontBlack),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.logout), iconSize: 28, color: CustomColor.fontBlack),
      ],
      title: const Center(
        child: Text(
            style: TextStyle(
                color: CustomColor.fontBlack,
                shadows: [
                  Shadow(
                    color: Colors.grey, // Choose the color of the shadow
                    //blurRadius: 4.0, // Adjust the blur radius for the shadow effect
                    //  offset: Offset(1.0, 1.0), // Set the horizontal and vertical offset for the shadow
                  ),
                ],
                fontWeight: FontWeight.w600,
                fontSize: 28),
            'GIMLY'),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}
