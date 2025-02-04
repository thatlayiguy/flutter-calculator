import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(CalculatorApp());
}

// Main application widget
class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

// Stateful widget for the calculator screen
class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = ""; // Stores the current expression
  String _result = ""; // Stores the result of the expression

  // Handles button press events
  void _onButtonPressed(String value) {
    setState(() {
      if (value == "C") {
        // Clear the expression and result
        _expression = "";
        _result = "";
      } else if (value == "=") {
        // Evaluate the expression
        try {
          final exp = Expression.parse(_expression);
          final evaluator = const ExpressionEvaluator();
          final evalResult = evaluator.eval(exp, {});
          _result = " = $evalResult";
        } catch (e) {
          _result = " Error";
        }
      } else if (value == "x²") {
        // Evaluate the square of the expression
        try {
          if (_expression.isNotEmpty) {
            final exp = Expression.parse("($_expression) * ($_expression)");
            final evaluator = const ExpressionEvaluator();
            final evalResult = evaluator.eval(exp, {});
            _result = " = $evalResult";
            _expression = "($_expression)²";
          }
        } catch (e) {
          _result = " Error";
        }
      } else {
        // Append the value to the expression
        _expression += value;
      }
    });
  }

  // Builds a button widget
  Widget _buildButton(String text, {Color color = Colors.grey}) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(text),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(20),
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
          // Display for the expression and result
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
          // Buttons for the calculator
          Column(
            children: [
              _buildRow(["7", "8", "9", "/", "x²"]),
              _buildRow(["4", "5", "6", "*"]),
              _buildRow(["1", "2", "3", "-"]),
              _buildRow(["C", "0", "=", "+"]),
            ],
          ),
        ],
      ),
    );
  }

  // Builds a row of buttons
  Widget _buildRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons
          .map((text) => _buildButton(text, color: _getButtonColor(text)))
          .toList(),
    );
  }

  // Returns the color for a button based on its text
  Color _getButtonColor(String text) {
    if (text == "C") return Colors.red;
    if (text == "=") return Colors.green;
    if (text == "x²") return Colors.orange;
    if (["+", "-", "*", "/"].contains(text)) return Colors.blue;
    return Colors.grey;
  }
}
