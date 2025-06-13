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
  List<dynamic> disciplinas = [];

  String turmaFiltro = '';
  String diaFiltro = '';
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    fetchDados();
  }

  Future<void> fetchDados() async {
    final client = Supabase.instance.client;
    try {
      final dados = await Future.wait([
        client.from('ensalamento').select(),
        client.from('turmas').select(),
        client.from('salas').select(),
        client.from('cursos').select(),
        client.from('professor').select(),
        client.from('Disciplina').select(),
      ]);
      
      setState(() {
        ensalamentos = dados[0];
        turmas = dados[1];
        salas = dados[2];
        cursos = dados[3];
        professores = dados[4];
        disciplinas = dados[5];
        carregando = false;
      });
    } catch (e) {
      print('Erro ao buscar dados: $e');
    }
  }

  List<dynamic> get ensalamentosFiltrados {
    return ensalamentos.where((e) {
      final turmaOk = turmaFiltro.isEmpty || e['turma_id'].toString() == turmaFiltro;
      final diaOk = diaFiltro.isEmpty || e['dia_semana'] == diaFiltro;
      return turmaOk && diaOk;
    }).toList();
  }

  void showEnsalamentoDialog({Map<String, dynamic>? ensalamento}) {
    final _formKey = GlobalKey<FormState>();
    int? turmaId = ensalamento?['turma_id'];
    int? salaId = ensalamento?['sala_id'];
    int? cursoId = ensalamento?['curso_id'];
    int? professorId = ensalamento?['professor_id'];
    String diaSemana = ensalamento?['dia_semana'] ?? 'Segunda';
    int? idDisciplina = ensalamento?['Id_disciplina'];
    TimeOfDay? inicio = ensalamento?['horario_inicio'] != null
        ? TimeOfDay.fromDateTime(DateTime.parse('2020-01-01 ${ensalamento!['horario_inicio']}'))
        : null;
    TimeOfDay? fim = ensalamento?['horario_fim'] != null
        ? TimeOfDay.fromDateTime(DateTime.parse('2020-01-01 ${ensalamento!['horario_fim']}'))
        : null;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(ensalamento == null ? 'Novo Ensalamento' : 'Editar Ensalamento'),
        content: StatefulBuilder(
          builder: (context, setStateDialog) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<int>(
                      value: idDisciplina,
                      decoration: const InputDecoration(labelText: 'Disciplina'),
                      items: disciplinas.map<DropdownMenuItem<int>>((d) {
                        return DropdownMenuItem<int>(
                          value: d['id'],
                          child: Text(d['name_disciplina']),
                        );
                      }).toList(),
                      onChanged: (val) => setStateDialog(() => idDisciplina = val),
                      validator: (val) {
                        if (val == null) return 'Selecione uma disciplina';
                        return null;
                      },
                    ),
                    DropdownButtonFormField(
                      value: turmaId,
                      decoration: const InputDecoration(labelText: 'Turma'),
                      items: turmas.map<DropdownMenuItem<int>>((t) => DropdownMenuItem(
                        value: t['turma_id'],
                        child: Text(t['name']),
                      )).toList(),
                      onChanged: (val) => setStateDialog(() => turmaId = val),
                    ),
                    DropdownButtonFormField(
                      value: salaId,
                      decoration: const InputDecoration(labelText: 'Sala'),
                      items: salas.map<DropdownMenuItem<int>>((s) => DropdownMenuItem(
                        value: s['sala_id'],
                        child: Text(s['name']),
                      )).toList(),
                      onChanged: (val) => setStateDialog(() => salaId = val),
                    ),
                    DropdownButtonFormField(
                      value: cursoId,
                      decoration: const InputDecoration(labelText: 'Curso'),
                      items: cursos.map<DropdownMenuItem<int>>((c) => DropdownMenuItem(
                        value: c['curso_id'],
                        child: Text(c['name']),
                      )).toList(),
                      onChanged: (val) => setStateDialog(() => cursoId = val),
                    ),
                    DropdownButtonFormField(
                      value: professorId,
                      decoration: const InputDecoration(labelText: 'Professor'),
                      items: professores.map<DropdownMenuItem<int>>((p) => DropdownMenuItem(
                        value: p['professor_id'],
                        child: Text(p['name']),
                      )).toList(),
                      onChanged: (val) => setStateDialog(() => professorId = val),
                    ),
                    DropdownButtonFormField(
                      value: diaSemana,
                      decoration: const InputDecoration(labelText: 'Dia da semana'),
                      items: ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta']
                          .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                          .toList(),
                      onChanged: (val) => setStateDialog(() => diaSemana = val!),
                    ),
                    const SizedBox(height: 16),
                    const Text('Horário:'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setStateDialog(() {
                              inicio = const TimeOfDay(hour: 19, minute: 0);
                              fim = const TimeOfDay(hour: 20, minute: 45);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: inicio?.hour == 19 ? Colors.green : null,
                          ),
                          child: const Text('1º Horário'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setStateDialog(() {
                              inicio = const TimeOfDay(hour: 20, minute: 55);
                              fim = const TimeOfDay(hour: 22, minute: 30);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: inicio?.hour == 20 ? Colors.green : null,
                          ),
                          child: const Text('2º Horário'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                final inicioStr = '${inicio!.hour.toString().padLeft(2, '0')}:${inicio!.minute.toString().padLeft(2, '0')}';
                final fimStr = '${fim!.hour.toString().padLeft(2, '0')}:${fim!.minute.toString().padLeft(2, '0')}';

                final dados = {
                  'turma_id': turmaId,
                  'sala_id': salaId,
                  'curso_id': cursoId,
                  'professor_id': professorId,
                  'dia_semana': diaSemana,
                  'horario_inicio': inicioStr,
                  'horario_fim': fimStr,
                  'Id_disciplina': idDisciplina,
                };

                final client = Supabase.instance.client;
                try {
                  if (ensalamento == null) {
                    await client.from('ensalamento').insert(dados);
                  } else {
                    await client
                        .from('ensalamento')  
                        .update(dados)
                        .eq('id', ensalamento['id']);
                  }
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  fetchDados();
                } catch (e) {
                  print('Erro ao salvar: $e');
                }
              }
            },
            child: const Text('Salvar'),
          )
        ],
      ),
    );
  }

  void excluirEnsalamento(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja excluir este ensalamento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await Supabase.instance.client.from('ensalamento').delete().eq('id', id);
        fetchDados();
      } catch (e) {
        print('Erro ao excluir: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Ensalamento',
      child: carregando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField(
                        value: turmaFiltro.isNotEmpty ? turmaFiltro : null,
                        hint: const Text('Filtrar por turma'),
                        items: turmas.map((t) => DropdownMenuItem(
                          value: t['turma_id'].toString(),
                          child: Text(t['name']),
                        )).toList(),
                        onChanged: (val) {
                          setState(() => turmaFiltro = val ?? '');
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField(
                        value: diaFiltro.isNotEmpty ? diaFiltro : null,
                        hint: const Text('Filtrar por dia'),
                        items: ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta']
                            .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                            .toList(),
                        onChanged: (val) {
                          setState(() => diaFiltro = val ?? '');
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          turmaFiltro = '';
                          diaFiltro = '';
                        });
                      },
                      child: const Text('Limpar Filtros'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () => showEnsalamentoDialog(),
                      icon: const Icon(Icons.add),
                      label: const Text('Novo'),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: ensalamentosFiltrados.length,
                    itemBuilder: (context, index) {
                      final e = ensalamentosFiltrados[index];
                      final turmaNome = turmas.firstWhere((t) => t['turma_id'] == e['turma_id'], orElse: () => {'name': 'Desconhecida'})['name'];
                      final salaNome = salas.firstWhere((s) => s['sala_id'] == e['sala_id'], orElse: () => {'name': 'Desconhecida'})['name'];
                      final professorNome = professores.firstWhere((p) => p['professor_id'] == e['professor_id'], orElse: () => {'name': '---'})['name'];
                      final cursoNome = cursos.firstWhere((c) => c['curso_id'] == e['curso_id'], orElse: () => {'name': '---'})['name'];
                      final disciplinaNome = disciplinas.firstWhere((d) => d['id'] == e['id_disciplina'], orElse: () => {'name_disciplina': '---'})['name_disciplina'];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(disciplinaNome),
                          subtitle: Text('Turma: $turmaNome | Sala: $salaNome\nDia: ${e['dia_semana']} - ${e['horario_inicio']} até ${e['horario_fim']}\nCurso: $cursoNome | Professor: $professorNome'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => showEnsalamentoDialog(ensalamento: e),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => excluirEnsalamento(e['id']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
    );
  }
}
