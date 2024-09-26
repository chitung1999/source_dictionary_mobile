import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'config_app.dart';
import 'word_model.dart';
import 'grammar_model.dart';
import '../common/enum.dart';

Database database = Database();

class Database {
  final ConfigApp configApp = ConfigApp();
  final WordModel wordModel = WordModel();
  final GrammarModel grammarModel = GrammarModel();

  Database._internal();
  static final Database _instance = Database._internal();
  factory Database() {
    return _instance;
  }

  Future<Map<String, dynamic>> readFileLocal() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/dictionary_database.json');
      final data = await file.readAsString();
      return jsonDecode(data);
    } catch(e) {
      print('Fail to read file local: $e');
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
      print('Fail to write file local: $e');
      return false;
    }
  }

  Future<StatusApp> initialize() async {
    try {
      Map<String, dynamic> data = await readFileLocal();
      if(data.isEmpty) {
        data = await getDefaultData();
        await writeFileLocal(data);
      }

      wordModel.loadData(data["words"]);
      configApp.loadData(data["config"]);
      grammarModel.loadData(data["grammar"]);
      return StatusApp.RUN_APP_SUCCESS;
    } catch(e) {
      print('Fail to initialize app: $e');
      return StatusApp.RUN_APP_FAIL ;
    }
  }

  Future<Map<String, dynamic>> getDefaultData() async {
    try {
      final String strDefault = await rootBundle.loadString('data/default_data.json');
      Map<String, dynamic> data = jsonDecode(strDefault);
      return data;
    } catch (e) {
      print('Fail to get default data: $e');
      return {};
    }
  }

  //Setting
  Future<bool> setAccount(String u, String p) async {
    try {
      if(configApp.username != u || configApp.password != p) {
        Map<String, dynamic> data = await readFileLocal();
        data['config']['username'] = u;
        data['config']['password'] = p;
        bool ret = await writeFileLocal(data);
        if(!ret) {
          return false;
        }
        configApp.loadData(data["config"]);
      }
      return true;
    } catch(e) {
      print('Fail to set account: $e');
      return false;
    }
  }

  Future<bool> setTheme(bool value) async {
    try {
      Map<String, dynamic> data = await readFileLocal();
      data['config']['theme'] = value ? 1 : 0;
      writeFileLocal(data);
      bool ret = await writeFileLocal(data);
      if(!ret) {
        return false;
      }
      configApp.loadData(data["config"]);
      return true;
    } catch(e) {
      print('Fail to set theme: $e');
      return false;
    }
  }

  //Home
  Future<StatusApp> addGroup(List<String> keys, List<String> means, String note) async {
    try {
      Map<String, dynamic> data = await readFileLocal();
      final Map<String, dynamic> newGroup = {
        "keys": keys,
        "means": means,
        "notes": note
      };

      data["words"].add(newGroup);
      bool ret = await writeFileLocal(data);
      if(!ret) {
        return StatusApp.ERROR;
      };
      wordModel.loadData(data["words"]);
      return StatusApp.ADD_WORD_SUCCESS;
    } catch(e) {
      print('Fail to add new group: $e');
      return StatusApp.ERROR;
    }
  }

  Future<StatusApp> modifyGroup(List<String> keys, List<String> means, String note, int index) async {
    try {
      Map<String, dynamic> data = await readFileLocal();

      final Map<String, dynamic> newGroup = {
        "keys": keys,
        "means": means,
        "notes": note
      };

      data["words"][index] = newGroup;
      bool ret = await writeFileLocal(data);
      if(!ret) {
        return StatusApp.ERROR;
      };
      wordModel.loadData(data["words"]);
      return StatusApp.ADD_GRAMMAR_SUCCESS;
    } catch(e) {
      print('Fail to modify group: $e');
      return StatusApp.ERROR;
    }
  }

  Future<StatusApp> removeGroup(int index) async {
    try {
      Map<String, dynamic> data = await readFileLocal();

      data["words"].removeAt(index);
      bool ret = await writeFileLocal(data);
      if(!ret) {
        return StatusApp.ERROR;
      };
      wordModel.loadData(data["words"]);
      return StatusApp.REMOVE_WORD_SUCCESS;
    } catch(e) {
      print('Fail to remove group: $e');
      return StatusApp.ERROR;
    }
  }

  //Grammar
  Future<StatusApp> addGrammar(String form, String structure) async {
    try {
      Map<String, dynamic> data = await readFileLocal();

      final Map<String, dynamic> newGrammar = {
        "form": form,
        "structure": structure
      };

      data["grammar"].add(newGrammar);
      bool ret = await writeFileLocal(data);
      if(!ret) {
        return StatusApp.ERROR;
      };
      grammarModel.loadData(data["grammar"]);
      return StatusApp.ADD_GRAMMAR_SUCCESS;
    } catch(e) {
      print('Fail to add new grammar: $e');
      return StatusApp.ERROR;
    }
  }

  Future<StatusApp> modifyGrammar(String form, String structure, int index) async {
    try {
      Map<String, dynamic> data = await readFileLocal();

      final Map<String, dynamic> newGrammar = {
        "form": form,
        "structure": structure
      };

      data["grammar"][index] = newGrammar;
      bool ret = await writeFileLocal(data);
      if(!ret) {
        return StatusApp.ERROR;
      };
      grammarModel.loadData(data["grammar"]);
      return StatusApp.MODIFY_GRAMMAR_SUCCESS;
    } catch(e) {
      print('Fail to modify grammar: $e');
      return StatusApp.ERROR;
    }
  }

  Future<StatusApp> removeGrammar(int index) async {
    try {
      Map<String, dynamic> data = await readFileLocal();

      data["grammar"].removeAt(index);
      bool ret = await writeFileLocal(data);
      if(!ret) {
        return StatusApp.ERROR;
      };
      grammarModel.loadData(data["grammar"]);
      return StatusApp.REMOVE_GRAMMAR_SUCCESS;
    } catch(e) {
      print('Fail to remove grammar: $e');
      return StatusApp.ERROR;
    }
  }

  // Server
  Future<bool> receiveDataFromServer(var words, var grammar) async {
    try {
      Map<String, dynamic> dataLocal = await readFileLocal();
      dataLocal["words"] = words;
      dataLocal["grammar"] = grammar;

      bool ret = await writeFileLocal(dataLocal);
      if (!ret) {
        return false;
      };
      wordModel.loadData(dataLocal["words"]);
      grammarModel.loadData(dataLocal['grammar']);

      return true;
    } catch (e) {
      print('Fail to receive data from sever: $e');
      return false;
    }
  }

  Future<StatusApp> importData(String path) async {
    try {
      final file = File(path);
      final strData = await file.readAsString();
      Map<String, dynamic> data = jsonDecode(strData);

      bool ret = await receiveDataFromServer(data["words"], data["grammar"]);
      return ret ? StatusApp.IMPORT_SUCCESS : StatusApp.ERROR;
    } catch (e) {
      print('Fail to import data from file local: $e');
      return StatusApp.ERROR;
    }
  }

  Future<StatusApp> exportData(String path, String data) async {
    try {
      var storageStatus = await Permission.storage.status;
      var manageStorageStatus = await Permission.manageExternalStorage.status;

      if (!storageStatus.isGranted) {
        storageStatus = await Permission.storage.request();
      }
      if (storageStatus.isDenied || storageStatus.isPermanentlyDenied) {
        manageStorageStatus = Platform.isIOS ? await Permission.photos.request() :await Permission.manageExternalStorage.request();
      }

      if(storageStatus.isGranted || manageStorageStatus.isGranted) {
        final file = File(path);
        await file.writeAsString(data);
        return StatusApp.EXPORT_SUCCESS;
      }

      return StatusApp.ERROR;
    } catch(e) {
      print('Fail to export data to file: $e');
      return StatusApp.ERROR;
    }
  }
}