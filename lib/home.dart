import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  final String _markdownData = """
  # Welcome to the Assembly Companion App!
  ---
  This small introductory guide will help you get started with our companion app, and guide you through writing your first assembly code!

  ㅤ
  ## Getting Started
  ---
  Using the app is very simple, there are three tabs: 
  * Home
  * Manual
  * Program

  **Home** serves as the introductory guide to the app. **Manual** holds the *programmer's manual*, and **Program** is where you write your assembly code and convert it to hexadecimal machine code.
  ㅤ

  To get started, copy and paste the following program into the textfield in the **Program** tab and press the *Assemble* button.
  ㅤ
  
  ```
  ADD R1,R2,R3

  to be completed
  ```
  ㅤ

  Congratulations! You can now use the provided hexadecimal to manually enter it into the instruction cache.

  If you wish to write your own assembly program, refer to the *programmer's manual* for a list of all instructions and the proper syntax.
  
  ㅤ

  **IMPORTANT** the assembler does not currently support syntax verification. As such, make sure your assembly code is correct and follows the syntax rules from the *programmer's manual*.
  """;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Home'),
      ),
      body: Markdown(
        data: _markdownData,
        selectable: true,
        styleSheet: MarkdownStyleSheet(
          h1: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
          h2: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          p: const TextStyle(
            fontSize: 18,
            height: 1.35,
          ),
          code: const TextStyle(
            fontSize: 16,

          ),
          textAlign: WrapAlignment.spaceBetween,
        ),
      ),
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
