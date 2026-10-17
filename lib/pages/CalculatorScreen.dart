// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names, file_names, unused_import, avoid_print, dead_code, unused_local_variable

import 'package:calculator/pages/Button_Values.dart';
import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<Calculator> {
  String num1 = "";
  String operator = "";
  String num2 = "";

  @override
  Widget build(BuildContext context) {
    final ScreenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "$num1$operator$num2".isEmpty
                          ? "0"
                          : "$num1 $operator $num2",
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ),
              Wrap(
                children: Bottoms.buttonValues
                    .map(
                      (value) => SizedBox(
                          width: value == Bottoms.n0
                              ? ScreenSize.width / 2
                              : (ScreenSize.width / 4),
                          height: ScreenSize.width / 5,
                          child: buildButtom(value)),
                    )
                    .toList(),
              )
            ],
          )),
    );
  }

  Widget buildButtom(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: GetBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(500),
          borderSide: BorderSide(color: Colors.white24),
        ),
        child: InkWell(
            onTap: () => OnBtnTap(value),
            child: Center(
                child: Container(
              alignment: Alignment.center,
              child: Text(
                value,
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 38,
                    fontFamily: "myfont",
                    fontWeight: FontWeight.bold),
              ),
            ))),
      ),
    );
  }

  void OnBtnTap(String value) {
    if (value == Bottoms.del) {
      Delete();
      return;
    }

    if (value == Bottoms.clr) {
      Clear();
      return;
    }

    if (value == Bottoms.per) {
      Persentage();
      return;
    }

    if (value == Bottoms.calculate) {
      Calculate();
      return;
    }

    AppendValue(value);
  }

  void Delete() {
    if (num2.isNotEmpty) {
      num2 = num2.substring(0, num2.length - 1);
    } else if (operator.isNotEmpty) {
      operator = "";
    } else if (num1.isNotEmpty) {
      num1 = num1.substring(0, num1.length - 1);
    }

    setState(() {});
  }

  void Clear() {
    setState(() {
      num1 = "";
      operator = "";
      num2 = "";
    });
  }

  void Persentage() {
    if (num1.isNotEmpty && operator.isNotEmpty && num2.isNotEmpty) {
      Calculate();
    }

    if (operator.isNotEmpty) {
      return;
    }

    final no1 = double.parse(num1);
    setState(() {
      num1 = "${(no1 / 100)}";
      operator = "";
      num2 = "";
    });
  }

  void Calculate() {
    if (num1.isEmpty) return;
    if (operator.isEmpty) return;
    if (num2.isEmpty) return;

    double number1 = double.parse(num1);
    double number2 = double.parse(num2);

    var result = 0.0;
    switch (operator) {
      case Bottoms.add:
        result = number1 + number2;
        break;

      case Bottoms.multiply:
        result = number1 * number2;
        break;

      case Bottoms.subtract:
        result = number1 - number2;
        break;

      case Bottoms.divide:
        result = number1 / number2;
        break;

      default:
    }
    setState(() {
      num1 = "$result";

      if (num1.endsWith(".0")) {
        num1 = num1.substring(0, num1.length - 2);
      }

      operator = "";
      num2 = "";
    });
  }

  void AppendValue(String value) {
    if (value != Bottoms.dot && int.tryParse(value) == null) {
      if (operator.isNotEmpty && num2.isNotEmpty) {}
      operator = value;
    } else if (num1.isEmpty || operator.isEmpty) {
      if (value == Bottoms.dot && num1.contains(Bottoms.dot)) {
        return;
      }
      if (value == Bottoms.dot && (num1.isEmpty || num1 == Bottoms.dot)) {
        value = "0.";
      }
      num1 += value;
    } else if (num2.isEmpty || operator.isNotEmpty) {
      if (value == Bottoms.dot && num2.contains(Bottoms.dot)) {
        return;
      }
      if (value == Bottoms.dot && (num2.isEmpty || num2 == Bottoms.dot)) {
        value = "0.";
      }
      num2 += value;
    }
    setState(() {});
  }

  Color GetBtnColor(value) {
    return [
      Bottoms.del,
      Bottoms.clr,
      Bottoms.per,
      Bottoms.multiply,
      Bottoms.add,
      Bottoms.subtract,
      Bottoms.divide,
    ].contains(value)
        ? Color.fromARGB(255, 128, 127, 127)
        : [
            Bottoms.calculate,
          ].contains(value)
            ? Colors.blue
            : Colors.black87;
  }
}
