import 'package:english_app/core/db/supabase_service.dart';
import 'package:english_app/models/vocabulary_model.dart';
import 'package:english_app/presentation/state/app_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppViewModel extends Notifier<AppState> {
  @override
  AppState build() {
    return const AppState();
  }

  Future<bool> initialize() async {
    final vocabularies = await getVocabularies();

    state = state.copyWith(
      indexTab: 0,
      vocabularies: vocabularies
    );

    return true;
  }

  void setIndexTab(int indexTab) => state = state.copyWith(indexTab: indexTab);

  Future<List<VocabularyModel>> getVocabularies() async {
    final dynamic result = await SupabaseService.instance.getVocabularies();
    final Map<int, Map<String, dynamic>> groupedData = {};

    for (final item in result) {
      final int idVocabulary = item['id_vocabulary'];

      groupedData.putIfAbsent(idVocabulary, () {
        return {
          'id_vocabulary': idVocabulary,
          'title_vocabulary': item['title_vocabulary'],
          'words': <Map<String, dynamic>>[],
        };
      });

      groupedData[idVocabulary]!['words'].add({
        'id': item['id'],
        'word': item['word'],
        'phonetic': item['phonetic'],
        'pos': item['pos'],
        'definition': item['definition'],
        'detail': item['detail'],
      });
    }

    return groupedData.values
        .map((json) => VocabularyModel.fromJson(json))
        .toList();
  }
}

final appViewModel = NotifierProvider<AppViewModel, AppState>(AppViewModel.new);