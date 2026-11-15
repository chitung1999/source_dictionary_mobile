class WordModel {
  final int id;
  final String word;
  final String phonetic;
  final String pos;
  final String definition;
  final String detail;

  const WordModel({
    required this.id,
    required this.word,
    required this.phonetic,
    required this.pos,
    required this.definition,
    required this.detail,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      id: json['id'] as int,
      word: json['word'] as String,
      phonetic: json['phonetic'] as String,
      pos: json['pos'] as String,
      definition: json['definition'] as String,
      detail: json['detail'] as String,
    );
  }
}