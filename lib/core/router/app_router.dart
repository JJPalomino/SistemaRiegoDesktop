import 'package:go_router/go_router.dart';
import 'package:sistema_riego_desktop/features/auth/presentation/login_page.dart';
import 'package:sistema_riego_desktop/features/home/presentation/home_shell.dart';
import 'package:sistema_riego_desktop/features/parcels/presentation/parcels_page.dart';
import 'package:sistema_riego_desktop/features/siembras/presentation/siembras_page.dart';
import 'package:sistema_riego_desktop/features/recommendation/presentation/recommendation_page.dart';
import 'package:sistema_riego_desktop/features/history/presentation/history_page.dart';
import 'package:sistema_riego_desktop/features/reports/presentation/reports_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => HomeShell(child: child),
        routes: [
          GoRoute(
            path: '/parcels',
            name: 'parcels',
            builder: (context, state) => const ParcelsPage(),
          ),
          GoRoute(
            path: '/siembras',
            name: 'siembras',
            builder: (context, state) => const SiembrasPage(),
          ),
          GoRoute(
            path: '/recommendation',
            name: 'recommendation',
            builder: (context, state) => const RecommendationPage(),
          ),
          GoRoute(
            path: '/history',
            name: 'history',
            builder: (context, state) => const HistoryPage(),
          ),
          GoRoute(
            path: '/reports',
            name: 'reports',
            builder: (context, state) => const ReportsPage(),
          ),
        ],
      ),
    ],
  );
}
