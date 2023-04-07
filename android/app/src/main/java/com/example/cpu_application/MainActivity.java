package com.example.cpu_application;

import androidx.annotation.NonNull;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;
import java.util.Scanner;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    static final String CHANNEL = "assembler";
    private MethodChannel channel;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        BinaryMessenger binaryMessenger = flutterEngine.getDartExecutor().getBinaryMessenger();
        channel = new MethodChannel(binaryMessenger, CHANNEL);
        channel.setMethodCallHandler((call, result) -> {
            if (call.method.equals("assembleProgram")) {
                String hexCode = null;
                String path = call.argument("path");
                try {
                    hexCode = assembleProgram(path);
                } catch (FileNotFoundException e) {
                    throw new RuntimeException(e);
                }

                if (!Objects.equals(hexCode, "")) {
                    result.success(hexCode);
                }
                else {
                    result.error("ERROR", "Invalid program", null);
                }
            }
            else {
                result.notImplemented();
            }
        });
    }

    static boolean checkOpcode(String opcode) {
        return opcode.equals("ADD") || opcode.equals("SUB") || opcode.equals("MUL") || opcode.equals("XOR") || opcode.equals("AND") || opcode.equals("OR") || opcode.equals("BEQ") || opcode.equals("BLT") || opcode.equals("BGE") || opcode.equals("BNE") || opcode.equals("LD") || opcode.equals("ST") || opcode.equals("MV") || opcode.equals("BAL");
    }
    static String operandToBin (String operand) {
        String bin = "";
        switch (operand) {
            case "ADD":
                bin = "0000";
                break;
            case "SUB":
                bin = "0001";
                break;
            case "MUL":
                bin = "0010";
                break;
            case "XOR":
                bin = "0011";
                break;
            case "AND":
                bin = "0100";
                break;
            case "OR":
                bin = "0101";
                break;
            case "BEQ":
                bin = "11000";
                break;
            case "BLT":
                bin = "11001";
                break;
            case "BGE":
                bin = "11010";
                break;
            case "BNE":
                bin = "11011";
                break;
            case "LD":
                bin = "1100";
                break;
            case "ST":
                bin = "0110";
                break;
            case "MV":
                bin = "0111";
                break;
            case "BAL":
                bin = "11110";
                break;
            case "R0":
                bin = "000";
                break;
            case "R1":
                bin = "001";
                break;
            case "R2":
                bin = "010";
                break;
            case "R3":
                bin = "011";
                break;
            case "R4":
                bin = "100";
                break;
            case "R5":
                bin = "101";
                break;
            case "R6":
                bin = "110";
                break;
            case "R7":
                bin = "111";
                break;
            default:
                return bin;
        }
        return bin;
    }
    static String binToHex(String bin) {
        int decimal = Integer.parseInt(bin, 2);
        String hex = Integer.toString(decimal,16);
        return String.format("%4s", hex).replace(" ", "0").toUpperCase();
    }
    static boolean checkImm(String value) {
        return value.matches("-?\\d+");
    }
    public String assembleProgram(String path) throws FileNotFoundException {
        Scanner inputScanner = new Scanner(new File(path));
        String instruction; // Current instruction
        ArrayList<ArrayList<String>> code = new ArrayList<ArrayList<String>>(); // Code from file copied to dynamic array
        HashMap<String, Integer> labels = new HashMap<String, Integer>(); // KV pairs of labels and index
        List<String> binary = new ArrayList<String>(); // Assembly code converted to binary
        HashMap<Integer, String> immIndex = new HashMap<Integer, String>(); // Index of imm values
        StringBuilder hexCode = new StringBuilder(); // Assembled code
        int index =0;

        // Read file and tokenize instructions into array
        while (inputScanner.hasNextLine()) {
            instruction = inputScanner.nextLine();
            String[] line = instruction.split("[\\r\\n, ]+",-1);
            code.add(new ArrayList<String>());
            for (String s : line) {
                code.get(index).add(s.toUpperCase());
            }
            index++;
        }

        // Locate labels and save them in hashmap with label name and index pairs
        // Locate imm values and store in hashmap with index and binary value pairs
        for (int i=0; i<code.size(); i++) {
            if (!checkOpcode(code.get(i).get(0))) {
                if (checkOpcode(code.get(i).get(1)))
                    labels.put(code.get(i).get(0), i);
                else
                    System.out.println("Invalid opcode at line " + i);
                // Terminate code on invalid opcode
            }
            for (int j=2; j<code.get(i).size(); j++) {
                if (checkImm(code.get(i).get(j)))
                    immIndex.put(i, Integer.toBinaryString(Integer.parseInt(code.get(i).get(j))));
            }
        }

        // Traverse entire code and convert to binary store in binary list
        for (int i=0; i<code.size(); i++) {
            String op;
            StringBuilder binaryString = new StringBuilder();

            for (int j=0; j<code.get(i).size(); j++) {
                op = operandToBin(code.get(i).get(j));

                // Check if the returned binary is for an opcode
                // ** NOTE branching opcodes are hardcoded with their imm bit **
                if (op.length() == 4) {
                    if (immIndex.containsKey(i))
                        binaryString.insert(0, "1" + op);
                    else
                        binaryString.insert(0, "0" + op);
                }
                // Check if the returned binary is empty => imm value or label
                else if (j>0 && op.equals("")) {
                    if (labels.containsKey(code.get(i).get(j))) {
                        int offset = labels.get(code.get(i).get(j)) - i;
                        binaryString.insert(0, Integer.toBinaryString(offset));
                    }
                    else if (immIndex.containsKey(i))
                        binaryString.insert(0, immIndex.get(i));
                }
                else
                    binaryString.insert(0, op);
            }
            binary.add(binaryString.toString());
        }

        // Pad binary strings with '0' or cut to 16 char and convert to hex
        for (int i=0; i<binary.size(); i++) {
            if (binary.get(i).length() > 16) {
                binary.set(i, binary.get(i).substring(binary.get(i).length()-16, binary.get(i).length()));
            }
            else {
                binary.set(i, String.format("%16s", binary.get(i)).replace(" ", "0"));
            }
            hexCode.append(binToHex(binary.get(i))).append("\n");
        }

        return hexCode.toString();
    }
}
