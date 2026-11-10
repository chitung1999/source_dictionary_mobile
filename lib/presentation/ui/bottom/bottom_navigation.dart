import 'package:english_app/presentation/view_models/app_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavigation extends ConsumerWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: ref.watch(appViewModel).indexTab,
        onTap: (index) => ref.read(appViewModel.notifier).setIndexTab(index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Vocabulary'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Review'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: 'Notes'),
        ]
    );
  }
}