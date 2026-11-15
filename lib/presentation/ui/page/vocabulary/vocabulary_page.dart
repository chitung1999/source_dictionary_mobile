import 'package:english_app/presentation/ui/page/vocabulary/vocabulary_item.dart';
import 'package:english_app/presentation/ui/page/widgets/base_page.dart';
import 'package:english_app/presentation/ui/page/widgets/study_search_field.dart';
import 'package:english_app/presentation/view_models/vocabulary_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VocabularyPage extends ConsumerWidget {
  const VocabularyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vocabularies = ref.watch(vocabularyViewModel).vocabularies;
    return BasePage(
      bannerPath: 'data/banner/vocabulary.png',
      child: Column(
        spacing: 20,
        children: [
          StudySearchField(
            hint: 'Search vocabulary',
            onChanged: ref.read(vocabularyViewModel.notifier).onSearchChanged,
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: vocabularies.length,
              itemBuilder: (context, index) {
                final vocabulary = vocabularies[index];
                return VocabularyItem(
                  key: ValueKey(vocabulary.id),
                  vocabulary: vocabulary,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10),
            ),
          ),
        ],
      ),
    );
  }
}
