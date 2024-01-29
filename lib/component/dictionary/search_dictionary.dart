import 'package:flutter/material.dart';
import 'package:source_dictionary_mobile/component/dictionary/api_service.dart';
import 'package:source_dictionary_mobile/component/dictionary/dictionary_item.dart';


class SearchDictionary extends SearchDelegate {
  final DictionaryAPI _dictionaryAPI = DictionaryAPI();
  DictionaryItem? _item;

  Future<void> _getData() async {
    if (query.isNotEmpty) {
      final List<dynamic> data = await _dictionaryAPI.requestAPI(query);
      if (data.isNotEmpty) {
        _item = DictionaryItem.fromJson(data[0]);
        query = '';
      }
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: _getData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return const CircularProgressIndicator();
          return const Center(child: CircularProgressIndicator());
        } else {
          return Container(height: 1000, width: 400,
              child: Text('${_item!.word}${_item!.phonetic}'));
            // Text(_phonetic);
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}