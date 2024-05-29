import 'package:flutter/material.dart';
import '../../../models/word_model.dart';

class SearchConfig {
  bool isSearch = false;
  String word = '';
  List<int> group = [];
}

class  SearchPage extends SearchDelegate<SearchConfig?> {
  final WordModel? data;
  final List<String> _listSearch = [];
  late SearchConfig _config;
  bool _isEng = true;

  SearchPage({required this.data});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      StatefulBuilder(builder: (thisLowerContext, StateSetter setState) {
        return TextButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          child: Text((_isEng ? 'EN' : 'VN')),
          onPressed: () { setState(() { _isEng = !_isEng; }); },
        );
      }),
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () { query = ''; },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          _config.isSearch = false;
          close(context, _config);
        }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _config.isSearch = true;
    _config.group = _listSearch.isEmpty ? []
         : (_isEng ? data!.key[_listSearch[0]]! : data!.mean[_listSearch[0]]!);
    _config.word = _listSearch[0];
    close(context, _config);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _listSearch.clear();
    for(String item in (_isEng ? data!.key.keys : data!.mean.keys)) {
      if(item.toLowerCase().contains(query.toLowerCase())){
        _listSearch.add(item);
      }
    }

    return Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
            itemCount: _listSearch.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_listSearch[index], style: const TextStyle(fontSize: 20),),
              );
            }
        )
    );
  }
}