import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../layout.dart';

class EnsalamentoPage extends StatefulWidget {
  const EnsalamentoPage({super.key});

  @override
  State<EnsalamentoPage> createState() => _EnsalamentoPageState();
}

class _EnsalamentoPageState extends State<EnsalamentoPage> {
  List<dynamic> ensalamentos = [];
  List<dynamic> turmas = [];
  List<dynamic> salas = [];
  List<dynamic> cursos = [];
  List<dynamic> professores = [];

  bool carregando = true;

  String? turmaFiltradaId;

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    try {
      final client = Supabase.instance.client;

      final ens = await client
          .from('ensalamento')
          .select('*, cursos(name), professor(name), salas(name), turmas(name)')
          .order('created_at', ascending: false);

      final t = await client.from('turmas').select();
      final s = await client.from('salas').select();
      final c = await client.from('cursos').select();
      final p = await client.from('professor').select();

      setState(() {
        ensalamentos = ens;
        turmas = t;
        salas = s;
        cursos = c;
        professores = p;
        carregando = false;
      });
    } catch (e) {
      print('Erro ao carregar dados: $e');
      setState(() {
        carregando = false;
      });
    }
  }

  void showAddEnsalamentoDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? turmaId;
    String? salaId;
    String? cursoId;
    String? professorId;
    String? diaSemana;
    String? horarioSelecionado;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Criar Ensalamento'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: turmaId,
                  hint: const Text('Selecione a turma'),
                  items: turmas.map((t) {
                    return DropdownMenuItem(
                      value: t['turma_id'].toString(),
                      child: Text(t['name']),
                    );
                  }).toList(),
                  onChanged: (val) => turmaId = val,
                  validator: (val) => val == null ? 'Selecione a turma' : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: cursoId,
                  hint: const Text('Selecione o curso'),
                  items: cursos.map((c) {
                    return DropdownMenuItem(
                      value: c['curso_id'].toString(),
                      child: Text(c['name']),
                    );
                  }).toList(),
                  onChanged: (val) => cursoId = val,
                  validator: (val) => val == null ? 'Selecione o curso' : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: professorId,
                  hint: const Text('Selecione o professor'),
                  items: professores.map((p) {
                    return DropdownMenuItem(
                      value: p['professor_id'].toString(),
                      child: Text(p['name']),
                    );
                  }).toList(),
                  onChanged: (val) => professorId = val,
                  validator: (val) => val == null ? 'Selecione o professor' : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: salaId,
                  hint: const Text('Selecione a sala'),
                  items: salas.map((s) {
                    return DropdownMenuItem(
                      value: s['sala_id'].toString(),
                      child: Text(s['name']),
                    );
                  }).toList(),
                  onChanged: (val) => salaId = val,
                  validator: (val) => val == null ? 'Selecione a sala' : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: diaSemana,
                  hint: const Text('Dia da semana'),
                  items: ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta']
                      .map((dia) => DropdownMenuItem(
                            value: dia,
                            child: Text(dia),
                          ))
                      .toList(),
                  onChanged: (val) => diaSemana = val,
                  validator: (val) => val == null ? 'Informe o dia' : null,
                ),
                const SizedBox(height: 20),
                const Text('Selecione o horário:'),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('1º Horário\n19:00 - 20:45'),
                        value: '1',
                        groupValue: horarioSelecionado,
                        onChanged: (val) => setState(() => horarioSelecionado = val),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('2º Horário\n20:55 - 22:30'),
                        value: '2',
                        groupValue: horarioSelecionado,
                        onChanged: (val) => setState(() => horarioSelecionado = val),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          ElevatedButton(
              onPressed: () async {
                if ((_formKey.currentState?.validate() ?? false) &&
                    horarioSelecionado != null) {
                  String inicio = '';
                  String fim = '';

                  if (horarioSelecionado == '1') {
                    inicio = '19:00';
                    fim = '20:45';
                  } else if (horarioSelecionado == '2') {
                    inicio = '20:55';
                    fim = '22:30';
                  }

                  try {
                    await Supabase.instance.client.from('ensalamento').insert({
                      'turma_id': int.parse(turmaId!),
                      'sala_id': int.parse(salaId!),
                      'curso_id': int.parse(cursoId!),
                      'professor_id': int.parse(professorId!),
                      'dia_semana': diaSemana,
                      'horario_inicio': inicio,
                      'horario_fim': fim,
                    });

                    Navigator.pop(context);
                    fetchAllData();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ensalamento salvo com sucesso')),
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao salvar: $e')),
                    );
                  }
                }
              },
              child: const Text('Salvar')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ensalamentosFiltrados = turmaFiltradaId == null
        ? ensalamentos
        : ensalamentos.where((e) => e['turma_id'].toString() == turmaFiltradaId).toList();

    return AppLayout(
      title: 'Ensalamento',
      child: carregando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: DropdownButtonFormField<String>(
                          value: turmaFiltradaId,
                          hint: const Text('Filtrar por turma'),
                          isExpanded: true,
                          items: turmas.map((t) {
                            return DropdownMenuItem(
                              value: t['turma_id'].toString(),
                              child: Text(t['name']),
                            );
                          }).toList()
                            ..insert(
                              0,
                              const DropdownMenuItem(value: null, child: Text('Todas as turmas')),
                            ),
                          onChanged: (val) {
                            setState(() {
                              turmaFiltradaId = val;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () => showAddEnsalamentoDialog(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Novo Ensalamento'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: ensalamentosFiltrados.length,
                    itemBuilder: (context, index) {
                      final ens = ensalamentosFiltrados[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        color: const Color.fromARGB(255, 238, 239, 237),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Curso: ${ens['cursos']['name'] ?? '---'}'),
                              Text('Turma: ${ens['turmas']['name'] ?? '---'}'),
                              Text('Professor: ${ens['professor']['name'] ?? '---'}'),
                              Text('Sala: ${ens['salas']['name'] ?? '---'}'),
                              Text('Dia: ${ens['dia_semana'] ?? '---'}'),
                              Text('Horário: ${ens['horario_inicio']} - ${ens['horario_fim']}'),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.green),
                                  onPressed: () {
                                    // Chamar a função de edição
                                  },
                                ),
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
