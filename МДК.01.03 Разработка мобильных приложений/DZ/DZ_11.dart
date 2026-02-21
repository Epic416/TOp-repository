import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';


class TextFiledApp extends StatefulWidget {
  const TextFiledApp({super.key});

  @override
  State<TextFiledApp> createState() => _TextFiledAppState();
}

class _TextFiledAppState extends State<TextFiledApp> {

  late TextEditingController _nameController;

  String _name = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showName(BuildContext context) {
    setState(() {
      _name = _nameController.text;
    });

    GFToast.showToast(
      'Привет, ${_nameController.text}!',
      context,
      toastPosition: GFToastPosition.BOTTOM,
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Builder(
          builder: (BuildContext innerContext) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GFCard(
                    content: Column(
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Введите имя',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => _showName(innerContext),
                        ),
                        const SizedBox(height: 10),
                        GFButton(
                          onPressed: () => _showName(innerContext),
                          text: "Показать имя",
                          blockButton: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text (
                    'Введенное имя: $_name',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }
        )
      )
    );
  }
}