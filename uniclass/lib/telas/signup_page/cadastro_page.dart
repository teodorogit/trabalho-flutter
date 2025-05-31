import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uniclass/View/login_page/login_page.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/services.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final List<String> cursos = [
    'Ciência da Computação',
    'Engenharia de Software',
    'Sistemas de Informação',
    'Análise e Desenvolvimento de Sistemas'
  ];

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController raController = TextEditingController();
  final TextEditingController semestreController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmaSenhaController = TextEditingController();

  String? cursoSelecionado;

  void mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  bool validarCampos() {
    if (nomeController.text.isEmpty) {
      mostrarErro('O nome é obrigatório.');
      return false;
    }

    if (raController.text.isEmpty) {
      mostrarErro('O RA é obrigatório.');
      return false;
    }

    if (cursoSelecionado == null) {
      mostrarErro('Por favor, selecione um curso.');
      return false;
    }

    final semestre = int.tryParse(semestreController.text);
    if (semestre == null || semestre < 1 || semestre > 12) {
      mostrarErro('Informe um semestre válido (1 a 12).');
      return false;
    }

    if (!emailController.text.contains('@') || !emailController.text.contains('.')) {
      mostrarErro('Informe um e-mail válido.');
      return false;
    }

    if (senhaController.text.length < 6) {
      mostrarErro('A senha deve ter pelo menos 6 caracteres.');
      return false;
    }

    if (senhaController.text != confirmaSenhaController.text) {
      mostrarErro('As senhas não coincidem.');
      return false;
    }

    return true;
  }

  Future<bool> cadastrarUsuario() async {
    final supabase = Supabase.instance.client;
    final hashedSenha = BCrypt.hashpw(senhaController.text, BCrypt.gensalt());

    try {
      await supabase.auth.signUp(
        email: emailController.text,
        password: senhaController.text,
      );

      await supabase.from('usuarios').insert({
        'nome': nomeController.text,
        'ra': raController.text,
        'curso': cursoSelecionado,
        'semestre': semestreController.text,
        'email': emailController.text,
        'senha': hashedSenha,
      });

      if (!context.mounted) return false;
      return true;
    } catch (error) {
      debugPrint('Erro no cadastro: $error');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(35),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0x8078DA49),
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: raController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0x8078DA49),
                      labelText: 'RA',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0x8078DA49),
                      labelText: 'Curso',
                      border: OutlineInputBorder(),
                    ),
                    value: cursoSelecionado,
                    hint: const Text('Selecione um curso'),
                    onChanged: (String? novoCurso) {
                      setState(() {
                        cursoSelecionado = novoCurso;
                      });
                    },
                    items: cursos.map((String curso) {
                      return DropdownMenuItem<String>(
                        value: curso,
                        child: Text(curso),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: semestreController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0x8078DA49),
                      labelText: 'Semestre',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0x8078DA49),
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    obscureText: true,
                    controller: senhaController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0x8078DA49),
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    obscureText: true,
                    controller: confirmaSenhaController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0x8078DA49),
                      labelText: 'Confirme a senha',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (!validarCampos()) return;

                          bool sucesso = await cadastrarUsuario();
                          if (sucesso) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          } else {
                            mostrarErro('Erro ao cadastrar usuário');
                          }
                        },
                        child: const Text('Cadastrar'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: const Text('Voltar'),
                      ),
                    ],
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