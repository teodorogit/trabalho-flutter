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

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Cadastros de Funcionários',
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Botão centralizado com padding mais justo
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 35, horizontal: 0),
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/adicionar_funcionario');
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
