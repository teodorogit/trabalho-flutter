import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../layout.dart';

class TurmasPage extends StatefulWidget {
  const TurmasPage({super.key});

  @override
  State<TurmasPage> createState() => _TurmasPageState();
}

class _TurmasPageState extends State<TurmasPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<dynamic> turmas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTurmas();
  }

  Future<void> fetchTurmas() async {
    try {
      final data = await supabase
          .from('turmas')
          .select('id,created_at, name, qnt_alunos, periodo')
          .order('name', ascending: true);

      setState(() {
        turmas = data as List<dynamic>;
        isLoading = false;
      });
    } catch (error) {
      print('Erro ao buscar turmas: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Cadastros de Turmas',
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 35, horizontal: 0),
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/adicionar_turma');
                      },
                      icon: Icon(Icons.add),
                      label: Text('Adicionar Turma'),
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
                    itemCount: turmas.length,
                    itemBuilder: (context, index) {
                      final turma = turmas[index];
                    return Card(
                      color: Color(0xFFF8F3FA),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(turma['name'] ?? 'Sem nome'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Linha 1: quantidade de alunos
                            Text('Alunos: ${turma['qnt_alunos'] ?? 0}'),
                            SizedBox(height: 4),

                            // Linha 2: período
                            Text(turma['periodo'] ?? 'Sem descrição'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/suaRota',
                              arguments: turma,
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
