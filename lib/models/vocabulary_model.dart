import 'package:english_app/models/word_model.dart';

class VocabularyModel {
  final int id;
  final String title;
  final List<WordModel> words;

  const VocabularyModel({
    required this.id,
    required this.title,
    required this.words,
  });

  factory VocabularyModel.fromJson(Map<String, dynamic> json) {
    return VocabularyModel(
      id: json['id_vocabulary'] as int,
      title: json['title_vocabulary'] as String,
      words: (json['words'] as List<dynamic>)
          .map((e) => WordModel.fromJson(e))
          .toList(),
    );
  }
}