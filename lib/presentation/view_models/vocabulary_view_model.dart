import 'package:english_app/models/vocabulary_model.dart';
import 'package:english_app/models/word_model.dart';
import 'package:english_app/presentation/state/vocabulary_state.dart';
import 'package:english_app/presentation/view_models/app_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VocabularyViewModel extends Notifier<VocabularyState> {
  @override
  VocabularyState build() {
    return const VocabularyState();
  }

  void setVocabularies(List<VocabularyModel> vocabularies) =>
      state = state.copyWith(vocabularies: vocabularies);

  void onSearchChanged(String str) {
    final vocabularies = ref
        .read(appViewModel)
        .vocabularies;

    final keyword = str.trim().toLowerCase();

    final vocabulariesFilter = vocabularies.where((item) {
      return keyword.isEmpty ||
          item.title.toLowerCase().contains(keyword) ||
          item.words.any(
                (word) => word.word.toLowerCase().contains(keyword),
          );
    }).toList();

    state = state.copyWith(
      search: str,
      vocabularies: vocabulariesFilter,
    );
  }
}

final vocabularyViewModel = NotifierProvider<VocabularyViewModel, VocabularyState>(VocabularyViewModel.new);