import 'package:flutter/material.dart';

  class NameApp extends StatelessWidget {
    const NameApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.blueGrey[50],

          body: Center(
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.black,
                  blurRadius: 20,
                  offset: const Offset(0, 5)
                  ),
                ]
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: const DecorationImage(
                            image: AssetImage("assets/i.webp"),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            )
                          ]
                        ),
                      ),
                      
                  ], 
                ),
                const SizedBox(height: 25),
                Column(
                  children: [
                    Text('SVO',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    )
                    ),
                    Text('ZOV',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5)
                      ),
                    ),
                    Container(
                      height: 8,
                      width: 190,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5)
                      )
                    )
                  ],
                ),
                SizedBox(height: 20),
                Row (
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    
                    Icon(Icons.shuffle, color: Colors.grey, size: 40),
                    Icon(Icons.skip_previous_rounded, color: Colors.black, size: 40),
                    Icon(Icons.play_arrow_rounded, color: Colors.black, size: 40),
                    Icon(Icons.skip_next_rounded, color: Colors.black, size: 40),
                    Icon(Icons.repeat, color: Colors.grey, size: 40),
                  ]
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}