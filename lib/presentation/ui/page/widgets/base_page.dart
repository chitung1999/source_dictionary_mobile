import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  const BasePage({super.key, required this.bannerPath, required this.child});
  final String bannerPath;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          Image.asset(bannerPath),
          Positioned(
            top: 130,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 15, horizontal: 20),
                child: child,
              ),
            ),
          )
        ],
      ),
    );
  }
}