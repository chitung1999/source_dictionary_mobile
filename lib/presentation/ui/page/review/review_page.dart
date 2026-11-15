import 'package:english_app/models/vocabulary_model.dart';
import 'package:english_app/models/word_model.dart';
import 'package:english_app/presentation/ui/page/widgets/base_page.dart';
import 'package:english_app/presentation/ui/page/widgets/study_card.dart';
import 'package:english_app/presentation/view_models/app_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReviewPage extends ConsumerWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vocabularies = ref.watch(
      appViewModel.select((state) => state.vocabularies),
    );
    return BasePage(
      bannerPath: 'data/banner/review.png',
      child: _ReviewQuiz(vocabularies: vocabularies),
    );
  }
}

class _ReviewQuiz extends StatefulWidget {
  const _ReviewQuiz({required this.vocabularies});

  final List<VocabularyModel> vocabularies;

  @override
  State<_ReviewQuiz> createState() => _ReviewQuizState();
}

class _ReviewQuizState extends State<_ReviewQuiz> {
  final _scrollController = ScrollController();
  WordModel? _question;
  List<String> _options = [];
  String? _selected;

  @override
  void initState() {
    super.initState();
    _nextQuestion();
  }

  @override
  void didUpdateWidget(covariant _ReviewQuiz oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.vocabularies != widget.vocabularies) {
      _nextQuestion();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _nextQuestion() {
    final entries =
        widget.vocabularies
            .expand((vocabulary) => vocabulary.words)
            .where(
              (word) =>
                  word.word.trim().isNotEmpty &&
                  word.definition.trim().isNotEmpty,
            )
            .toList()
          ..shuffle();

    // Group alternate meanings so they cannot become distractors for that word.
    final meaningsByWord = <String, Set<String>>{};
    final definitions = <String, String>{};
    for (final word in entries) {
      final definition = word.definition.trim();
      final key = definition.toLowerCase();
      definitions[key] = definition;
      meaningsByWord.putIfAbsent(_wordKey(word), () => {}).add(key);
    }
    final eligible = entries.where((word) {
      return definitions.length - meaningsByWord[_wordKey(word)]!.length >= 3;
    }).toList();

    final previous = _question;
    _selected = null;
    if (eligible.isEmpty) {
      _question = null;
      _options = [];
      return;
    }

    final next = eligible.firstWhere(
      (word) => previous == null || _wordKey(word) != _wordKey(previous),
      orElse: () => eligible.first,
    );
    final meanings = meaningsByWord[_wordKey(next)]!;
    final distractors = [
      for (final entry in definitions.entries)
        if (!meanings.contains(entry.key)) entry.value,
    ]..shuffle();
    _question = next;
    _options = [next.definition.trim(), ...distractors.take(3)]..shuffle();
  }

  String _wordKey(WordModel word) => word.word.trim().toLowerCase();

  @override
  Widget build(BuildContext context) {
    final question = _question;
    if (question == null) {
      return const Center(
        child: Text(
          'Review needs a word and three distinct alternative meanings.',
          textAlign: TextAlign.center,
          style: TextStyle(color: studyInk),
        ),
      );
    }

    final correct = question.definition.trim();
    final answered = _selected != null;
    return ListView(
      controller: _scrollController,
      padding: EdgeInsets.zero,
      children: [
        StudyCard(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(gradient: studyHeader),
            child: Text(
              question.word,
              style: const TextStyle(
                color: studyInk,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        for (final (index, option) in _options.indexed) ...[
          _answer(index, option, correct),
          const SizedBox(height: 10),
        ],
        if (answered)
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: studyPurple),
            onPressed: () {
              setState(_nextQuestion);
              _scrollController.jumpTo(0);
            },
            child: const Text('Next question'),
          ),
      ],
    );
  }

  Widget _answer(int index, String option, String correct) {
    final answered = _selected != null;
    final isCorrect = answered && option == correct;
    final isIncorrect = answered && option == _selected && !isCorrect;
    final accent = isCorrect
        ? const Color(0xFF13764B)
        : isIncorrect
        ? const Color(0xFFB32641)
        : studyPurple;
    final background = isCorrect
        ? const Color(0xFFCDEEDC)
        : isIncorrect
        ? const Color(0xFFFAD5DC)
        : Colors.white;
    return StudyCard(
      backgroundColor: background,
      child: InkWell(
        onTap: answered ? null : () => setState(() => _selected = option),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            spacing: 12,
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  ['A', 'B', 'C', 'D'][index],
                  style: TextStyle(color: accent, fontWeight: FontWeight.w800),
                ),
              ),
              Expanded(
                child: Text(
                  option,
                  style: const TextStyle(
                    color: studyInk,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (isCorrect || isIncorrect)
                Icon(
                  isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: accent,
                  semanticLabel: isCorrect
                      ? 'Correct answer'
                      : 'Incorrect answer',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
