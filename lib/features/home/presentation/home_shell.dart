import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_riego_desktop/features/auth/providers/auth_provider.dart';

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: true,
            minExtendedWidth: 250,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.landscape_outlined),
                selectedIcon: Icon(Icons.landscape),
                label: Text('Parcelas'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.grass_outlined),
                selectedIcon: Icon(Icons.grass),
                label: Text('Siembras'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.lightbulb_outline),
                selectedIcon: Icon(Icons.lightbulb),
                label: Text('Recomendación'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.history_outlined),
                selectedIcon: Icon(Icons.history),
                label: Text('Historial'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.picture_as_pdf_outlined),
                selectedIcon: Icon(Icons.picture_as_pdf),
                label: Text('Reportes'),
              ),
            ],
            selectedIndex: _calculateSelectedIndex(context),
            onDestinationSelected: (index) => _onItemTapped(index, context),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                AppBar(
                  title: const Text('Sistema de Riego - Tlatlauquitepec'),
                  automaticallyImplyLeading: false,
                  actions: [
                    if (user != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Center(child: Text(user.nombre)),
                      ),
                    IconButton(
                      icon: const Icon(Icons.logout),
                      tooltip: 'Cerrar sesión',
                      onPressed: () async {
                        await ref.read(authStateProvider.notifier).logout();
                        if (context.mounted) {
                          context.go('/login');
                        }
                      },
                    ),
                  ],
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/parcels')) return 0;
    if (location.startsWith('/siembras')) return 1;
    if (location.startsWith('/recommendation')) return 2;
    if (location.startsWith('/history')) return 3;
    if (location.startsWith('/reports')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/parcels');
        break;
      case 1:
        context.go('/siembras');
        break;
      case 2:
        context.go('/recommendation');
        break;
      case 3:
        context.go('/history');
        break;
      case 4:
        context.go('/reports');
        break;
    }
  }
}
