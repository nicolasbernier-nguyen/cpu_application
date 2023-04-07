import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'formatter/maxLinesFormatter.dart';

class Edit extends StatefulWidget {
  const Edit({super.key});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> with AutomaticKeepAliveClientMixin {
  final int maxLines = 16;
  final inputController = TextEditingController();
  final outputController = TextEditingController();
  static const platform = MethodChannel('assembler');

  Future<File> get _programFile async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}program.txt';
    if (!await File(path).exists()) {
      return await File(path).create();
    } 
    else {
      return File(path);
    }
  }

  Future<File> _saveToFile(String fileContent) async {
    final file = await _programFile;
    return file.writeAsString(fileContent);
  }

  Future<String> _assembleProgram() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}program.txt';

    try {
      final String result = await platform.invokeMethod('assembleProgram', {"path":path});
      return result;
    } on PlatformException catch (e) {
      if (e.message!.contains("FileNotFoundException")) {
        const String result = "Assembled code will output here";
        return result;
      }
      else {
        final String result = "Failed to assemble program: ${e.message}";
        return result;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
        home: GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text("Write Your Assembly Program!"),
          ),
          body: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              // Input textfield
              Builder(builder: (context) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Container(
                    height: maxLines * 14.8,
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      controller: inputController,
                      textAlignVertical: TextAlignVertical.top,
                      expands: true,
                      maxLines: null,
                      minLines: null,
                      decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                        labelText: 'Enter your assembly code here',
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      keyboardType: TextInputType.multiline,
                      inputFormatters: [
                        MaxLinesFormatter(maxLines, () {
                          showSnackBar(context,
                              'Maximum program length is $maxLines lines');
                        })
                      ],
                    ),
                  ),
                );
              }),
              // Output text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                  height: maxLines * 16.0,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  child: FutureBuilder<String>(
                    future: _assembleProgram(),
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Text('Loading ...');
                      }
                      if (snapshot.hasError) { 
                        return const Text("{snapshot.error}");
                      }
                      if (snapshot.hasData) {
                        return SingleChildScrollView(
                          child: Text(snapshot.data!, style: const TextStyle(fontSize: 18),),
                        );
                      }
                      return const Text('Assembled code will be here');
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 17.4, vertical: 30.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 50),
                  ),
                  onPressed: () {
                    // save textfield input to .txt file
                    _saveToFile(inputController.text);
                    // invoque assembler method channel
                    _assembleProgram();
                    setState(() {
                      
                    });

                  },
                  child: const Text("ASSEMBLE"),
                ),
              ),
            ],
          )),
    ));
  }

  @override
  bool get wantKeepAlive => true;

  void showSnackBar(BuildContext context, String s) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
  }
}
