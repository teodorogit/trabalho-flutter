import 'package:flutter/material.dart';
import 'package:uniclass/View/widgets/custom_text_field.dart';
import 'package:uniclass/ViewModel/validation.dart';
import 'package:uniclass/View/Pages/home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isAdmin = false;

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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.0001),
                  SizedBox(
                    width: size.width * 2,
                    height: size.height * 0.34,
                    child: Image.asset(
                      'assets/images/uniclass.jpeg',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: CustomTextField(
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
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: CustomTextField(
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
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 120, 218, 73),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final email = _usernameController.text;
                            final password = _passwordController.text;

                            final userTypeAdm = await ValidationUserWeb()
                                .validateUserWeb(email, password, isAdmin);

                            if (userTypeAdm == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Login de administrador realizado com sucesso!'),
                                ),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()),
                              );
                            } else if (userTypeAdm == false) {
                              final userType = await ValidationUserWeb()
                                  .validate(email, password, isAdmin);
                                  print('Login usuario padrão: ${userTypeAdm}');
                              if (userType == true) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Login realizado com sucesso!'),
                                  ),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),//copiar tela para usuário padrão
                                );
                              } else {
                                if (isAdmin) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'O e-mail informado  não é do adimistrador. Desmarque a flag "Acessar como Administrador"'),
                                    ),
                                  );
                                  return;
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'O e-mail informado é do administrador. Marque a flag "Acessar como Administrador"'),
                                  ),
                                );
                              }
                            } else {                             
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Email ou senha inválidos, revise os dados preenchidos!'),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('Entrar'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Acessar como administrador",
                        style: const TextStyle(color: Colors.black),
                      ),
                      Switch(
                        activeColor: const Color.fromARGB(255, 239, 155, 52),
                        value: isAdmin,
                        onChanged: (bool value) {
                          setState(() {
                            isAdmin = value;
                            print('O valor da flag: ${isAdmin}');
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
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
                    width: size.width * 0.60,
                    height: size.height * 0.13,
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
