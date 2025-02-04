import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = "";
  String _result = "";

  void _onButtonPressed(String value) {
    setState(() {
      if (value == "C") {
        _expression = "";
        _result = "";
      } else if (value == "=") {
        try {
          final exp = Expression.parse(_expression);
          final evaluator = const ExpressionEvaluator();
          final evalResult = evaluator.eval(exp, {});
          _result = " = $evalResult";
        } catch (e) {
          _result = " Error";
        }
      } else {
        _expression += value;
      }
    });
  }

  Widget _buildButton(String text, {Color color = const Color.fromARGB(255, 11, 11, 11)}) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(text),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(20),
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Simeon's Calculator")),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(16),
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: TextStyle(fontSize: 36, color: Colors.white),
                  ),
                  Text(
                    _result,
                    style: TextStyle(fontSize: 32, color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          Column(
            children: [
              _buildRow(["7", "8", "9", "/"]),
              _buildRow(["4", "5", "6", "*"]),
              _buildRow(["1", "2", "3", "-"]),
              _buildRow(["C", "0", "=", "+"]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((text) => _buildButton(text, color: _getButtonColor(text))).toList(),
    );
  }

  Color _getButtonColor(String text) {
    if (text == "C") return Colors.red;
    if (text == "=") return Colors.green;
    if (["+", "-", "*", "/"].contains(text)) return Colors.blue;
    return Colors.grey;
  }
}
