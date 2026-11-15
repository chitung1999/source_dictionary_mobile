import 'package:flutter/material.dart';

const studyPurple = Color(0xFF7C3AED);
const studyInk = Color(0xFF26163F);
const studyBorder = Color(0xFFE5D5FA);
const studyHeader = LinearGradient(
  colors: [Color(0xFFF3EAFF), Color(0xFFFAF6FF)],
);

class StudyCard extends StatelessWidget {
  const StudyCard({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
  });

  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: studyPurple.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: backgroundColor,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: const BorderSide(color: studyBorder),
        ),
        child: child,
      ),
    );
  }
}

class ExpandableStudyCard extends StatefulWidget {
  const ExpandableStudyCard({
    super.key,
    required this.id,
    required this.title,
    required this.detailBuilder,
  });

  final String id;
  final String title;
  final WidgetBuilder detailBuilder;

  @override
  State<ExpandableStudyCard> createState() => _ExpandableStudyCardState();
}

class _ExpandableStudyCardState extends State<ExpandableStudyCard> {
  static const _duration = Duration(milliseconds: 250);
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return StudyCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            button: true,
            expanded: _expanded,
            child: Ink(
              decoration: const BoxDecoration(gradient: studyHeader),
              child: InkWell(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    spacing: 10,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6D5FC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.id.padLeft(2, '0'),
                          style: const TextStyle(
                            color: studyPurple,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            color: studyInk,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: _duration,
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: studyPurple,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: _duration,
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _expanded
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: widget.detailBuilder(context),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
