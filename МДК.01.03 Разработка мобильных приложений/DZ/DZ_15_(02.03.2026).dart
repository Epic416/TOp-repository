import 'package:flutter/material.dart';

class IDK extends StatelessWidget {
  const IDK({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Navigation',
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  void _login() {
    if (_loginController.text == 'user' && _passwordController.text == '123') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ImageScreen()),
      );
    } else {
      setState(() {
        _errorMessage = 'Неверные логин или пароль';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Вход')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _loginController,
              decoration: InputDecoration(labelText: 'Логин'),
              onChanged: (value) {
                if (_errorMessage.isNotEmpty) {
                  setState(() {
                    _errorMessage = '';
                  });
                }
              },
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Пароль'),
              obscureText: true,
              onChanged: (value) {
                if (_errorMessage.isNotEmpty) {
                  setState(() {
                    _errorMessage = '';
                  });
                }
              },
              onSubmitted: (_) => _login(),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Картинка')),
      body: Center(
        child: Image.asset('LELE.PNG'),
      ),
    );
  }
}