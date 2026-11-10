import 'package:flutter/material.dart';

class VocabularyItem extends StatefulWidget {
  const VocabularyItem({super.key});

  @override
  State<VocabularyItem> createState() => _VocabularyItemState();
}

class _VocabularyItemState extends State<VocabularyItem> {
  bool _isExpanded = false;

  static const _purple = Color(0xFF7C3AED);
  static const _border = Color(0xFFE5D5FA);
  static const _text = Color(0xFF26163F);

  static const _words = [
    (
    word: 'Product',
    type: 'N',
    ipa: '/ˈprɒd.ʌkt/',
    meaning: 'Sản phẩm',
    ),
    (
    word: 'Produce',
    type: 'V',
    ipa: '/prəˈdjuːs/',
    meaning: 'Sản xuất, tạo ra',
    ),
    (
    word: 'Produce',
    type: 'N',
    ipa: '/ˈprɒd.juːs/',
    meaning: 'Nông sản, rau củ quả',
    ),
    (
    word: 'Production',
    type: 'N, V',
    ipa: '/prəˈdʌk.ʃən/',
    meaning: 'Sự sản xuất, quá trình sản xuất',
    ),
    (
    word: 'Producer',
    type: 'N',
    ipa: '/prəˈdjuː.sər/',
    meaning: 'Nhà sản xuất',
    ),
    (
    word: 'Productive',
    type: 'Adj',
    ipa: '/prəˈdʌk.tɪv/',
    meaning: 'Có năng suất, hiệu quả',
    ),
    (
    word: 'Productivity',
    type: 'N',
    ipa: '/ˌprɒd.ʌkˈtɪv.ə.ti/',
    meaning: 'Năng suất',
    ),
  ];

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
          side: const BorderSide(color: _border),
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
                    for (var i = 0; i < _words.length; i++) ...[
                      _buildWord(i),
                      if (i < _words.length - 1)
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
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6D5FC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '01',
                    style: TextStyle(
                      color: _purple,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Product',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: _text,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${_words.length} mục từ',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF857393),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: _purple,
                    size: 28,
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
    final item = _words[index];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      item.word,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _text,
                      ),
                    ),
                    _buildTypeBadge(item.type),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  item.ipa,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Color(0xFF8A8096),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.meaning,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.45,
                    color: Color(0xFF484052),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // UI only: chưa tích hợp chức năng phát âm.
          Tooltip(
            message: 'Nghe phát âm — chưa tích hợp',
            child: Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF7FF),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: _border),
                ),
                child: const Icon(
                  Icons.volume_up_rounded,
                  color: _purple,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge(String type) {
    final (background, foreground) = switch (type) {
      'Verb (v)' => (
      const Color(0xFFFFE9DA),
      const Color(0xFFB65320),
      ),
      'Adjective (adj)' => (
      const Color(0xFFDDF6EB),
      const Color(0xFF187451),
      ),
      _ => (
      const Color(0xFFE5EEFF),
      const Color(0xFF3264B5),
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        type,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
      ),
    );
  }
}