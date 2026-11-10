import 'package:english_app/presentation/ui/page/widgets/base_page.dart';
import 'package:flutter/material.dart';

class NotePage extends StatefulWidget {
  const NotePage ({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      bannerPath: 'data/banner/note.png',
      child: Container(color: Colors.red,),
    );
  }
}