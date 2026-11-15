import 'package:english_app/models/vocabulary_model.dart';
import 'package:english_app/presentation/ui/page/widgets/study_card.dart';
import 'package:flutter/material.dart';

class VocabularyItem extends StatelessWidget {
  const VocabularyItem({super.key, required this.vocabulary});

  final VocabularyModel vocabulary;

  @override
  Widget build(BuildContext context) {
    return ExpandableStudyCard(
      id: vocabulary.id.toString(),
      title: vocabulary.title,
      detailBuilder: (context) => Column(
        children: [
          for (var i = 0; i < vocabulary.words.length; i++) ...[
            _buildWord(i),
            if (i < vocabulary.words.length - 1)
              const Divider(height: 1, thickness: 1, color: Color(0xFFF0E9F8)),
          ],
        ],
      ),
    );
  }

  Widget _buildWord(int index) {
    final item = vocabulary.words[index];
    final wordStyle = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: Color(0xFF26163F),
    );
    final detailStyle = const TextStyle(fontSize: 15, color: Color(0xFF484052));
    final posStyle = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: Color(0xFF3264B5),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Row(
            spacing: 10,
            children: [
              Text(item.word, style: wordStyle),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFE5EEFF),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(item.pos, style: posStyle),
              ),
              const Spacer(),
              Text(item.phonetic, style: detailStyle),
            ],
          ),
          Text(item.definition, style: detailStyle),
          Text(item.detail, style: detailStyle),
        ],
      ),
    );
  }
}
