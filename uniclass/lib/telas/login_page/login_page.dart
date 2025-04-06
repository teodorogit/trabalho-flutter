import 'package:flutter/material.dart';
import 'package:uniclass/telas/cadastro/cadastro_page.dart';
import 'package:uniclass/widgets/custom_text_field.dart';
import 'package:uniclass/telas/validation/validation.dart';
import 'package:uniclass/telas/home_page/home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _validation = Validation();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bem vindo ao UniClass',
          style: TextStyle(color: Colors.orange),
        ),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500),
                child: CustomTextField(
                  controller: _usernameController,
                  label: 'Username',
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor digite  seu nome';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: _passwordController,
                label: 'Senha',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor digite sua senha';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 195, 251, 198), // Alterado para laranja
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool success = await _validation.validateUser(
                          _usernameController.text,
                          _passwordController.text,
                        );

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Login realizado com sucesso!')),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Email ou senha inválidos.')),
                          );
                        }
                      }
                    },
                    child: Text('Login'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 195, 251, 198), // Alterado para laranja
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => CadastroPage()),
                      );
                    },
                    child: Text('Cadastrar'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
