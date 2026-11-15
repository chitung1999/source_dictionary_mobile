import 'package:english_app/models/vocabulary_model.dart';
import 'package:flutter/material.dart';

class VocabularyItem extends StatefulWidget {
  const VocabularyItem({super.key, required this.vocabulary});

  final VocabularyModel vocabulary;

  @override
  State<VocabularyItem> createState() => _VocabularyItemState();
}

class _VocabularyItemState extends State<VocabularyItem> {
  bool _isExpanded = false;
  static const _purple = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _purple.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE5D5FA)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: _isExpanded
                  ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    for (var i = 0; i < widget.vocabulary.words.length; i++) ...[
                      _buildWord(i),
                      if (i < widget.vocabulary.words.length - 1)
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFF0E9F8),
                        ),
                    ],
                  ],
                ),
              )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Semantics(
      button: true,
      expanded: _isExpanded,
      child: Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF3EAFF),
              Color(0xFFFAF6FF),
            ],
          ),
        ),
        child: InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              spacing: 10,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6D5FC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.vocabulary.id.toString().padLeft(2, '0'),
                    style: TextStyle(
                      color: _purple,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  widget.vocabulary.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF26163F),
                  ),
                ),
                const Spacer(),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: _purple,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWord(int index) {
    final item = widget.vocabulary.words[index];
    final wordStyle = const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF26163F));
    final detailStyle = const TextStyle(fontSize: 15, color: Color(0xFF484052));
    final posStyle = const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF3264B5));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Row(
            spacing: 10,
            children: [
              Text(
                item.word,
                style: wordStyle,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Color(0xFFE5EEFF),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  item.pos,
                  style: posStyle,
                ),
              ),
              const Spacer(),
              Text(
                item.phonetic,
                style: detailStyle,
              ),
            ],
          ),
          Text(
            item.definition,
            style: detailStyle,
          ),
          Text(
            item.detail,
            style: detailStyle,
          ),
        ],
      ),
    );
  }
}