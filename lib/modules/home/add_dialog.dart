import 'package:flutter/material.dart';
import '../../models/word_model.dart';

class AddDialog extends StatefulWidget {
  const AddDialog({Key? key}) : super(key: key);

  @override
  _AddDialogState createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  final WordModel _word = WordModel();
  List<TextEditingController> key = [];
  List<TextEditingController> mean = [];
  TextEditingController note = TextEditingController();

  void addWord() {
    List<String> addKey = key.map((controller) => controller.text).toList();
    List<String> addMean = mean.map((controller) => controller.text).toList();
    String addNote = note.text;
    reaData(addKey, addMean, addNote);
  }

  void reaData(List<String> addKey, List<String> addMean, String addNote) {
    print(addKey);
    print(addMean);
    print(addNote);
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 4; i++) {
      key.add(TextEditingController());
      mean.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (var controller in key) {
      controller.dispose();
    }
    for (var controller in mean) {
      controller.dispose();
    }
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Dialog( child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        child: Column(
          children: [
            Expanded(child: ListView( children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Key',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.playlist_add),
                    onPressed:(){
                      setState((){
                        key.add(TextEditingController());
                      });
                    },
                  ),
                ]
              ),

              for (int i = 0; i < key.length; i++)
                TextField(
                controller: key[i],
                decoration: InputDecoration(
                  labelText: 'Key ${i + 1}',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mean',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.playlist_add),
                    onPressed:(){
                      setState((){
                        mean.add(TextEditingController());
                      });
                    },
                  ),
                ]
              ),

              for (int i = 0; i < mean.length; i++)
                TextField(
                  controller: mean[i],
                  decoration: InputDecoration(
                    labelText: 'Mean ${i + 1}',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),

              const SizedBox(height: 20),
              const Text(
                'Note',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
              ),
              TextField(
                controller: note,
                decoration: const InputDecoration(
                  labelText: 'Note',
                  floatingLabelBehavior: FloatingLabelBehavior.never
                )
              )
            ])),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded( child: ElevatedButton(
                  onPressed: (){ Navigator.of(context).pop();},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                )),
                const SizedBox(width: 16),
                Expanded( child: ElevatedButton(
                  onPressed: () {
                    addWord();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom( backgroundColor: Colors.blueAccent),
                  child: const Text('OK', style: TextStyle(color: Colors.black)),
                ))
              ]
            )
          ]
        )
      ))
    );
  }
}