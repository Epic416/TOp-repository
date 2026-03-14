import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatelessWidget {
  CalculatorScreen({super.key});

  final List<String> buttons = [
    'C', '+-', '%', '/',
    '7', '8', '9', '*',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    ',', '0', '.', '='
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: buttons.map((label) => _buildButton(label)).toList(),
        ),
      ),
    );
  }

  Widget _buildButton(String label) {
    final isOperator = ['/', '*', '-', '+', '='].contains(label);
    return Container(
      decoration: BoxDecoration(
        color: isOperator ? Colors.orange : Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 24,
            color: isOperator ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}