import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uniclass/telas/login_page/login_page.dart';
import 'package:bcrypt/bcrypt.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  // Lista de cursos disponíveis
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

  Future<bool> cadastrarUsuario() async {
    final supabase = Supabase.instance.client;

    // Verifica se as senhas são iguais
    if (senhaController.text != confirmaSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem!')),
      );
      return false;
    }

    final hashedSenha = BCrypt.hashpw(senhaController.text, BCrypt.gensalt());

    try {
      await supabase.auth.signUp(
        email: emailController.text,
        password: senhaController.text,
      );

      print("Nome: ${nomeController.text}");
      print("RA: ${raController.text}");
      print("Curso: $cursoSelecionado");
      print("Semestre: ${semestreController.text}");
      print("Email: ${emailController.text}");
      print("Senha: ${senhaController.text}");

      // Adicionar usuário na tabela "usuarios"
      await supabase.from('usuarios').insert({
        'nome': nomeController.text,
        'ra': raController.text,
        'curso': cursoSelecionado,
        'semestre': semestreController.text,
        'email': emailController.text,
        'senha': hashedSenha
      });

      return true;
    } catch (error) {
      print('Erro no cadastro: $error');
      return false;
    }
  }

  // Valor selecionado no dropdown
  String? cursoSelecionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Cadastro')),
        body: Center(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: nomeController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0x8078DA49),
                        labelText: 'Nome',
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: raController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0x8078DA49),
                        labelText: 'RA',
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 15),

                  // 🔽 Dropdown substituindo o campo "Curso"
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0x8078DA49),
                      labelText: 'Curso',
                      border: OutlineInputBorder(),
                    ),
                    value: cursoSelecionado,
                    hint: Text('Selecione um curso'),
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

                  const SizedBox(height: 15),
                  TextField(
                    controller: semestreController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0x8078DA49),
                        labelText: 'Semestre',
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0x8078DA49),
                        labelText: 'Email',
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    obscureText: true,
                    controller: senhaController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0x8078DA49),
                        labelText: 'Senha',
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    obscureText: true,
                    controller: confirmaSenhaController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0x8078DA49),
                        labelText: 'Confirme a senha',
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          bool sucesso = await cadastrarUsuario();
                          if (sucesso) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Erro ao cadastrar usuário')),
                            );
                          }
                        },
                        child: Text('Cadastrar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
