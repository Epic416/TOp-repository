import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ==================== ТОЧКА ВХОДА ====================
class NotesDB extends StatelessWidget {
  const NotesDB({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NotesDBHome(),
    );
  }
}

// ==================== ГЛАВНЫЙ ЭКРАН ====================
class NotesDBHome extends StatefulWidget {
  const NotesDBHome({super.key});

  @override
  State<NotesDBHome> createState() => _NotesDBHomeState();
}

class _NotesDBHomeState extends State<NotesDBHome> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = const [AllNotesScreen(), FavoriteNotesScreen(), ProfileScreen()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Все заметки'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Избранное'),
          BottomNavigationBarItem(icon: Icon(Icons.person_2), label: 'Профиль'),
        ],
      ),
    );
  }
}

class AllNotesScreen extends StatefulWidget {
  const AllNotesScreen({super.key});

  @override
  State<AllNotesScreen> createState() => _AllNotesScreenState();
}

class _AllNotesScreenState extends State<AllNotesScreen> {
  List<dynamic> _students = [];
  bool _isLoading = true;
  String _sortOrder = 'asc';

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Color _getScoreColor(String score) {
    final value = double.tryParse(score) ?? 0.0;
    if (value >= 4.5) {
      return Colors.green;
    } else if (value >= 3.0) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  // Загрузка заметок
  Future<void> _loadStudents() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('http://localhost/tasks_2.php'),
        body: {'action': 'read'},
      );
      final data = jsonDecode(response.body);
      List<dynamic> students = data['tasks'] ?? [];

      students.sort((a, b) {
        final nameA = (a['title'] ?? '').toString().toLowerCase();
        final nameB = (b['title'] ?? '').toString().toLowerCase();
        return _sortOrder == 'asc' ? nameA.compareTo(nameB) : nameB.compareTo(nameA);
      });

      setState(() {
        _students = students;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Ошибка: $e');
    }
  }

  // Переключение сортировки
  void _toggleSortOrder() {
    setState(() {
      _sortOrder = _sortOrder == 'asc' ? 'desc' : 'asc';
    });
    _loadStudents();
  }

  // Добавление
  Future<void> _createStudent(String name, String group, String score) async {
    await http.post(
      Uri.parse('http://localhost/tasks_2.php'),
      body: {
        'action': 'create',
        'title': name,
        'group_num': group,
        'average_score': score,
      },
    );
    _loadStudents();
  }

  // Удаление
  Future<void> _deleteStudent(int id) async {
    await http.post(
      Uri.parse('http://localhost/tasks_2.php'),
      body: {'action': 'delete', 'id': id.toString()},
    );
    _loadStudents();
  }

  // Редактирование
  Future<void> _updateStudent(int id, String name, String group, String score) async {
    await http.post(
      Uri.parse('http://localhost/tasks_2.php'),
      body: {
        'action': 'update',
        'id': id.toString(),
        'title': name,
        'group_num': group,
        'average_score': score,
      },
    );
    _loadStudents();
  }

  // Диалог добавления/редактирования
  void _showStudentDialog({int? id, String? name, String? group, String? score}) {
    final nameCtrl = TextEditingController(text: name ?? '');
    final groupCtrl = TextEditingController(text: group ?? '');
    final scoreCtrl = TextEditingController(text: score ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(id == null ? 'Новая заметка' : 'Редактировать'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Название',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: groupCtrl,
              decoration: const InputDecoration(
                labelText: 'Группа',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: scoreCtrl,
              decoration: const InputDecoration(
                labelText: 'Средний балл',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (id == null) {
                _createStudent(nameCtrl.text, groupCtrl.text, scoreCtrl.text);
              } else {
                _updateStudent(id, nameCtrl.text, groupCtrl.text, scoreCtrl.text);
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Подтверждение удаления
  void _confirmDelete(int id, String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Удалить?'),
        content: Text('"$name"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteStudent(id);
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Задачи'),
        actions: [
          IconButton(
            icon: Icon(_sortOrder == 'asc' ? Icons.sort : Icons.sort_outlined),
            onPressed: _toggleSortOrder,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showStudentDialog(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _students.isEmpty
          ? const Center(child: Text('Нет заметок'))
          : ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final s = _students[index];
                final id = int.tryParse(s['id']?.toString() ?? '0') ?? 0;
                final name = s['title'] ?? 'Неизвестно';
                final group = s['group_num'] ?? '—';
                final score = s['average_score'] ?? '0.0';

                return ListTile(
                  title: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Группа: $group'),
                      Text(
                        'Балл: $score',
                        style: TextStyle(
                          color: _getScoreColor(score),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.star_border, color: Colors.grey),
                    onPressed: () {},
                  ),
                  onTap: () => _showStudentDialog(
                    id: id,
                    name: name,
                    group: group,
                    score: score,
                  ),
                  onLongPress: () => _confirmDelete(id, name),
                );
              },
            ),
    );
  }
}

class FavoriteNotesScreen extends StatelessWidget {
  const FavoriteNotesScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Избранное'));
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Профиль'));
}