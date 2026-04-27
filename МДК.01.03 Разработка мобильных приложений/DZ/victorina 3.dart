import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';

// ==================== ТОЧКА ВХОДА ====================
class VictorinaApp extends StatelessWidget {
  const VictorinaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const VictorinaHome(),
    );
  }
}

// ==================== ГЛАВНЫЙ ЭКРАН ====================
class VictorinaHome extends StatefulWidget {
  const VictorinaHome({super.key});

  @override
  State<VictorinaHome> createState() => _VictorinaHomeState();
}

class _VictorinaHomeState extends State<VictorinaHome> {
  int _bestScore = 0;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBestScore();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bestScore = prefs.getInt('best_score') ?? 0;
    });
  }

  Future<void> _resetBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('best_score');
    setState(() => _bestScore = 0);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Рекорд сброшен')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Викторина')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Викторина',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Рекорд: $_bestScore', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Ваше имя',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizScreen(
                      name: _nameController.text.isEmpty ? 'Игрок' : _nameController.text,
                      onFinish: _saveBestScore,
                    ),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('Начать', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _resetBestScore,
              child: const Text('Сбросить рекорд'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveBestScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final bestScore = prefs.getInt('best_score') ?? 0;
    if (score > bestScore) {
      await prefs.setInt('best_score', score);
      setState(() => _bestScore = score);
    }
  }
}

// ==================== ЭКРАН ВИКТОРИНЫ ====================
class QuizScreen extends StatefulWidget {
  final Function(int) onFinish;
  final String name;

  const QuizScreen({super.key, required this.onFinish, required this.name});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
 final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Сколько кумыса можно сделать из принцессы селестии из май литл пони за раз?',
      'options': ['316 литров', '290 литров', '422 литра', '501 литр'],
      'correct': 2,
    },
    {
      'question': 'Кто быстрее соник или рейнбоу дэш?',
      'options': ['соник', 'рейнбоу дэш'],
      'correct': 0,
    },
    {
      'question': 'Кто победит, сомбра из май литл пони или дарт вейдер?',
      'options': ['сомбра', 'дарт вейдер'],
      'correct': 1,
    },
    {
      'question': 'Сможет ли пони твайлайт спаркл стать еврейкой?',
      'options': ['нет', 'да', 'да, с ограничениями'],
      'correct': 2,
    },
    {
      'question': 'Кто быстрее покормит зверушек, саша симпл или флаттершай?',
      'options': ['саша симпл', 'флаттершай'],
      'correct': 1,
    },
  ];

  int _currentQuestion = 0;
  int _score = 0;
  bool _answered = false;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _questions.shuffle(Random());
  }

  void _selectAnswer(int index) {
    if (_answered) return;

    if (index == _questions[_currentQuestion]['correct']) {
      _score++;
    }

    setState(() => _answered = true);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      if (_currentQuestion < _questions.length - 1) {
        setState(() {
          _currentQuestion++;
          _answered = false;
        });
      } else {
        setState(() => _showResult = true);
      }
    });
  }

  void _restart() {
    setState(() {
      _questions.shuffle(Random());
      _currentQuestion = 0;
      _score = 0;
      _answered = false;
      _showResult = false;
    });
  }

  String _certificateMessage() {
    final summary = _questions.length;
    if (_score == summary) return "ты настоящий задрот пони и мультиков выйди на улицу подыши воздухом";
    if (_score >= 3) return 'средненько средненько могло быть и лучше';
    return 'захар не одобряет ваше существование на этой планете, смотрите мультики';
  }

  Future<Uint8List> _generateCertificate() async{
    final width = 800.0;
    final height = 700.0;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, width, height),
      Paint()..color = Color(0xFFFFFFFF)
    );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, width, height),
      Paint()
      ..color = Color.fromARGB(255, 184, 60, 255)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
    );

    try {
      final dir = await getApplicationDocumentsDirectory();
      final imageFile = File('${dir.path}/GGG.jpg');
      if (await imageFile.exists()) {
        final imageBytes = await imageFile.readAsBytes();
        final codec = await ui.instantiateImageCodec(imageBytes);
        final frame = await codec.getNextFrame();
        final img = frame.image;
        final targetWidth = 250.0;
        final targetHeight = 250.0;
        canvas.drawImageRect(
          img,
          Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
          Rect.fromLTWH((width - targetWidth) / 2, 30, targetWidth, targetHeight),
          Paint(),
        );
      }
    } catch (e) {
      // Изображение не найдено, продолжаем без него
    }

    var tp = TextPainter(
      text: TextSpan(
        text: 'ГРАМОТА',
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.lightBlueAccent
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr
    );
    tp.layout(maxWidth: width-80);
    tp.paint(canvas, Offset((width-tp.width)/2, 290));

    tp = TextPainter(
      text: TextSpan(
        text: 'Выдана: ${widget.name}',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500
        )
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr
    );
    tp.layout(maxWidth: width-80);
    tp.paint(canvas, Offset((width-tp.width)/2, 340));

    tp = TextPainter(
      text: TextSpan(
        text: 'Результат: $_score / ${_questions.length}',
        style: TextStyle(
          fontSize: 22
        )
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr
    );
    tp.layout(maxWidth: width-80);
    tp.paint(canvas, Offset((width-tp.width)/2, 380));

    tp = TextPainter(
      text: TextSpan(
        text: _certificateMessage(),
        style: TextStyle(fontSize: 16)
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr
    );
    tp.layout(maxWidth: width-80);
    tp.paint(canvas, Offset((width-tp.width)/2, 420));

    // Дата, серый, 14px
    final dateStr = DateTime.now().toString().substring(0, 10).split('-').reversed.join('.');
    tp = TextPainter(
      text: TextSpan(
        text: 'Дата: $dateStr',
        style: const TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: width - 80);
    tp.paint(canvas, Offset((width - tp.width) / 2, height - 40));  // внизу, с отступом 40px

    final picture = recorder.endRecording();
    final img = await picture.toImage(width.toInt(), height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _saveCertificate() async {
    try {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Генерация грамоты...'))
        );
      }
      
      final imageBytes = await _generateCertificate();
      
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/certificate_${widget.name}_${_score}.png';
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Грамота сохранена: $filePath'))
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка сохранения: $e'))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showResult) {
      widget.onFinish(_score);
      return Scaffold(
        appBar: AppBar(title: const Text('Результат')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
              const SizedBox(height: 32),
              Text(
                '$_score из ${_questions.length}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _score == _questions.length
                    ? 'отлично!'
                    : _score > _questions.length / 2
                    ? 'пойдет!'
                    : 'все фигня переделывай',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _restart,
                child: const Text('Играть снова'),
              ),
              ElevatedButton.icon(
                onPressed: _saveCertificate,
                icon: Icon(Icons.download),
                label: const Text('Сохранить грамоту'),
              ),
            ],
          ),
        ),
      );
    }

    final question = _questions[_currentQuestion];
    final options = question['options'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Вопрос ${_currentQuestion + 1}/${_questions.length}'),
      ),
      body: IgnorePointer(
        ignoring: _answered,
        child: AnimatedOpacity(
          opacity: _answered ? 0.5 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Text(
                  question['question'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ...options
                    .map(
                      (option) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ElevatedButton(
                          onPressed: () =>
                              _selectAnswer(options.indexOf(option)),
                          child: Text(
                            option,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}