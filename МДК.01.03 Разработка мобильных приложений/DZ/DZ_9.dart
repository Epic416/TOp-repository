import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // --- СОСТОЯНИЕ ---
  bool __isLiked = false;
  int __likeCount = 0;

  // --- ДОГИЖКА ---
  void __toggleLike() {
    setState(() {
      __isLiked = !__isLiked;
      __likeCount = __isLiked ? 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Like Button'),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: __toggleLike,
                child: Icon(
                  __isLiked ? Icons.favorite : Icons.favorite_border,
                  color: __isLiked ? Colors.red : Colors.grey,
                  size: 30,
                ), // Icon
              ),
              const SizedBox(width: 8),
              Text(
                '$__likeCount',
                style: TextStyle(
                  color: __isLiked ? Colors.red : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ), // TextStyle
              ), // Text
            ],
          ),
        ),
      ),
    );
  }
}