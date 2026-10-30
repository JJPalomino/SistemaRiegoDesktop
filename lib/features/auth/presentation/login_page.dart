import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_riego_desktop/core/network/api_error.dart';
import 'package:sistema_riego_desktop/core/theme/app_theme.dart';
import 'package:sistema_riego_desktop/features/auth/providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _isRegister = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _cambiarModo(bool registrarse) {
    setState(() => _isRegister = registrarse);
    ref.read(authStateProvider.notifier).clearError();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(authStateProvider.notifier);
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (_isRegister) {
      await notifier.register(_nombreController.text.trim(), email, password);
    } else {
      await notifier.login(email, password);
    }
    if (!mounted) return;
    final state = ref.read(authStateProvider);
    if (state.hasValue && state.value != null) {
      context.go('/parcels');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final cargando = authState.isLoading;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo agrícola a pantalla completa. Para usar otra foto, reemplaza
          // `assets/images/login_background.jpg` conservando el nombre.
          Image.asset(
            'assets/images/login_background.jpg',
            fit: BoxFit.cover,
            filterQuality: FilterQuality.medium,
          ),
          // Velo verde para que el formulario siempre se lea bien.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xB31B5E20),
                  Color(0x7A2E7D32),
                  Color(0x66103510),
                ],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.97),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.65),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.22),
                          blurRadius: 42,
                          offset: const Offset(0, 18),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Container(
                              width: 68,
                              height: 68,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.verdeMedio,
                                    AppColors.verdeOscuro,
                                  ],
                                ),
                              ),
                              child: const Icon(
                                Icons.water_drop,
                                color: Colors.white,
                                size: 34,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Sistema de Riego',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.verdeOscuro,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tlatlauquitepec, Puebla',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.textoSuave),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 14),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.amarilloSuave,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.eco,
                                      size: 16, color: Color(0xFF7A5B00)),
                                  SizedBox(width: 6),
                                  Text(
                                    'Riego inteligente para tu parcela',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF7A5B00),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: SegmentedButton<bool>(
                              segments: const [
                                ButtonSegment(
                                  value: false,
                                  icon: Icon(Icons.login),
                                  label: Text('Iniciar sesión'),
                                ),
                                ButtonSegment(
                                  value: true,
                                  icon: Icon(Icons.person_add_alt_1),
                                  label: Text('Crear cuenta'),
                                ),
                              ],
                              selected: {_isRegister},
                              onSelectionChanged: cargando
                                  ? null
                                  : (seleccion) =>
                                      _cambiarModo(seleccion.first),
                            ),
                          ),
                          const SizedBox(height: 24),
                          if (_isRegister) ...[
                            TextFormField(
                              controller: _nombreController,
                              enabled: !cargando,
                              decoration: const InputDecoration(
                                labelText: 'Nombre completo',
                                prefixIcon: Icon(Icons.badge_outlined),
                              ),
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              validator: (v) {
                                final nombre = v?.trim() ?? '';
                                if (nombre.isEmpty) return 'Requerido';
                                if (nombre.length < 3) return 'Escribe tu nombre';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                          TextFormField(
                            controller: _emailController,
                            enabled: !cargando,
                            decoration: const InputDecoration(
                              labelText: 'Correo electrónico',
                              prefixIcon: Icon(Icons.mail_outline),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Requerido';
                              }
                              if (!v.contains('@')) return 'Correo inválido';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            enabled: !cargando,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              helperText:
                                  _isRegister ? 'Al menos 8 caracteres' : null,
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(_obscure
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                            ),
                            obscureText: _obscure,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Requerido';
                              if (_isRegister && v.length < 8) {
                                return 'Mínimo 8 caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: cargando ? null : _submit,
                            icon: cargando
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Icon(_isRegister
                                    ? Icons.person_add_alt_1
                                    : Icons.login),
                            label: Text(
                                _isRegister ? 'Crear cuenta' : 'Iniciar sesión'),
                          ),
                          if (authState.hasError) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colorScheme.errorContainer
                                    .withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline,
                                      size: 20, color: colorScheme.error),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      apiErrorMessage(authState.error!),
                                      style:
                                          TextStyle(color: colorScheme.error),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (_isRegister) ...[
                            const SizedBox(height: 12),
                            Text(
                              'Al crear la cuenta se inicia sesión automáticamente.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.textoSuave),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
