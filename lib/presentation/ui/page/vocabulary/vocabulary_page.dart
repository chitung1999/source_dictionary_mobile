import 'package:english_app/presentation/ui/page/vocabulary/vocabulary_item.dart';
import 'package:english_app/presentation/ui/page/widgets/base_page.dart';
import 'package:english_app/presentation/view_models/vocabulary_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VocabularyPage extends ConsumerWidget {
  const VocabularyPage ({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outLine = OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none);

    return BasePage(
      bannerPath: 'data/banner/vocabulary.png',
      child: Column(
        spacing: 20,
        children: [
          TextField(
            onChanged: ref.read(vocabularyViewModel.notifier).onSearchChanged,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFFE5E5E9),
              border: outLine,
              enabledBorder: outLine,
              focusedBorder: outLine,
              contentPadding: const EdgeInsets.all(15),
            ),
          ),
          Expanded(child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: ref.watch(vocabularyViewModel).vocabularies.length,
            itemBuilder: (context, index) => VocabularyItem(vocabulary: ref.watch(vocabularyViewModel).vocabularies[index]),
            separatorBuilder: (context, index) => SizedBox(height: 10),
          )),
        ],
      ),
    );
  }
}