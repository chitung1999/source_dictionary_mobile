import 'package:english_app/presentation/ui/page/widgets/study_card.dart';
import 'package:english_app/presentation/view_models/app_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavigation extends ConsumerWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: studyPurple,
      currentIndex: ref.watch(appViewModel).indexTab,
      onTap: (index) => ref.read(appViewModel.notifier).setIndexTab(index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_outlined),
          activeIcon: Icon(Icons.menu_book_rounded),
          label: 'Vocabulary',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.quiz_outlined),
          activeIcon: Icon(Icons.quiz_rounded),
          label: 'Review',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sticky_note_2_outlined),
          activeIcon: Icon(Icons.sticky_note_2_rounded),
          label: 'Notes',
        ),
      ],
    );
  }
}
