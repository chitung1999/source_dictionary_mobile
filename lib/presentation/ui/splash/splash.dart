import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                'data/icon.png',
                width: 150,
                height: 150,
              ),
            ),
            SizedBox(
              height: 60,
              child: Text('© Copyright by NCT', style: Theme.of(context).textTheme.titleMedium),
            )
          ],
        ),
      ),
    );
  }

}