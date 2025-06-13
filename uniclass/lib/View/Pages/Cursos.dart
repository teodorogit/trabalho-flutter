import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../layout.dart';

class CursosPage extends StatefulWidget {
  const CursosPage({super.key});

  @override
  State<CursosPage> createState() => _CursosPageState();
}

class _CursosPageState extends State<CursosPage> {
  List<dynamic> cursos = [];
  bool carregando = true;
  final TextEditingController buscaController = TextEditingController();
  String termoBusca = '';

  @override
  void initState() {
    super.initState();
    fetchCursos();
  }

  Future<void> fetchCursos() async {
    try {
      final response = await Supabase.instance.client
          .from('cursos')
          .select()
          .order('created_at', ascending: false);
      setState(() {
        cursos = response;
        carregando = false;
      });
    } catch (e) {
      print('Erro ao buscar cursos: $e');
      setState(() {
        carregando = false;
      });
    }
  }

  List get cursosFiltrados {
    if (termoBusca.isEmpty) return cursos;
    return cursos.where((curso) {
      final nome = (curso['name'] ?? '').toString().toLowerCase();
      return nome.contains(termoBusca);
    }).toList();
  }

  void showAddCursoDialog(BuildContext context) {
    final nomeController = TextEditingController();
    final semestreController = TextEditingController();
    final alunosController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Adicionar novo curso'),
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
                    decoration:
                        const InputDecoration(labelText: 'Nome do curso'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Informe o nome'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: semestreController,
                    decoration: const InputDecoration(
                      labelText: 'Semestre',
                      hintText: 'Informe apenas número do semestre 1 ou 2.5',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o semestre';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Informe um número válido';
                      }
                      return null;
                    },
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
                      if (value == null || value.isEmpty) {
                        return 'Informe a quantidade';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Informe um número válido';
                      }
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
              if (formKey.currentState?.validate() ?? false) {
                final nome = nomeController.text.trim();
                final semestre = int.tryParse(semestreController.text.trim()) ?? 0;
                final alunos = int.tryParse(alunosController.text.trim()) ?? 0;

                try {

                  final existing = await Supabase.instance.client
                      .from('cursos')
                      .select()
                      .eq('name', nome)
                      .eq('semestre', semestre)
                      .eq('qnt_alunos', alunos);

                  if (existing.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Já existe um curso com esses dados.')),
                    );
                    return;
                  }

                  await Supabase.instance.client.from('cursos').insert({
                    'name': nome,
                    'semestre': semestre,
                    'qnt_alunos': alunos,
                  });

                  Navigator.pop(context);
                  fetchCursos();
                  ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Curso adicionado com sucesso')),
                );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao adicionar curso: $e')),
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

  void showEditCursoDialog(BuildContext context, Map<String, dynamic> curso) {
    final nomeController = TextEditingController(text: curso['name'] ?? '');
    final semestreController =
        TextEditingController(text: curso['semestre']?.toString() ?? '');
    final alunosController = TextEditingController(
      text: curso['qnt_alunos']?.toString() ?? '0',
    );
    final formKey = GlobalKey<FormState>();
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Editar curso'),
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
                    decoration:
                        const InputDecoration(labelText: 'Nome do curso'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Informe o nome'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: semestreController,
                    decoration: const InputDecoration(
                      labelText: 'Semestre',
                      hintText: 'Informe apenas número do semestre 1 ou 2.5',
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Informe o semestre'
                        : null,
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
                      if (value == null || value.isEmpty) {
                        return 'Informe a quantidade de alunos';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Informe um número válido';
                      }
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
              if (formKey.currentState?.validate() ?? false) {
                final nome = nomeController.text.trim();
                final semestre = semestreController.text.trim();
                final alunos = int.tryParse(alunosController.text.trim()) ?? 0;

                try {
                  await Supabase.instance.client.from('cursos').update({
                    'name': nome,
                    'semestre': semestre,
                    'qnt_alunos': alunos,
                  }).eq('curso_id', curso['curso_id']);
                  Navigator.pop(context);
                  fetchCursos();
                  ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Curso alterado com sucesso')),
                );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao editar curso: $e')),
                  );
                }
              } else {
                print('⚠️ Formulário inválido');
              }
            },
            child: const Text('Salvar alterações'),
          ),
        ],
      ),
    );
  }

  void showDeleteCursoDialog(BuildContext context, Map<String, dynamic> curso) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content:
            Text('Tem certeza que deseja excluir o curso "${curso['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await Supabase.instance.client
                    .from('cursos')
                    .delete()
                    .eq('curso_id', curso['curso_id']);

                Navigator.pop(context);
                fetchCursos();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Curso excluído com sucesso')),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao excluir curso: $e')),
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
      title: 'Cursos',
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
                        onPressed: () => showAddCursoDialog(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar curso'),
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
                  child: cursosFiltrados.isEmpty
                      ? const Center(child: Text('Nenhum curso cadastrado.'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: cursosFiltrados.length,
                          itemBuilder: (context, index) {
                            final curso = cursosFiltrados[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              color: const Color.fromARGB(255, 238, 239, 237),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        curso['name'] ?? 'Sem nome',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Semestre: ${curso['semestre'] ?? '---'}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Alunos: ${curso['qnt_alunos'] ?? 0}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.green),
                                      onPressed: () {
                                        showEditCursoDialog(context, curso);
                                        print(
                                            "Curso selecionado para editar: $curso");
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        showDeleteCursoDialog(context, curso);
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
