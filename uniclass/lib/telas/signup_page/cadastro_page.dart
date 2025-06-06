import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uniclass/telas/login_page/login.dart';
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

  Future<bool> cadastrarUsuario() async {
    final supabase = Supabase.instance.client;

    if (senhaController.text != confirmaSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem!')),
      );
      return false;
    }

    try {
      // Criação do usuário sem envio de e-mail de confirmação
      final authResponse = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: senhaController.text.trim(),
      );

      final user = authResponse.user;
      if (user == null) {
        print('❌ Erro: usuário nulo após signup');
        return false;
      }

      // Inserção dos dados adicionais
      await supabase.from('mobileUser').insert({
        'id': user.id,
        'nome': nomeController.text.trim(),
        'ra': raController.text.trim(),
        'curso': cursoSelecionado,
        'semestre': semestreController.text.trim(),
        'email': emailController.text.trim(),
      });

      print('✅ Dados inseridos com sucesso em mobileUser');
      return true;
    } catch (error) {
      print('❌ Erro no cadastro: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar: $error')),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro')),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: nomeController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0x8078DA49),
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: raController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0x8078DA49),
                    labelText: 'RA',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: semestreController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0x8078DA49),
                    labelText: 'Semestre',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
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
                  decoration: InputDecoration(
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
                  decoration: InputDecoration(
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
                        bool sucesso = await cadastrarUsuario();
                        if (sucesso) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
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
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text('Voltar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
