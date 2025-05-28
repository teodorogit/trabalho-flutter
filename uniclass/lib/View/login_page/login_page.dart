import 'package:flutter/material.dart';
import 'package:uniclass/View/cadastro/cadastro_page.dart';
import 'package:uniclass/View/widgets/custom_text_field.dart';
import 'package:uniclass/ViewModel/validation.dart';
import 'package:uniclass/View/home_page/home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _validation = ValidationUser();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Text(
                    'UNICLASS',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.black45,
                          offset: Offset(1.5, 1.5),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  SizedBox(
                    width: size.width * 0.7,
                    height: size.height * 0.30,
                    child: Image.asset(
                      'assets/images/Representacao-removebg-preview.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.09),
                  CustomTextField(
                    controller: _usernameController,
                    label: 'Email',
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor digite seu email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(
                                0x4278DA49), 
                            side: BorderSide(
                              color: Colors
                                  .green[800]!, 
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12), 
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CadastroPage()),
                            );
                          },
                          child: Text(
                            'Cadastrar',
                            style: TextStyle(
                              color: Colors
                                  .green[700], 
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 120, 218, 73),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16),
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
                                      content:
                                          Text('Login realizado com sucesso!')),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Email ou senha inválidos.')),
                                );
                              }
                            }
                          },
                          child: const Text('Entrar'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Divider(thickness: 1),
                      ),
                      const SizedBox(height: 4),
                      const Text('v1.0', style: TextStyle(fontSize: 15)),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.035),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: const Divider(
                      color: Colors.black,
                      thickness: 1.5,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.0001),
                  SizedBox(
                    width: size.width * 0.40,
                    height: size.height * 0.20,
                    child: Image.asset(
                      'assets/images/logoUnicv-removebg-preview.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
