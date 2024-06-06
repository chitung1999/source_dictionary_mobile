import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'config_app.dart';
import 'word_model.dart';

class Database {
  final ConfigApp _configApp = ConfigApp();
  final WordModel _wordModel = WordModel();

  Future<Map<String, dynamic>> readFileLocal() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/dictionary_database.json');
      final data = await file.readAsString();
      return jsonDecode(data);
    } catch(e) {
      return {};
    }
  }

  Future<bool> writeFileLocal(Map<String, dynamic> data) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/dictionary_database.json');
      final str = jsonEncode(data);
      await file.writeAsString(str);
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<void> initialize() async {
    try {
      Map<String, dynamic> data = await readFileLocal();
      if(data.isEmpty) {
        print('0');
        data = setDefaultData();
        print('1');
        print(data);
        await writeFileLocal(data);
        print('2');
        print(data);
      }
      Map<String, dynamic> data2 = await readFileLocal();
      print('3');
      print(data2);
       _wordModel.loadData(data["words"]);
      _configApp.loadData(data["config"]);
    } catch(e) {}
  }

  Map<String, dynamic> setDefaultData() {
    Map<String, dynamic> defaultData = {};

    defaultData["config"]["username"] = 'admin';
    defaultData["config"]["password"] = '1';
    defaultData["config"]["theme"] = 0;

    Map<String, dynamic> myMap = {};
    myMap["keys"] = 'my key';
    myMap["means"] = 'my mean';
    myMap["notes"] = 'my note';
    defaultData["words"].add(myMap);

    myMap = {};
    myMap["form"] = 'my form';
    myMap["structure"] = 'my structure';
    defaultData["grammar"].add(myMap);
    return defaultData;
  }

  //Setting
  Future<void> setAccount(String u, String p) async {
    try {
      if(_configApp.username != u || _configApp.password != p) {
        Map<String, dynamic> data = await readFileLocal();
        data['config']['username'] = u;
        data['config']['password'] = p;
        _configApp.loadData(data["config"]);
        writeFileLocal(data);
      }
    } catch(e) {}
  }

  Future<void> setTheme(bool value) async {
    try {
      Map<String, dynamic> data = await readFileLocal();
      data['config']['theme'] = value;
      _configApp.loadData(data["config"]);
      writeFileLocal(data);
    } catch(e) {}
  }

  //Home
  Future<void> addGroup(List<String> keys, List<String> means, String note) async {
    try {
      Map<String, dynamic> data = await readFileLocal();

      final Map<String, dynamic> newGroup = {
        "keys": keys,
        "means": means,
        "notes": note
      };

      data["words"].add(newGroup);
      _wordModel.loadData(data["words"]);
      writeFileLocal(data);
    } catch(e) {}
  }

  Future<void> modifyGroup(List<String> keys, List<String> means, String note, String query, bool isEng, int index) async {
    try {
      Map<String, dynamic> data = await readFileLocal();

      final Map<String, dynamic> newGroup = {
        "keys": keys,
        "means": means,
        "notes": note
      };
      List<int>? group = isEng ? _wordModel.eng[query] : _wordModel.vn[query];

      data["words"][group?[index]] = newGroup;
      _wordModel.loadData(data["words"]);
      writeFileLocal(data);
    } catch(e) {}
  }

  Future<void> removeGroup(String query, bool isEng, int index) async {
    try {
      Map<String, dynamic> data = await readFileLocal();

      List<int>? group = isEng ? _wordModel.eng[query] : _wordModel.vn[query];

      data["words"].removeAt(group?[index]);
      _wordModel.loadData(data["words"]);
      writeFileLocal(data);
    } catch(e) {}
  }

  Future<bool> uploadDataToServer() async {
    //implement yet
    return true;
  }

  Future<bool> getDataFromServer() async {
    try {
      final String dataSever = await rootBundle.loadString('data/data.json');
      Map<String, dynamic> data = jsonDecode(dataSever);
      _wordModel.loadData(data["words"]);
      writeFileLocal(data);
      return true;
    } catch (e) {
      return false;
    }
  }
}