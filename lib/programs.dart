import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Programs extends StatefulWidget {
  const Programs({super.key});

  @override
  State<Programs> createState() => _ProgramsState();
}

class _ProgramsState extends State<Programs>
    with AutomaticKeepAliveClientMixin {
  final myController = TextEditingController();
  List<FileSystemEntity> programs = [];
  List<String> test = ["one", "two", "three", "four", "five"];

  @override
  void initState() {
    getFiles();
    super.initState();
  }

  Future<File> _createFile(String fileName) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    File file = File('$path$fileName.txt');
    return await file.create();
  }

  void addToTest(String string) {
    test.add(string);
  }

  void getFiles() async {
    Directory directory = await getApplicationDocumentsDirectory();
    programs = directory.listSync();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Your Assembly Programs'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _showDialog();
          },
        ),
        body: ListView.builder(
            itemCount: programs.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(title: Text(programs[index].path)),
              );
            }),
      ),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter a file name",
                ),
                controller: myController,
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("Create"),
                  onPressed: () {
                    Navigator.pop(context);
                    // Create .txt file with name specified in TextFormField
                    _createFile(myController.text);
                    //addToTest(myController.text);
                    setState(() {});
                    myController.clear();
                  },
                )
              ]);
        });
  }

  @override
  bool get wantKeepAlive => true;
}
