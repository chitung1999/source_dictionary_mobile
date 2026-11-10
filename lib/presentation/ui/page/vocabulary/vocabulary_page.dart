import 'package:english_app/presentation/ui/page/vocabulary/vocabulary_item.dart';
import 'package:english_app/presentation/ui/page/widgets/base_page.dart';
import 'package:flutter/material.dart';

class VocabularyPage extends StatefulWidget {
  const VocabularyPage ({super.key});

  @override
  State<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      bannerPath: 'data/banner/vocabulary.png',
      child: Column(
        spacing: 20,
        children: [
          Container(
            width: double.infinity,
            height: 45,
            decoration: const BoxDecoration(
            color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(30))
            )
          ),
          VocabularyItem()
        ],
      ),
    );
  }
}