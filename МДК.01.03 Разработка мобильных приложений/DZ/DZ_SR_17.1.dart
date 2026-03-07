import 'package:flutter/material.dart';

class Rabota extends StatelessWidget {
  const Rabota({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProfileScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = 'Студент Топ';
  String status = 'Вешается перед экзаменом';
  bool showSuccess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(children: [
            const CircleAvatar(radius: 30, child: Icon(Icons.person, size: 30)),
            const SizedBox(width: 20),
            if (showSuccess)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Профиль успешно изменён',
                    style: TextStyle(color: Colors.white)),
              )
            else
              const Text('Карточка профиля',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ]),
          const SizedBox(height: 30),
          Card(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Имя: $name', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text('Статус: $status', style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditScreen(
                            currentName: name, currentStatus: status)));
                if (result != null) {
                  setState(() {
                    name = result['name'];
                    status = result['status'];
                    showSuccess = true;
                  });
                  Future.delayed(const Duration(seconds: 3), () {
                    setState(() {
                      showSuccess = false;
                    });
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: const Text('Редактировать',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ]),
      ),
    );
  }
}

class EditScreen extends StatelessWidget {
  final String currentName;
  final String currentStatus;
  const EditScreen(
      {super.key, required this.currentName, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: currentName);
    final statusController = TextEditingController(text: currentStatus);

    return Scaffold(
      appBar: AppBar(title: const Text('Редактировать профиль')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          TextField(
              controller: nameController,
              decoration: const InputDecoration(
                  labelText: 'Имя пользователя', border: OutlineInputBorder())),
          const SizedBox(height: 20),
          TextField(
              controller: statusController,
              decoration: const InputDecoration(
                  labelText: 'Статус', border: OutlineInputBorder())),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, {
                    'name': nameController.text,
                    'status': statusController.text
                  }),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: const Text('Сохранить',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ]),
      ),
    );
  }
}