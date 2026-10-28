import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sistema_riego_desktop/core/network/api_error.dart';
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
  bool _restoring = true;
  bool _isRegister = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _restoreSession());
  }

  Future<void> _restoreSession() async {
    await ref.read(authStateProvider.notifier).restoreSession();
    if (!mounted) return;
    final state = ref.read(authStateProvider);
    if (state.hasValue && state.value != null) {
      context.go('/parcels');
      return;
    }
    setState(() => _restoring = false);
  }

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
    final cargando = authState.isLoading || _restoring;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 440,
            padding: const EdgeInsets.all(32),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.water_drop,
                        size: 48,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Sistema de Riego',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tlatlauquitepec, Puebla',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
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
                              : (seleccion) => _cambiarModo(seleccion.first),
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
                            border: OutlineInputBorder(),
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
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Requerido';
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
                          helperText: _isRegister
                              ? 'Al menos 8 caracteres'
                              : null,
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: const OutlineInputBorder(),
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
                      FilledButton(
                        onPressed: cargando ? null : _submit,
                        child: cargando
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(_isRegister ? 'Crear cuenta' : 'Iniciar sesión'),
                      ),
                      if (authState.hasError) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.errorContainer
                                .withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            apiErrorMessage(authState.error!),
                            style: TextStyle(color: colorScheme.error),
                          ),
                        ),
                      ],
                      if (_isRegister) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Al crear la cuenta se inicia sesión automáticamente.',
                          style: Theme.of(context).textTheme.bodySmall,
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
    );
  }
}
