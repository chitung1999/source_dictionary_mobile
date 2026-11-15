import 'dart:convert';
import 'package:english_app/models/vocabulary_model.dart';
import 'package:english_app/models/word_model.dart';
import 'package:home_widget/home_widget.dart';

class WidgetService {
  static const String appGroupId = 'group.com.tung.englishapp';
  static const String widgetName = 'VocabularyWidget';

  static Future<void> initialize() async {
    await HomeWidget.setAppGroupId(appGroupId);
  }

  static Future<void> setVocabularies(List<VocabularyModel> vocabularies) async {
    List<WordModel> words = vocabularies.expand((vocabulary) => vocabulary.words).toList();

    if (words.isEmpty) return;

    final data = words.map((word) {
      return {
        'word': word.word,
        'phonetic': word.phonetic,
        'definition': word.definition,
      };
    }).toList();

    await HomeWidget.saveWidgetData<String>(
      'vocabulary_words',
      jsonEncode(data),
    );

    await HomeWidget.updateWidget(
      iOSName: widgetName,
    );
  }
}
