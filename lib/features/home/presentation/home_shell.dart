import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_riego_desktop/core/theme/app_theme.dart';
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
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(right: BorderSide(color: AppColors.borde)),
            ),
            child: NavigationRail(
              extended: true,
              minExtendedWidth: 252,
              leading: const _Marca(),
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
          ),
          Expanded(
            child: Column(
              children: [
                _BarraSuperior(
                  nombre: user?.nombre,
                  onLogout: () async {
                    await ref.read(authStateProvider.notifier).logout();
                    if (context.mounted) context.go('/login');
                  },
                ),
                Expanded(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFF3F9EC), Color(0xFFFBFDF8)],
                      ),
                    ),
                    child: child,
                  ),
                ),
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

/// Encabezado de la barra lateral: logo y nombre del sistema.
class _Marca extends StatelessWidget {
  const _Marca();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.verdeMedio, AppColors.verdeOscuro],
                  ),
                ),
                child: const Icon(Icons.water_drop,
                    color: Colors.white, size: 23),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sistema de Riego',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.verdeOscuro,
                      ),
                    ),
                    Text(
                      'Tlatlauquitepec, Puebla',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textoSuave,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            height: 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              gradient: const LinearGradient(
                colors: [AppColors.verde, AppColors.amarillo],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Barra superior con el nombre del usuario y el cierre de sesión.
class _BarraSuperior extends StatelessWidget {
  const _BarraSuperior({this.nombre, required this.onLogout});

  final String? nombre;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final texto = (nombre ?? '').trim();
    final inicial = texto.isEmpty ? '?' : texto[0].toUpperCase();

    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.borde)),
      ),
      child: Row(
        children: [
          const Icon(Icons.agriculture, color: AppColors.verde, size: 24),
          const SizedBox(width: 10),
          Text('Panel de riego',
              style: Theme.of(context).textTheme.titleMedium),
          const Spacer(),
          if (texto.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(6, 6, 14, 6),
              decoration: BoxDecoration(
                color: AppColors.verdeSuave,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.borde),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: AppColors.verde,
                    child: Text(
                      inicial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    texto,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.verdeOscuro,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: onLogout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
