import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _ratingValue = 4.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const GFAvatar(
              size: 80,
              backgroundColor: Colors.blueGrey,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Светлана',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Преподаватель рисования',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            GFRating(
              value: _ratingValue,
              itemCount: 5,
              size: GFSize.SMALL,
              color: Colors.amber,
              borderColor: Colors.amber,
              allowHalfRating: true,
              onChanged: (value) {
                setState(() {
                  _ratingValue = value;
                });
              },
            ),
            const SizedBox(height: 24),
            GFListTile(
              titleText: 'Email',
              subTitleText: 'sveta2843596@gmail.com',
              icon: const Icon(Icons.email),
            ),
            const SizedBox(height: 8), 
            GFListTile(
              titleText: 'Телефон',
              subTitleText: '+7 (123) 456-78-90',
              icon: const Icon(Icons.phone),
            ),
          ],
        ),
      ),
    );
  }
}