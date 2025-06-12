import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../layout.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int totalEstudantes = 0;
  int totalCursos = 0;
  int totalSalas = 0;
  int totalHorarios = 0;

  List<dynamic> estudantesRecentes = [];
  Map<String, int> estudantesPorCurso = {};
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      final client = Supabase.instance.client;

      final estudantes = await client.from('mobileUser').select();
      final cursos = await client.from('cursos').select();
      final salas = await client.from('salas').select();
      final ensalamento = await client.from('ensalamento').select();

      final cursoContagem = <String, int>{};
      for (var est in estudantes) {
        final curso = est['curso'] ?? 'Desconhecido';
        cursoContagem[curso] = (cursoContagem[curso] ?? 0) + 1;
      }

      setState(() {
        totalEstudantes = estudantes.length;
        totalCursos = cursos.length;
        totalSalas = salas.length;
        totalHorarios = ensalamento.length;

        estudantesRecentes = estudantes.take(5).toList();
        estudantesPorCurso = cursoContagem;
        carregando = false;
      });
    } catch (e) {
      print('Erro ao carregar dados do dashboard: $e');
      setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hoje = DateTime.now();
    final saudacao = hoje.hour < 12
        ? 'Bom dia'
        : hoje.hour < 18
            ? 'Boa tarde'
            : 'Boa noite';

    return AppLayout(
      title: 'Dashboard',
      child: carregando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Color.fromRGBO(56, 142, 60, 1),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$saudacao, Secretária!',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text('Bem-vindo(a) ao sistema Uniclass',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14)),
                              const SizedBox(height: 4),
                              Text('Hoje é ${hoje.day}/${hoje.month}/${hoje.year}',
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                          const Icon(Icons.school,
                              color: Colors.white, size: 48),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildResumoBox('Estudantes', totalEstudantes, Icons.person),
                      _buildResumoBox('Cursos', totalCursos, Icons.book),
                      _buildResumoBox('Salas', totalSalas, Icons.meeting_room),
                      _buildResumoBox('Horários', totalHorarios, Icons.schedule),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: _buildListaEstudantesRecentes()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildEstudantesPorCurso()),
                    ],
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildResumoBox(String titulo, int valor, IconData icone) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icone, size: 32, color: Colors.blueGrey),
              const SizedBox(height: 8),
              Text('$valor',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(titulo,
                  style: const TextStyle(
                      fontSize: 14, color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListaEstudantesRecentes() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Estudantes Recentes',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            for (var est in estudantesRecentes)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                    '${est['nome']} - ${est['curso']} - ${est['semestre'] ?? ""}º Semestre'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstudantesPorCurso() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Estudantes por Curso',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            for (var entry in estudantesPorCurso.entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key),
                    Text('${entry.value}'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
