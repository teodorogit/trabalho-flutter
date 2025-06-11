import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uniclass/View/Constantes/app_colors.dart';

class AppLayout extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? floatingActionButton;

  const AppLayout({
    super.key,
    required this.title,
    required this.child,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 200,
            color: AppColors.highlightOrange,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DrawerHeader(
                  child: Image.asset(
                    'assets/images/uniclass-removebg-preview.png',
                    width: 120,
                  ),
                ),
                SidebarItem(label: 'Home', route: '/home'),
                SidebarItem(label: 'Ensalamento', route: '/Ensalamento'),
                SidebarItem(label: 'Salas', route: '/Salas'),
                SidebarItem(label: 'Turmas', route: '/Turmas'),
                SidebarItem(label: 'Cursos', route: '/Cursos'),
                SidebarItem(label: 'Perfil', route: '/Perfil'),
                Spacer(),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.white),
                  title: Text('Sair', style: TextStyle(color: Colors.white)),
                  onTap: () async {
                    await Supabase.instance.client.auth.signOut();
                    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                  },
                ),
              ],
            ),
          ),
          // Conteúdo principal
          Expanded(
            child: Column(
              children: [
                Container(
                  color: AppColors.primaryGreen,
                  padding: EdgeInsets.all(16),
                  width: double.infinity,
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      child,
                      if (floatingActionButton != null)
                        Positioned(
                          bottom: 24,
                          right: 24,
                          child: floatingActionButton!,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final String label;
  final String route;

  const SidebarItem({super.key, required this.label, required this.route});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: TextStyle(color: Colors.white)),
      onTap: () {
        if (ModalRoute.of(context)?.settings.name != route) {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }
}
