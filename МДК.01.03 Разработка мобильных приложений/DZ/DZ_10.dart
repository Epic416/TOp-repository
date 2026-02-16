import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class AAAA extends StatelessWidget {
  const AAAA({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _statuses = [
    'Активен',
    'Обед',
    'На совещании',
    'Не беспокоить',
    'Вышел'
  ];
  
  final List<Color> _statusColors = [
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.grey,
  ];
  
  int _currentStatusIndex = 0;

  void _cycleStatus() {
    setState(() {
      _currentStatusIndex = (_currentStatusIndex + 1) % _statuses.length;
    });
  }

  Color _getStatusColor() {
    return _statusColors[_currentStatusIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль (цикл. статус)'),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GFCard(
              content: Column(
                children: [
                  GFCard(       
                    color: _getStatusColor(),
                    title: GFListTile(
                      avatar: const GFAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: const Text(
                        'Светлана',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subTitle: const Text('Преподаватель математики'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Текущий статус: ${_statuses[_currentStatusIndex]}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GFButton(
              onPressed: _cycleStatus,
              text: "Сменить статус",
              type: GFButtonType.outline,
              blockButton: true,
            ),
          ],
        ),
      ),
    );
  }
}