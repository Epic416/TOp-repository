import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const VictorinaApp());
}

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

  Future<void> _saveBestScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final bestScore = prefs.getInt('best_score') ?? 0;
    if (score > bestScore) {
      await prefs.setInt('best_score', score);
      setState(() => _bestScore = score);
    }
  }

  Future<void> _resetBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('best_score');
    setState(() => _bestScore = 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Викторина')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.quiz, size: 100, color: Colors.blue),
            const SizedBox(height: 32),
            const Text('Викторина', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
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
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12.0),
              ),
              child: const Text('Начать', style: TextStyle(fontSize: 16)),
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
}

class QuizScreen extends StatefulWidget {
  final Function(int) onFinish;
  const QuizScreen({super.key, required this.onFinish});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Какова цена взрослой жизни?',
      'options': ['пачка кириешек', 'Берлин', 'доширак', 'отсутствие нервов'],
      'correct': 3,
    },
    {
      'question': 'Какой язык программирования используется во Flutter?',
      'options': ['Java', 'Dart', 'Kotlin', 'Swift'],
      'correct': 1,
    },
    {
      'question': 'Сколько планет в Солнечной системе?',
      'options': ['7', '8', '9', '10'],
      'correct': 1,
    },
    {
      'question': 'Какой элемент обозначается символом "O" в таблице Менделеева?',
      'options': ['Олово', 'Осмий', 'Кислород', 'Золото'],
      'correct': 2,
    },
    {
      'question': 'Какой год считается годом основания Москвы?',
      'options': ['1147', '1247', '988', '1703'],
      'correct': 0,
    },
  ];

  int _currentQuestion = 0;
  int _score = 0;
  bool _answered = false;
  bool _showResult = false;
  bool _scoreSaved = false;
  int _timeLeft = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _questions.shuffle(Random());
    _startTimer();
  }

  void _startTimer() {
    _timeLeft = 10;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_answered || _showResult || !mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          timer.cancel();
          _handleTimeout();
        }
      });
    });
  }

  void _handleTimeout() {
    if (!_answered) {
      setState(() => _answered = true);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _nextQuestionOrFinish();
      });
    }
  }

  void _nextQuestionOrFinish() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _answered = false;
      });
      _startTimer();
    } else {
      setState(() => _showResult = true);
      _timer?.cancel();
    }
  }

  void _selectAnswer(int index) {
    if (_answered) return;
    if (index == _questions[_currentQuestion]['correct']) {
      _score++;
    }
    setState(() => _answered = true);
    _timer?.cancel();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _nextQuestionOrFinish();
    });
  }

  void _restart() {
    _questions.shuffle(Random());
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _answered = false;
      _showResult = false;
      _scoreSaved = false;
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showResult) {
      if (!_scoreSaved) {
        widget.onFinish(_score);
        _scoreSaved = true;
      }
      return Scaffold(
        appBar: AppBar(title: const Text('Результат')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
              const SizedBox(height: 32),
              Text('$_score из ${_questions.length}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(
                _score == _questions.length
                    ? 'Идеально! 🎉'
                    : _score > _questions.length / 2
                        ? 'Неплохо! 👍'
                        : 'Попробуй ещё раз 💪',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _restart,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12.0),
                ),
                child: const Text('Играть снова'),
              ),
            ],
          ),
        ),
      );
    }

    final question = _questions[_currentQuestion];
    final options = question['options'] as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Вопрос ${_currentQuestion + 1}/${_questions.length}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '$_timeLeft с',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _timeLeft <= 3 ? Colors.redAccent : Theme.of(context).primaryColorLight,
                ),
              ),
            ),
          ),
        ],
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
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ...options.asMap().entries.map((entry) {
                  int index = entry.key;
                  String option = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ElevatedButton(
                      onPressed: () => _selectAnswer(index),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16.0),
                      ),
                      child: Text(option, style: const TextStyle(fontSize: 16)),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}