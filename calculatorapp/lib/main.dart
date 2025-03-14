import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crow Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  const CalculatorHomePage({super.key});

  @override
  State<CalculatorHomePage> createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String _display = '';
  String _input = '';
  int? _firstOperand;
  String? _operator;
  bool _newInput = false; // Tracks if a new calculation should start

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _clear();
      } else if (_isOperator(value)) {
        _setOperator(value);
      } else if (value == '=') {
        _calculateResult();
      } else {
        _appendNumber(value);
      }
    });
  }

  bool _isOperator(String value) {
    return value == '+' || value == '-' || value == '×' || value == '÷';
  }

  void _clear() {
    _display = '';
    _input = '';
    _firstOperand = null;
    _operator = null;
    _newInput = false;
  }

  void _setOperator(String operator) {
    if (_input.isNotEmpty) {
      _firstOperand = int.parse(_input);
      _operator = operator;
      _display = '$_input $operator ';
      _input = '';
      _newInput = false;
    } else if (_firstOperand != null) {
      _operator = operator;
      _display = '${_firstOperand.toString()} $operator ';
    }
  }

  void _appendNumber(String number) {
    if (_newInput) {
      _input = number; // Start fresh if a new calculation begins
      _newInput = false;
    } else {
      _input += number;
    }
    _display = _firstOperand != null && _operator != null
        ? '${_firstOperand.toString()} $_operator $_input'
        : _input;
  }

  void _calculateResult() {
    if (_firstOperand != null && _operator != null && _input.isNotEmpty) {
      int secondOperand = int.parse(_input);
      int result;

      switch (_operator) {
        case '+':
          result = _firstOperand! + secondOperand;
          break;
        case '-':
          result = _firstOperand! - secondOperand;
          break;
        case '×':
          result = _firstOperand! * secondOperand;
          break;
        case '÷':
          if (secondOperand == 0) {
            _display = 'Error: Division by zero';
            _firstOperand = null;
            _operator = null;
            _input = '';
            return;
          }
          double divisionResult = _firstOperand! / secondOperand;
          if (divisionResult != divisionResult.toInt()) {
            _display = 'Decimals not supported';
            _firstOperand = null;
            _operator = null;
            _input = '';
            return;
          }
          result = _firstOperand! ~/ secondOperand;
          break;
        default:
          return;
      }

      _display = result.toString();
      _input = result.toString();
      _firstOperand = null;
      _operator = null;
      _newInput = true; // Mark new calculation start
    }
  }

  Widget _buildButton(String text, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(text),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20),
            backgroundColor: color ?? Colors.grey[300],
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Andres\'s Calculator'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              child: Text(
                _display,
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  _buildButton('7'),
                  _buildButton('8'),
                  _buildButton('9'),
                  _buildButton('÷', color: Colors.orange),
                ],
              ),
              Row(
                children: [
                  _buildButton('4'),
                  _buildButton('5'),
                  _buildButton('6'),
                  _buildButton('×', color: Colors.orange),
                ],
              ),
              Row(
                children: [
                  _buildButton('1'),
                  _buildButton('2'),
                  _buildButton('3'),
                  _buildButton('-', color: Colors.orange),
                ],
              ),
              Row(
                children: [
                  _buildButton('0'),
                  _buildButton('C', color: Colors.red),
                  _buildButton('=', color: Colors.green),
                  _buildButton('+', color: Colors.orange),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
