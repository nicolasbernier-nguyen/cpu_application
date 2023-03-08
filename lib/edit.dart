import 'dart:math';

import 'package:cpu_application/formatter/maxLinesFormatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Edit extends StatefulWidget {
  const Edit({super.key});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> with AutomaticKeepAliveClientMixin {
  final int maxLines = 16;
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
              Builder(builder: (context) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Container(
                    height: maxLines * 14.8,
                    margin: const EdgeInsets.all(10),
                    child: TextField(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: Container(
                  height: maxLines * 16.0,
                  padding: const EdgeInsets.all(10),
                  child: const TextField(
                    textAlignVertical: TextAlignVertical.top,
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    enabled: false,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: "Assembled Code",
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    keyboardType: TextInputType.multiline,
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
                  onPressed: () {},
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
