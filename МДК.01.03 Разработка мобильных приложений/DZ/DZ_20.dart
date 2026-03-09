import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavApp(),
    );
  }
}

class BottomNavApp extends StatefulWidget {
  const BottomNavApp({super.key});

  @override
  State<BottomNavApp> createState() => _BottomNavAppState();
}

class _BottomNavAppState extends State<BottomNavApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(), // Главная со списком
    const SearchPage(),
    const Center(child: Text('Профиль', style: TextStyle(fontSize: 30))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Навигация')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Поиск'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

// ГЛАВНАЯ СТРАНИЦА СО СПИСКОМ
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(
              '${index + 1}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: const Text('Макар Минченко'),
          subtitle: const Text('makar@example.com'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            print('Нажат элемент: ${index + 1}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Нажат элемент ${index + 1}')),
            );
          },
          onLongPress: () {
            print('Долгое нажатие: ${index + 1}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Долгое нажатие на элемент ${index + 1}')),
            );
          },
        );
      },
    );
  }
}

// СТРАНИЦА ПОИСКА
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController controller = TextEditingController();

  void showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Результат'),
        content: Text('Вы искали: ${controller.text}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          GFCard(
            content: Column(
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Запрос',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                GFButton(
                  onPressed: showSearchDialog,
                  text: "Поиск",
                  blockButton: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}