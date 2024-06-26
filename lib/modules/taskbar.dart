import 'package:flutter/material.dart';
import 'grammar/grammar_screen.dart';
import 'home/home_screen.dart';
import 'game/game_screen.dart';
import 'dictionary/dictionary_screen.dart';
import 'setting/setting_screen.dart';

class Taskbar extends StatefulWidget {
  const Taskbar({super.key, required this.onChangedTheme});

  final Function() onChangedTheme;

  @override
  _TaskbarState createState() => _TaskbarState();
}

class _TaskbarState extends State<Taskbar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const HomeScreen(),
          GrammarScreen(),
          const DictionaryScreen(),
          const GameScreen(),
          SettingScreen(onChangedTheme: widget.onChangedTheme),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: 'Grammar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Dictionary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_esports),
            label: 'Game',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}