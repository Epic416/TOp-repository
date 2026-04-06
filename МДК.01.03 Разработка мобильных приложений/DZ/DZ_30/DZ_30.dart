import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

// ==================== APP ENTRY ====================
class NotesDB extends StatelessWidget {
  const NotesDB({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NotesHome(),
    );
  }
}

// ==================== MAIN SCREEN ====================
class NotesHome extends StatefulWidget {
  const NotesHome({super.key});
  @override
  State<NotesHome> createState() => _NotesHomeState();
}

class _NotesHomeState extends State<NotesHome> {
  int _tabIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const [NotesListPage(), FavoritesPage(), UserPage()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (idx) => setState(() => _tabIndex = idx),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Заметки'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Избранное'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}

// ==================== ALL NOTES PAGE ====================
class NotesListPage extends StatefulWidget {
  const NotesListPage({super.key});
  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  List<dynamic> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _loading = true);
    try {
      final res = await http.post(
        Uri.parse('http://localhost/tasks_2.php'),
        body: {'action': 'read'},
      );
      final json = jsonDecode(res.body);
      setState(() {
        _items = json['tasks'] ?? [];
        _loading = false;
      });
    } catch (err) {
      setState(() => _loading = false);
      debugPrint('Error: $err');
    }
  }

  Future<void> _addNote(String txt) async {
    await http.post(Uri.parse('http://localhost/tasks_2.php'),
        body: {'action': 'create', 'title': txt});
    _fetchData();
  }

  Future<void> _removeNote(int id) async {
    await http.post(Uri.parse('http://localhost/tasks_2.php'),
        body: {'action': 'delete', 'id': id.toString()});
    _fetchData();
  }

  Future<void> _editNote(int id, String txt) async {
    await http.post(Uri.parse('http://localhost/tasks_2.php'),
        body: {'action': 'update', 'id': id.toString(), 'title': txt});
    _fetchData();
  }

  Future<void> _toggleStar(int id) async {
    await http.post(Uri.parse('http://localhost/tasks_2.php'),
        body: {'action': 'toggle_favorite', 'id': id.toString()});
    _fetchData();
  }

  void _openDialog({int? noteId, String? initial}) {
    final ctrl = TextEditingController(text: initial ?? '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(noteId == null ? 'Создать' : 'Править'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Текст заметки',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (noteId == null) {
                _addNote(ctrl.text);
              } else {
                _editNote(noteId, ctrl.text);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _askDelete(int id, String title) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Удалить?'),
        content: Text('"$title"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Нет'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _removeNote(id);
            },
            child: const Text('Да', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои заметки'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openDialog(),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(child: Text('Пусто'))
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (ctx, idx) {
                    final item = _items[idx];
                    final nid = int.parse(item['id'].toString());
                    final isFav = item['is_favorite'] == 1 ||
                        item['is_favorite'] == '1';
                    return ListTile(
                      title: Text(item['title']),
                      subtitle: Text('#${item['id']}'),
                      onTap: () =>
                          _openDialog(noteId: nid, initial: item['title']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              isFav ? Icons.star : Icons.star_border,
                              color: isFav ? Colors.amber : Colors.grey,
                            ),
                            onPressed: () => _toggleStar(nid),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            onPressed: () => _askDelete(nid, item['title']),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

// ==================== FAVORITES PAGE ====================
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<dynamic> _favItems = [];
  bool _busy = true;

  @override
  void initState() {
    super.initState();
    _loadFavs();
  }

  Future<void> _loadFavs() async {
    setState(() => _busy = true);
    try {
      final res = await http.post(
        Uri.parse('http://localhost/tasks_2.php'),
        body: {'action': 'read', 'favorite': 'true'},
      );
      final data = jsonDecode(res.body);
      setState(() {
        _favItems = data['tasks'] ?? [];
        _busy = false;
      });
    } catch (e) {
      setState(() => _busy = false);
      debugPrint('Load error: $e');
    }
  }

  // Убрать из избранного (не удаляя саму заметку)
  Future<void> _unfavorite(int id) async {
    await http.post(Uri.parse('http://localhost/tasks_2.php'),
        body: {'action': 'toggle_favorite', 'id': id.toString()});
    _loadFavs();
  }

  // Полное удаление заметки
  Future<void> _hardDelete(int id) async {
    await http.post(Uri.parse('http://localhost/tasks_2.php'),
        body: {'action': 'delete', 'id': id.toString()});
    _loadFavs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('★ Избранное')),
      body: _busy
          ? const Center(child: CircularProgressIndicator())
          : _favItems.isEmpty
              ? const Center(child: Text('Нет избранных'))
              : ListView.builder(
                  itemCount: _favItems.length,
                  itemBuilder: (ctx, idx) {
                    final t = _favItems[idx];
                    final tid = int.parse(t['id'].toString());
                    return ListTile(
                      leading: const Icon(Icons.star, color: Colors.amber),
                      title: Text(t['title']),
                      subtitle: Text('#${t['id']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.star_outline,
                                color: Colors.grey),
                            tooltip: 'Убрать из избранного',
                            onPressed: () => _unfavorite(tid),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_forever,
                                color: Colors.red),
                            tooltip: 'Удалить навсегда',
                            onPressed: () => _hardDelete(tid),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

// ==================== PROFILE PAGE ====================
class UserPage extends StatefulWidget {
  const UserPage({super.key});
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String _userName = '';
  String _userAvatar = '';
  bool _profLoading = true;

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  Future<void> _getProfile() async {
    final res = await http.post(
      Uri.parse('http://localhost/profile.php'),
      body: {'action': 'get_profile'},
    );
    final data = jsonDecode(res.body);
    setState(() {
      _userName = data['user']['name'];
      _userAvatar = data['user']['avatar'];
      _profLoading = false;
    });
  }

  Future<void> _selectPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final req = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost/profile.php'),
      );
      req.fields['action'] = 'upload_avatar';
      req.files.add(
          await http.MultipartFile.fromPath('avatar', picked.path));
      final resp = await req.send();
      if (resp.statusCode == 200) {
        _getProfile();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✓ Аватар обновлён')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: _profLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(
                        'http://localhost/notes_avatars/$_userAvatar'),
                  ),
                  const SizedBox(height: 16),
                  Text(_userName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _selectPhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Сменить фото'),
                  ),
                ],
              ),
            ),
    );
  }
}