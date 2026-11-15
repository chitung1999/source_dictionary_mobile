class NoteModel {
  const NoteModel({required this.id, required this.title, required this.notes});

  final String id;
  final String title;
  final String notes;

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
    id: json['id'].toString(),
    title: json['title'] as String? ?? '',
    notes: json['notes'] as String? ?? '',
  );
}
