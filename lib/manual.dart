import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Manual extends StatefulWidget {
  const Manual({super.key});

  @override
  State<Manual> createState() => _ManualState();
}

class _ManualState extends State<Manual> with AutomaticKeepAliveClientMixin {
  final String _markdownData = """
  # Programmer's Manual
  ---
  The programmer's manual holds all instruction mnemonics and the syntax to follow when writing your assembly program in the **Program** tab.

  ㅤ
  ## Syntax
  ---
  Instruction are made of the following fields: the **opcode**, the **operands** and sometimes a **label**. These fields must follow a specific syntax.
  
  ㅤ
  ### Operands
  The operands are the registers, immediate values and labels. Registers are referred in the following manner:
  * **r#**, where **#** is a number from 0 to 7
  
  ㅤ


  Immediate values, which can be positive or negative numbers, have varying ranges depending on the instruction. They are written in the following manner:
  * **#** or **-#**, where **#** is a decimal number
  * Registers and the data cache can store numbers from -128 to 127
  * The data cache only has 16 addresses. Thus, memory addresses range from 0 to 15
  
  ㅤ

  Labels are whichever word you decided to use. It is to be noted that you **CANNOT** use opcodes as labels. Labels go before the opcode in the following manner:
  ```
  LOOP  ADD r0, r1, r2
  ``` 

  ㅤ

  ### Writing an instruction
  When writing your instruction, make sure to separate your labels, opcodes and operands with some sort of delimiter. By convention, separate your **label** and your **opcode** with a space, your **opcode** and its first **operand** with a space, and subsequent **operands** with a comma, just as in the example below.
  
  ```
  LABEL ADD r1, r2, -4
  ```
  ㅤ

  **NOTE** do not end your program on a new line. Keep the cursor at the end of your final instruction.
  
  ㅤ
  ## Assembly Mnemonics
  ---
  ### Arithmetics
  |Basic Instruction|Meaning|
  |----------------:|:-----:|
  |**ADD**   rd, rs1, rs2|Add the contents of *rs2* to *rs1* and store in *rd*|
  |**ADD**   rd, rs1, imm|Add the immediate value *imm* to the contents of *rs1* and store in *rd*|
  |**SUB**   rd, rs1, rs2|Subtract the contents of *rs2* to *rs1* and store in *rd*|
  |**SUB**   rd, rs1, imm|Subtract the immediate value *imm* to the contents of *rs1* and store in *rd*|
  |**MUL**   rd, rs1, rs2|Multiply the contents of *rs2* to *rs1* and store in *rd*|
  |**MUL**   rd, rs1, imm|Multiply the immediate value *imm* to the contents of *rs1* and store in *rd*|
  |**XOR**   rd, rs1, rs2|XOR the contents of *rs2* to *rs1* and store in *rd*|
  |**XOR**   rd, rs1, imm|XOR the immediate value *imm* to the contents of *rs1* and store in *rd*|
  |**AND**   rd, rs1, rs2|AND the contents of *rs2* to *rs1* and store in *rd*|
  |**AND**   rd, rs1, imm|AND the immediate value *imm* to the contents of *rs1* and store in *rd*|
  |**OR**   rd, rs1, rs2|OR the contents of *rs2* to *rs1* and store in *rd*|
  |**OR**   rd, rs1, imm|OR the immediate value *imm* to the contents of *rs1* and store in *rd*|
  
  ㅤ
  ### Branching
  |Basic Instruction|Meaning|
  |----------------:|:-----:|
  |**BEQ**   rd, rs2, label|Branch to *label* if rs1 is equal to rs2|
  |**BLT**   rd, rs2, label|Branch to *label* if rs1 is less than rs2|
  |**BGE**   rd, rs2, label|Branch to *label* if rs1 is greater than or equal to rs2|
  |**BNE**   rd, rs2, label|Branch to *label* if rs1 is not equal to rs2|
  |**BEQ**   rd, rs2, label|Unconditionally branch to *label*|
  
  ㅤ
  ### Data Manipulation
  |Basic Instruction|Meaning|
  |----------------:|:-----:|
  |**LD**   rd, imm|Load value from address specified by *imm* into *rd*|
  |**LD**   rd, rs2|Load value from address specified by the contents of *rs2* into *rd*|
  |**ST**   rs1, imm|Store the contents of *rs1* into memory at the address specified by *imm*|
  |**ST**   rs1, rs2|Store the contents of *rs1* into memory at the address specified by the contents of *rs2*|
  |**MV**   rd, imm|Copy the immediate value *imm* into *rd*|
  |**MV**   rd, rs1|Copy the contents of *rs1* into *rd*|
  """;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Programmer's Manual"),
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
          h3: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
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
    )));
  }

  @override
  bool get wantKeepAlive => true;
}
