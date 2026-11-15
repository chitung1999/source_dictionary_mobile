import 'dart:convert';
import 'dart:io';

import 'package:english_app/models/vocabulary_model.dart';
import 'package:english_app/models/word_model.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';

class WidgetService {
  static const String appGroupId = 'group.com.tung.englishapp';
  static const String widgetName = 'VocabularyWidget';
  static const _iosChannel = MethodChannel('englishapp/vocabulary_widget');

  static Future<void> initialize() async {
    if (!Platform.isIOS) {
      await HomeWidget.setAppGroupId(appGroupId);
    }
  }

  static Future<void> setVocabularies(
    List<VocabularyModel> vocabularies,
  ) async {
    final List<WordModel> words = vocabularies
        .expand((vocabulary) => vocabulary.words)
        .toList();
    final isIOS = Platform.isIOS;
    if (!isIOS && words.isEmpty) return;

    final data = words.map((word) {
      return {
        'word': word.word,
        'phonetic': word.phonetic,
        'definition': word.definition,
        if (isIOS) 'detail': word.detail,
      };
    }).toList();

    final json = jsonEncode(data);
    if (isIOS) {
      await _iosChannel.invokeMethod<void>('saveVocabulary', json);
      return;
    }

    await HomeWidget.saveWidgetData<String>('vocabulary_words', json);

    await HomeWidget.updateWidget(iOSName: widgetName);
  }
}
