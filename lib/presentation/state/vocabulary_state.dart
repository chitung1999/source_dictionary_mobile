import 'package:english_app/models/vocabulary_model.dart';

class VocabularyState {
  final String search;
  final List<VocabularyModel> vocabularies;

  const VocabularyState({
    this.search = '',
    this.vocabularies = const [],
  });

  VocabularyState copyWith({
    String? search,
    List<VocabularyModel>? vocabularies,
  }) {
    return VocabularyState(
      search: search ?? this.search,
      vocabularies: vocabularies ?? this.vocabularies,
    );
  }
}