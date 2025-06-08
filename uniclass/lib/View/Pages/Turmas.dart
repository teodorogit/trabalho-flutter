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
  bool carregando = true;
  final TextEditingController buscaController = TextEditingController();
  String termoBusca = '';

  @override
  void initState() {
    super.initState();
    fetchTurmas();
  }

  Future<void> fetchTurmas() async {
    try {
      final data = await supabase
          .from('turmas')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        turmas = data as List<dynamic>;
        carregando = false;
      });
    } catch (error) {
      print('Erro ao buscar turmas: $error');
      setState(() {
        carregando = false;
      });
    }
  }

  List get turmasFiltradas {
    if (termoBusca.isEmpty) return turmas;
    return turmas.where((turma) {
      final nome = (turma['name'] ?? '').toString().toLowerCase();
      return nome.contains(termoBusca);
    }).toList();
  }

  void showAddTurmaDialog(BuildContext context) {
    final nomeController = TextEditingController();
    final periodoController = TextEditingController();
    final alunosController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Adicionar nova turma'),
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
                    decoration:
                        const InputDecoration(labelText: 'Nome da turma'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Informe o nome' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: periodoController,
                    decoration: const InputDecoration(labelText: 'Período'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Informe o período' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: alunosController,
                    decoration: const InputDecoration(
                      labelText: 'Quantidade de alunos',
                      hintText: 'Apenas número da quantidade',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Informe a quantidade';
                      if (int.tryParse(value) == null)
                        return 'Informe um número válido';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                final nome = nomeController.text.trim();
                final periodo = periodoController.text.trim();
                final alunos =
                    int.tryParse(alunosController.text.trim()) ?? 0;

                try {
                  final existing = await supabase
                      .from('turmas')
                      .select()
                      .eq('name', nome)
                      .eq('periodo', periodo)
                      .eq('qnt_alunos', alunos);

                  if (existing.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Já existe uma turma com esses dados.'),
                      ),
                    );
                    return;
                  }

                  await supabase.from('turmas').insert({
                    'name': nome,
                    'periodo': periodo,
                    'qnt_alunos': alunos,
                  });

                  Navigator.pop(context);
                  fetchTurmas();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Turma adicionada com sucesso')),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao adicionar turma: $e')),
                  );
                }
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void showEditTurmaDialog(BuildContext context, Map<String, dynamic> turma) {
    final nomeController = TextEditingController(text: turma['name'] ?? '');
    final periodoController =
        TextEditingController(text: turma['periodo']?.toString() ?? '');
    final alunosController =
        TextEditingController(text: turma['qnt_alunos']?.toString() ?? '0');
    final _formKey = GlobalKey<FormState>();
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Editar turma'),
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
                    decoration:
                        const InputDecoration(labelText: 'Nome da turma'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Informe o nome' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: periodoController,
                    decoration: const InputDecoration(labelText: 'Período'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Informe o período' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: alunosController,
                    decoration: const InputDecoration(
                      labelText: 'Quantidade de alunos',
                      hintText: 'Apenas número da quantidade',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Informe a quantidade de alunos';
                      if (int.tryParse(value) == null)
                        return 'Informe um número válido';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                final nome = nomeController.text.trim();
                final periodo = periodoController.text.trim();
                final alunos =
                    int.tryParse(alunosController.text.trim()) ?? 0;

                try {
                  await supabase.from('turmas').update({
                    'name': nome,
                    'periodo': periodo,
                    'qnt_alunos': alunos,
                  }).eq('turma_id', turma['turma_id']);

                  Navigator.pop(context);
                  fetchTurmas();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Turma atualizada com sucesso')),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao editar turma: $e')),
                  );
                }
              }
            },
            child: const Text('Salvar alterações'),
          ),
        ],
      ),
    );
  }

  void showDeleteTurmaDialog(BuildContext context, Map<String, dynamic> turma) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Tem certeza que deseja excluir a turma "${turma['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await supabase
                    .from('turmas')
                    .delete()
                    .eq('turma_id', turma['turma_id']);

                Navigator.pop(context);
                fetchTurmas();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Turma excluída com sucesso')),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao excluir turma: $e')),
                );
              }
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Turmas',
      child: carregando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 50, 16, 50),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: buscaController,
                          decoration: InputDecoration(
                            hintText: 'Buscar por nome...',
                            prefixIcon: const Icon(Icons.search),
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
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () => showAddTurmaDialog(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar turma'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: turmasFiltradas.isEmpty
                      ? const Center(child: Text('Nenhuma turma cadastrada.'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: turmasFiltradas.length,
                          itemBuilder: (context, index) {
                            final turma = turmasFiltradas[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              color: const Color(0xFFF8F3FA),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        turma['name'] ?? 'Sem nome',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Período: ${turma['periodo'] ?? '---'}',
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Alunos: ${turma['qnt_alunos'] ?? 0}',
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.green),
                                      onPressed: () {
                                        showEditTurmaDialog(context, turma);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        showDeleteTurmaDialog(context, turma);
                                      },
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
