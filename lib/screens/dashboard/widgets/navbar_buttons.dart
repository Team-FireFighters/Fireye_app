import 'package:fireye/global/helpers/app_colors.dart';
import 'package:fireye/providers/global_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavBarButtons extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final VoidCallback? onPressed;
  const NavBarButtons({super.key, required this.isActive, required this.icon, this.onPressed,});

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(
      builder: (context, provider, child) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: provider.currentPage == 0 ? 
                Colors.white : 
                  Colors.black
              )
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastEaseInToSlowEaseOut,
            margin: EdgeInsets.only(top: isActive ? 1 : 0),
            width: isActive ? 15 : 0,
            height: isActive ? 5 : 0,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: provider.currentPage == 0 ? 
                Colors.white.withOpacity(0.75) : 
                  Colors.black.withOpacity(0.85)
              // color: Colors.white.withOpacity(0.75)
            ),
          )
        ],
      ),
    );
  }
}