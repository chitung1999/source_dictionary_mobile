import 'package:english_app/core/db/supabase_service.dart';
import 'package:english_app/models/note_model.dart';
import 'package:english_app/presentation/ui/page/widgets/base_page.dart';
import 'package:english_app/presentation/ui/page/widgets/study_card.dart';
import 'package:english_app/presentation/ui/page/widgets/study_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _notesProvider = FutureProvider<List<NoteModel>>(
  (ref) => SupabaseService.instance.getNotes(),
);

class NotePage extends ConsumerStatefulWidget {
  const NotePage({super.key});

  @override
  ConsumerState<NotePage> createState() => _NotePageState();
}

class _NotePageState extends ConsumerState<NotePage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(_notesProvider);
    return BasePage(
      bannerPath: 'data/banner/note.png',
      child: Column(
        spacing: 20,
        children: [
          StudySearchField(
            hint: 'Search notes',
            onChanged: (text) => setState(() {
              _query = text.trim().toLowerCase();
            }),
          ),
          Expanded(
            child: notes.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: studyPurple),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Could not load notes.'),
                    TextButton(
                      onPressed: () => ref.invalidate(_notesProvider),
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
              data: _buildNotes,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotes(List<NoteModel> notes) {
    final filtered = notes.where((note) {
      return note.title.toLowerCase().contains(_query) ||
          note.notes.toLowerCase().contains(_query);
    }).toList();
    if (filtered.isEmpty) {
      return Center(
        child: Text(_query.isEmpty ? 'No notes yet.' : 'No matching notes.'),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: filtered.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final note = filtered[index];
        return ExpandableStudyCard(
          key: ValueKey(note.id),
          id: note.id,
          title: note.title,
          detailBuilder: (context) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                note.notes,
                style: const TextStyle(
                  color: Color(0xFF484052),
                  fontSize: 15,
                  height: 1.45,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
