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
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController raController = TextEditingController();
  final TextEditingController semestreController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmaSenhaController = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();
  final raController = TextEditingController();


  List<String> cursos = [];
  bool carregandoCursos = true;
  String? cursoSelecionado;

  @override
  void initState() {
    super.initState();
    buscarCursosDoBanco();
  }

  Future<void> buscarCursosDoBanco() async {
    final supabase = Supabase.instance.client;
    try {
      final response =
          await supabase.from('cursos').select('name').order('name');

      // Remove duplicatas e limpa espaços
      final List<String> nomesCursos = response
          .map<String>((curso) => curso['name'].toString().trim())
          .toSet() // Remove duplicados
          .toList();

      setState(() {
        cursos = nomesCursos;
        // Garante que o cursoSelecionado ainda existe após atualizar a lista
        if (!cursos.contains(cursoSelecionado)) {
          cursoSelecionado = null;
        }
        carregandoCursos = false;
      });
    } catch (e) {
      setState(() {
        carregandoCursos = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar cursos: $e')),
      );
    }
  }

  Future<bool> cadastrarUsuario() async {
    final supabase = Supabase.instance.client;

    if (senhaController.text != confirmaSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem!')),
      );
      return false;
    }

    try {
      final authResponse = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: senhaController.text.trim(),
      );

      final user = authResponse.user;
      if (user == null) {
        return false;
      }

      await supabase.from('mobileUser').insert({
        'id': user.id,
        'nome': nomeController.text.trim(),
        'ra': raController.text.trim(),
        'curso': cursoSelecionado,
        'semestre': semestreController.text.trim(),
        'email': emailController.text.trim(),
      });

      return true;
    } catch (error) {
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
            child: SingleChildScrollView(
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
                    Form(
                    key: _formKey,
                    child: TextFormField(
                    controller: raController,
                    decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0x8078DA49),
                    labelText: 'RA',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                  return 'O RA não pode estar vazio';
                  } else if (value.length < 6) {
                   return 'O RA deve ter pelo menos 6 caracteres';
                   } else if (value.length > 12) {
                   return 'O RA deve ter no máximo 12 caracteres';
                }
                  return null;
                  },
                  ),
                  ),

                  const SizedBox(height: 10),
                  carregandoCursos
                      ? CircularProgressIndicator()
                      : DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0x8078DA49),
                            labelText: 'Curso',
                            border: OutlineInputBorder(),
                          ),
                          value: cursos.contains(cursoSelecionado)
                              ? cursoSelecionado
                              : null,
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Fundo verde
                          foregroundColor: Colors.white, // Texto branco
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          textStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
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
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Fundo verde
                          foregroundColor: Colors.white, // Texto branco
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          textStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
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
      ),
    );
  }
}
