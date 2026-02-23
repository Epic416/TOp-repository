import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class RegistrForm extends StatefulWidget {
  const RegistrForm({super.key});

  @override
  State<RegistrForm> createState() => _RegistrFormState();
}

class _RegistrFormState extends State<RegistrForm> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  String? _usernameErrorText;
  String? _passwordErrorText;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateUsername(String username) {
    setState(() {
      if (username.length < 3) {
        _usernameErrorText = 'Логин слишком короткий (минимум 3 символа)';
      } else if (username.length > 20) {
        _usernameErrorText = 'Логин слишком длинный (максимум 20 символов)';
      } else if (username.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        _usernameErrorText = 'Логин не должен содержать специальные символы';
      } else {
        _usernameErrorText = null;
      }
    });
  }

  void _validatePassword(String password) {
    setState(() {
      if (password.length < 8) {
        _passwordErrorText = 'Пароль слишком короткий (минимум 8 символов)';
      } else if (!password.contains(RegExp(r'[A-Z]'))) {
        _passwordErrorText = 'Добавьте хотя бы одну заглавную букву';
      } else if (!password.contains(RegExp(r'[0-9]'))) {
        _passwordErrorText = 'Добавьте хотя бы одну цифру';
      } else if (!password.contains(RegExp(r'[@#$%^&*(),.?":{}|<>]'))) {
        _passwordErrorText = 'Добавьте хотя бы один специальный символ';
      } else {
        _passwordErrorText = null;
      }
    });
  }

  void _register(BuildContext context) {
    final username = _usernameController.text;
    final password = _passwordController.text;
    
    _validateUsername(username);
    _validatePassword(password);

    if (_usernameErrorText == null && _passwordErrorText == null) {
      GFToast.showToast(
        'Пользователь "$username" успешно зарегистрирован!',
        context,
        backgroundColor: GFColors.SUCCESS,
        toastPosition: GFToastPosition.BOTTOM,
      );
    } else {
      String errorMessage = '';
      if (_usernameErrorText != null) errorMessage += '$_usernameErrorText\n';
      if (_passwordErrorText != null) errorMessage += _passwordErrorText!;
      
      GFToast.showToast(
        errorMessage,
        context,
        backgroundColor: GFColors.DANGER,
        toastPosition: GFToastPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Форма регистрации')),
        body: Builder(builder: (innerContext) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Поле для логина
                TextField(
                  controller: _usernameController,
                  onChanged: _validateUsername,
                  onSubmitted: (_) => _register(innerContext),
                  decoration: InputDecoration(
                    labelText: 'Логин',
                    errorText: _usernameErrorText,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Поле для пароля
                TextField(
                  controller: _passwordController,
                  onChanged: _validatePassword,
                  onSubmitted: (_) => _register(innerContext),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Пароль',
                    errorText: _passwordErrorText,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Кнопка регистрации
                GFButton(
                  onPressed: () => _register(innerContext),
                  text: 'Зарегистрироваться',
                  blockButton: true,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}