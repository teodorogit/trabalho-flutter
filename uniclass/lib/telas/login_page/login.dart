import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uniclass/telas/signup_page/cadastro_page.dart';
import 'package:uniclass/telas/home_page/home_page.dart';

void main() {
  runApp(const UniClassApp());
}

class UniClassApp extends StatelessWidget {
  const UniClassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final supabase = Supabase.instance.client;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void showSnack(String message, {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red[400] : Colors.green[400],
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> login() async {
    final email = _emailController.text.trim();
    final password = _senhaController.text.trim();

    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        showSnack('Credenciais inválidas. Verifique seu email e senha.',
            isError: true);
        return;
      }

      // Verifica se o usuário existe na tabela 'mobileUser'
      final userRecord = await supabase
          .from('mobileUser')
          .select()
          .ilike('email', email)
          .maybeSingle();

      if (userRecord == null) {
        await supabase.auth.signOut();
        showSnack('Usuário não autorizado no sistema.', isError: true);
        return;
      }

      showSnack('Login realizado com sucesso!');

      // Navega para próxima tela
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } on AuthException catch (e) {
      showSnack('Erro de autenticação: ${e.message}', isError: true);
    } catch (e) {
      showSnack('Erro inesperado: $e', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "UNICLASS",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        color: Colors.black26,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Image.asset(
                  'assets/images/logo_uniclass_mobile.png',
                  width: 250,
                  height: 250,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.green[700]),
                            filled: true,
                            fillColor: const Color(0xFFDFF6DD),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green[700]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green[900]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, entre com o seu email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _senhaController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            labelStyle: TextStyle(color: Colors.green[700]),
                            filled: true,
                            fillColor: const Color(0xFFDFF6DD),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green[700]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green[900]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, entre com sua senha';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.green,
                                side: BorderSide(color: Colors.green),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CadastroPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Criar conta',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 12),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  login();
                                }
                              },
                              child: const Text('Entrar'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                'v.1.0',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
