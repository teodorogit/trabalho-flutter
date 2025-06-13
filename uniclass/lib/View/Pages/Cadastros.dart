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
  bool hasAccess = false;
  bool isAdm = false;
  String? userId;
  final TextEditingController buscaController = TextEditingController();
  String termoBusca = '';

  @override
  void initState() {
    super.initState();
    checkAccess();
  }

  Future<void> checkAccess() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final data = await supabase
          .from('webUser')
          .select('isAdm')
          .eq('user_id', user.id)
          .maybeSingle();

      if (data == null) {
        setState(() {
          hasAccess = false;
          isLoading = false;
        });
        return;
      }

      final adm = data['isAdm'] as bool? ?? false;

      setState(() {
        hasAccess = true;
        isAdm = adm;
        userId = user.id;
      });

      fetchUsuarios();
    } else {
      setState(() {
        hasAccess = false;
        isLoading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    }
  }

  Future<void> fetchUsuarios() async {
    setState(() {
      isLoading = true;
    });

    try {
      var query = supabase.from('webUser').select('*');

      if (!isAdm && userId != null) {
        final safeUserId = userId!;
        query = query.eq('user_id', safeUserId);
      }

      final response = await query;

      setState(() {
        usuarios = response;
        isLoading = false;
      });
    } catch (e) {
      print('Erro ao buscar usuários: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void showEditUserDialog(BuildContext context, dynamic user) {
    final nomeController = TextEditingController(text: user['name']);
    final emailController = TextEditingController(text: user['email']);
    final telefoneController = TextEditingController(text: user['phone'] ?? '');
    final senhaController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool obscureText = true;

    final bool isCurrentUser = userId == user['user_id'];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;

        return AlertDialog(
          title: Text('Editar perfil'),
          content: SizedBox(
            width: screenWidth * 0.5,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nomeController,
                      decoration: InputDecoration(labelText: 'Nome'),
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextFormField(
                      controller: telefoneController,
                      decoration: InputDecoration(labelText: 'Telefone'),
                      keyboardType: TextInputType.phone,
                    ),
                    TextFormField(
                      controller: senhaController,
                      decoration: InputDecoration(
                        labelText: 'Nova Senha',
                        hintText: 'Senha de no mínimo 6 dígitos',
                        suffixIcon: isCurrentUser
                            ? IconButton(
                                icon: Icon(obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  obscureText = !obscureText;
                                  (context as Element).markNeedsBuild();
                                },
                              )
                            : null,
                      ),
                      obscureText: obscureText,
                      enabled: isCurrentUser,
                      validator: (value) {
                        if (!isCurrentUser && (value?.isNotEmpty ?? false)) {
                          return 'Você não pode alterar a senha deste usuário.';
                        }
                        if (isCurrentUser &&
                            value != null &&
                            value.isNotEmpty &&
                            value.length < 6) {
                          return 'Senha deve ter no mínimo 6 dígitos.';
                        }
                        return null;
                      },
                    ),
                    if (!isCurrentUser)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Só é possível alterar a senha do usuário que está logado.',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
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
                if (formKey.currentState!.validate()) {
                  try {
                    await supabase.from('webUser').update({
                      'name': nomeController.text,
                      'email': emailController.text,
                      'phone': telefoneController.text,
                    }).eq('id', user['id']);

                    if (isCurrentUser && senhaController.text.isNotEmpty) {
                      await supabase.auth.updateUser(
                        UserAttributes(password: senhaController.text),
                      );
                    }

                    Navigator.pop(context);
                    fetchUsuarios();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Perfil atualizado!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao atualizar: $e')),
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

  void showAddDialog(BuildContext context) {
    final nomeController = TextEditingController();
    final telefoneController = TextEditingController();
    final emailController = TextEditingController();
    final senhaController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool obscureText = true;

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
                key: formKey,
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
                      decoration: InputDecoration(
                        labelText: 'Telefone',
                        hintText: 'Ex: DDD+9+12345678',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'teste!!*@gmail.com',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Informe o email'
                          : null,
                    ),
                    TextFormField(
                      controller: senhaController,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        hintText: 'Senha de no mínimo 6 dígitos',
                        suffixIcon: IconButton(
                          icon: Icon(obscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            obscureText = !obscureText;
                            (context as Element).markNeedsBuild();
                          },
                        ),
                      ),
                      obscureText: obscureText,
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
                if (formKey.currentState!.validate()) {
                  try {
                    final authResponse = await supabase.auth.signUp(
                      email: emailController.text,
                      password: senhaController.text,
                    );

                    final user = authResponse.user;

                    if (user != null) {
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
                                Text('Perfil adicionado com sucesso')),
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
      title: 'Gerenciamento de perfil',
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(height: 50),
                if (isAdm)
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 50),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: buscaController,
                            decoration: InputDecoration(
                              hintText: 'Buscar por nome ou email...',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                termoBusca = value.toLowerCase();
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            showAddDialog(context);
                          },
                          icon: Icon(Icons.add),
                          label: Text('Adicionar perfil'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: usuarios.length,
                    itemBuilder: (context, index) {
                      final user = usuarios[index];

                      if (termoBusca.isNotEmpty &&
                          !(user['name'] ?? '')
                              .toLowerCase()
                              .contains(termoBusca) &&
                          !(user['email'] ?? '')
                              .toLowerCase()
                              .contains(termoBusca)) {
                        return SizedBox.shrink();
                      }

                      return Card(
                        color: Color.fromARGB(255, 238, 239, 237),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  user['name'] ?? 'Sem nome',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  user['email'] ?? 'Sem email',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  user['phone'] ?? 'Sem telefone',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: Colors.green[700]),
                                    onPressed: () {
                                      showEditUserDialog(context, user);
                                    },
                                  ),
                                  if (isAdm)
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Confirmar exclusão'),
                                            content: Text(
                                                'Deseja realmente remover este perfil?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, false),
                                                child: Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, true),
                                                child: Text('Excluir'),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirm == true) {
                                          try {
                                            await supabase
                                                .from('webUser')
                                                .delete()
                                                .eq('id', user['id']);
                                            fetchUsuarios();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Perfil removido com sucesso'),
                                              ),
                                            );
                                          } catch (e) {
                                            print('Erro ao excluir: $e');
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Erro ao remover perfil: $e'),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    ),
                                ],
                              ),
                            ],
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
