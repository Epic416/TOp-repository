import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import 'package:image_gallery_saver/image_gallery_saver.dart';
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

  @override
  void initState() {
    super.initState();
    _loadBestScore();
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizScreen(onFinish: _saveBestScore),
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

  const QuizScreen({super.key, required this.onFinish});

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
    {
      'question': 'Фортинайт Или бабджи?',
      'options': ['Бабаджи', 'Фортинайт'],
      'correct': 0,
    },
    {
      'question': 'Кто такой Олег?',
      'options': ['Князь Московский, великий князь Владимирский, князь Новгородский. Сын Даниила Александровича, младший брат Юрия Даниловича, получивший своё прозвище, по разным версиям, за щедрость по отношению к нищим или за бережливость.', 'Олег'],
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

    // Считаем очки
    if (index == _questions[_currentQuestion]['correct']) {
      _score++;
    }

    // Экран становится неактивным на 0.5 секунды
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
    final height = 500.0;

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

    var tp = TextPainter(
      text: TextSpan(
        text: 'ГРАМОТА',
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.lightBlueAccent
        ),
      )
    );

    tp = TextPainter(
      text: TextSpan(
        text: 'Результат: $_score / ${_questions.length}',
        style: TextStyle(
          fontSize: 26
        )
      )
    );

    tp = TextPainter(
      text: TextSpan(
        text: _certificateMessage()
      )
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(width.toInt(), height.toInt());
    final ByteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return ByteData!.buffer.asUint8List();
  }

  Future<void> _saveCertificate() async {
    final imageBytes = await _generateCertificate();

    final dir = await getDownloadsDirectory();

    if(dir == null){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не удалось найти ничего хорошего'))
          );
        }
        return;
    }

    final path = '${dir.path}\\little_pony_certificate_$_score.png';

    final file = File(path);
    await file.writeAsBytes(imageBytes);

    if(mounted){
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Сохранено: $path")));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Результат игры
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
                // Варианты ответов
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
}
