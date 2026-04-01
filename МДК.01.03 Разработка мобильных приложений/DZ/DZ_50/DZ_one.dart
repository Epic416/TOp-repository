import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class TaskRepository {
  Future<List<Map<String, dynamic>>> getTasks({String? favorite});
  Future<void> createTask(String title);
  Future<void> deleteTask(int id);
  Future<void> updateTask(int id, String title);
}

class HttpTaskRepository implements TaskRepository {
  final String url;
  HttpTaskRepository(this.url);
  @override
  Future<List<Map<String, dynamic>>> getTasks({String? favorite}) async {
    final response = await http.post(
      Uri.parse(url),
      body: {'action': 'read', 'favorite': favorite ?? 'all'},
    );
    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data['tasks'] ?? []);
  }
  @override
  Future<void> createTask(String title) async {
    await http.post(Uri.parse(url), body: {'action': 'create', 'title': title});
  }
  @override
  Future<void> deleteTask(int id) async {
    await http.post(Uri.parse(url), body: {'action': 'delete', 'id': id.toString()});
  }
  @override
  Future<void> updateTask(int id, String title) async {
    await http.post(Uri.parse(url), body: {'action': 'update', 'id': id.toString(), 'title': title});
  }
}

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

class NotesDBHome extends StatefulWidget {
  const NotesDBHome({super.key});
  @override
  State createState() => _NotesDBHomeState();
}

class _NotesDBHomeState extends State<NotesDBHome> {
  int _currentIndex = 0;
  late final List<Widget> _screens;
  late final TaskRepository repository;

  @override
  void initState() {
    super.initState();
    repository = HttpTaskRepository('http://localhost/DZ_one.php');
    _screens = [
      AllNotesScreen(repository: repository),
      const FavoriteNotesScreen(),
      const ProfileScreen(),
    ];
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
  final TaskRepository repository;
  const AllNotesScreen({super.key, required this.repository});
  @override
  State createState() => _AllNotesScreenState();
}

class _AllNotesScreenState extends State<AllNotesScreen> {
  List<Map<String, dynamic>> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    try {
      final tasks = await widget.repository.getTasks();
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Ошибка: $e');
    }
  }

  Future<void> _createTask(String title) async {
    await widget.repository.createTask(title);
    _loadTasks();
  }

  Future<void> _deleteTask(int id) async {
    await widget.repository.deleteTask(id);
    _loadTasks();
  }

  Future<void> _updateTask(int id, String title) async {
    await widget.repository.updateTask(id, title);
    _loadTasks();
  }

  void _showTaskDialog({int? id, String? title}) {
    final controller = TextEditingController(text: title ?? '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(id == null ? 'Новая заметка' : 'Редактировать'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Название',
            border: OutlineInputBorder(),
          ),
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
                _createTask(controller.text);
              } else {
                _updateTask(id, controller.text);
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(int id, String title) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Удалить?'),
        content: Text('"$title"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteTask(id);
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
            icon: const Icon(Icons.add),
            onPressed: () => _showTaskDialog(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? const Center(child: Text('Нет заметок'))
              : ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    final id = int.parse(task['id'].toString());
                    return ListTile(
                      title: Text(task['title']),
                      subtitle: Text('ID: ${task['id']}'),
                      onTap: () => _showTaskDialog(id: id, title: task['title']),
                      onLongPress: () => _confirmDelete(id, task['title']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(id, task['title']),
                      ),
                    );
                  },
                ),
    );
  }
}

class FavoriteNotesScreen extends StatelessWidget {
  const FavoriteNotesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Избранное'));
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Профиль'));
  }
}

void main() {
  runApp(const NotesDB());
}