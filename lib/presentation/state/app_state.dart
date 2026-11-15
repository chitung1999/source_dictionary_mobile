import 'package:english_app/models/vocabulary_model.dart';

class AppState {
  final int indexTab;
  final List<VocabularyModel> vocabularies;

  const AppState({
    this.indexTab = 0,
    this.vocabularies = const [],
  });

  AppState copyWith({
    int? indexTab,
    List<VocabularyModel>? vocabularies,
  }) {
    return AppState(
      indexTab: indexTab ?? this.indexTab,
      vocabularies: vocabularies ?? this.vocabularies,
    );
  }
}