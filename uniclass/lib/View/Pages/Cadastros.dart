import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../layout.dart';

class CadastrosPage extends StatefulWidget {
  const CadastrosPage({super.key});

  @override
  State<CadastrosPage> createState() => _CadastrosPageState();
}

class _CadastrosPageState extends State<CadastrosPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<dynamic> usuarios = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsuarios();
  }

  Future<void> fetchUsuarios() async {
    try {
      final data = await supabase
          .from('webUser')
          .select('id, name, email, isAdm')
          .order('name', ascending: true);

      setState(() {
        usuarios = data as List<dynamic>;
        isLoading = false;
      });
    } catch (error) {
      print('Erro ao buscar usuários: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  void showCadastroDialog(BuildContext context) {
    final nomeController = TextEditingController();
    final telefoneController = TextEditingController();
    final emailController = TextEditingController();
    final senhaController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    bool _obscureText = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;

        return AlertDialog(
          title: Text('Preecha os dados:'),
          content: SizedBox(
            width: screenWidth * 0.5,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nomeController,
                      decoration: InputDecoration(labelText: 'Nome'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Informe o nome'
                          : null,
                    ),
                    TextFormField(
                      controller: telefoneController,
                      decoration: InputDecoration(labelText: 'Telefone'),
                      keyboardType: TextInputType.phone,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Informe o email'
                          : null,
                    ),
                    TextFormField(
                      controller: senhaController,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            _obscureText = !_obscureText;
                            (context as Element).markNeedsBuild();
                          },
                        ),
                      ),
                      obscureText: _obscureText,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Informe a senha'
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    // 1. Cria o usuário no auth.users
                    final authResponse = await supabase.auth.signUp(
                      email: emailController.text,
                      password: senhaController.text,
                    );

                    final user = authResponse.user;

                    if (user != null) {
                      // 2. Insere na tabela webUser com o user_id
                      await supabase.from('webUser').insert({
                        'user_id': user.id,
                        'name': nomeController.text,
                        'email': emailController.text,
                        'phone': telefoneController.text,
                        'isAdm': false,
                      });

                      Navigator.pop(context);
                      fetchUsuarios();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Funcionário adicionado com sucesso')),
                      );
                    } else {
                      throw Exception('Erro ao criar usuário no auth.');
                    }
                  } catch (e) {
                    print('Erro ao cadastrar: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao salvar dados: $e')),
                    );
                  }
                }
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Cadastros de Funcionários',
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 35, horizontal: 0),
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showCadastroDialog(context);
                      },
                      icon: Icon(Icons.add),
                      label: Text('Adicionar Funcionário'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    itemCount: usuarios.length,
                    itemBuilder: (context, index) {
                      final user = usuarios[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(user['name'] ?? 'Sem nome'),
                          subtitle: Text(user['email'] ?? 'Sem email'),
                          trailing: IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/editar_funcionario',
                                arguments: user['id'],
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
