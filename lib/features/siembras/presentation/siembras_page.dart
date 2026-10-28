import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_riego_desktop/core/network/api_error.dart';
import 'package:sistema_riego_desktop/features/crops/data/crops_repository.dart';
import 'package:sistema_riego_desktop/features/parcels/providers/parcels_provider.dart';
import 'package:sistema_riego_desktop/features/siembras/data/models/siembra_models.dart';
import 'package:sistema_riego_desktop/features/siembras/providers/siembras_provider.dart';

class SiembrasPage extends ConsumerWidget {
  const SiembrasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parcelasState = ref.watch(parcelsProvider);
    final selectedParcelaId = ref.watch(selectedParcelaIdProvider);
    final siembrasState = ref.watch(siembrasProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Siembras',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (selectedParcelaId != null)
                FilledButton.icon(
                  onPressed: () => _showCreateDialog(context, ref),
                  icon: const Icon(Icons.add),
                  label: const Text('Nueva siembra'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          parcelasState.when(
            data: (parcelas) => DropdownButtonFormField<int>(
              initialValue: selectedParcelaId,
              decoration: const InputDecoration(
                labelText: 'Seleccionar parcela',
                border: OutlineInputBorder(),
              ),
              items: parcelas
                  .map((p) => DropdownMenuItem(value: p.id, child: Text(p.nombre)))
                  .toList(),
              onChanged: (v) {
                ref.read(selectedParcelaIdProvider.notifier).state = v;
              },
            ),
            loading: () => const LinearProgressIndicator(),
            error: (e, st) => Text(apiErrorMessage(e)),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: selectedParcelaId == null
                ? const Center(
                    child: Text('Selecciona una parcela para ver sus siembras'))
                : siembrasState.when(
                    data: (siembras) {
                      if (siembras.isEmpty) {
                        return const Center(
                            child: Text('No hay siembras registradas'));
                      }
                      return Card(
                        child: ListView.separated(
                          itemCount: siembras.length,
                          separatorBuilder: (context, index) =>
                              const Divider(),
                          itemBuilder: (context, index) {
                            final siembra = siembras[index];
                            return ListTile(
                              leading: const Icon(Icons.grass),
                              title: Text(siembra.nombreHortaliza ?? 'Hortaliza'),
                              subtitle: Text(
                                  'Siembra: ${siembra.fechaSiembra} • Días: ${siembra.diasDesdeSiembra} • Activa: ${siembra.activa ? "Sí" : "No"}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Editar siembra',
                                    icon: const Icon(Icons.edit),
                                    onPressed: () =>
                                        _showEditDialog(context, siembra),
                                  ),
                                  IconButton(
                                    tooltip: 'Eliminar siembra',
                                    icon: const Icon(Icons.delete),
                                    onPressed: () =>
                                        _confirmDelete(context, ref, siembra),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, st) => Center(child: Text(apiErrorMessage(e))),
                  ),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    // Recarga el catalogo para ver hortalizas agregadas recientemente.
    ref.invalidate(cropsProvider);
    showDialog(
      context: context,
      builder: (context) => const _SiembraDialog(),
    );
  }

  void _showEditDialog(BuildContext context, Siembra siembra) {
    showDialog(
      context: context,
      builder: (context) => _SiembraDialog(siembra: siembra),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Siembra siembra) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar siembra'),
        content: const Text('¿Deseas eliminar esta siembra?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          FilledButton(
            onPressed: () async {
              try {
                await ref.read(siembrasProvider.notifier).delete(siembra.id);
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(apiErrorMessage(e))),
                );
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

class _SiembraDialog extends ConsumerStatefulWidget {
  const _SiembraDialog({this.siembra});

  /// Si es null el dialogo crea una siembra; si no, edita la existente.
  final Siembra? siembra;

  @override
  ConsumerState<_SiembraDialog> createState() => _SiembraDialogState();
}

class _SiembraDialogState extends ConsumerState<_SiembraDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _notasController;
  int? _hortalizaId;
  late DateTime _fechaSiembra;
  DateTime? _fechaCosecha;
  late bool _activa;
  bool _saving = false;
  String? _error;

  static String _aFecha(DateTime d) => d.toIso8601String().substring(0, 10);

  @override
  void initState() {
    super.initState();
    final s = widget.siembra;
    final cosecha = s?.fechaCosecha;
    _hortalizaId = s?.hortalizaId;
    _fechaSiembra =
        s == null ? DateTime.now() : DateTime.parse(s.fechaSiembra);
    _fechaCosecha = (cosecha == null || cosecha.isEmpty)
        ? null
        : DateTime.tryParse(cosecha);
    _activa = s?.activa ?? true;
    _notasController = TextEditingController(text: s?.notas ?? '');
  }

  @override
  void dispose() {
    _notasController.dispose();
    super.dispose();
  }

  Future<void> _elegirFechaSiembra() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaSiembra,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _fechaSiembra = picked;
        if (_fechaCosecha != null && _fechaCosecha!.isBefore(picked)) {
          _fechaCosecha = null;
        }
      });
    }
  }

  Future<void> _elegirFechaCosecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaCosecha ?? _fechaSiembra,
      firstDate: _fechaSiembra,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _fechaCosecha = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_hortalizaId == null) return;

    setState(() {
      _saving = true;
      _error = null;
    });

    final data = SiembraCreate(
      hortalizaId: _hortalizaId!,
      fechaSiembra: _aFecha(_fechaSiembra),
      fechaCosecha: _fechaCosecha == null ? null : _aFecha(_fechaCosecha!),
      activa: _activa,
      notas: _notasController.text.isEmpty ? null : _notasController.text.trim(),
    );

    try {
      final notifier = ref.read(siembrasProvider.notifier);
      final original = widget.siembra;
      if (original == null) {
        await notifier.create(data);
      } else {
        await notifier.update(original.id, data);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      // El backend explica el motivo (p. ej. ciclos que se traslapan).
      if (mounted) setState(() => _error = apiErrorMessage(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cropsState = ref.watch(cropsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(widget.siembra == null ? 'Nueva siembra' : 'Editar siembra'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                cropsState.when(
                  data: (hortalizas) => DropdownButtonFormField<int>(
                    initialValue: _hortalizaId,
                    decoration: const InputDecoration(labelText: 'Hortaliza'),
                    items: hortalizas
                        .map((h) =>
                            DropdownMenuItem(value: h.id, child: Text(h.nombre)))
                        .toList(),
                    onChanged: _saving
                        ? null
                        : (v) => setState(() => _hortalizaId = v),
                    validator: (v) => v == null ? 'Requerido' : null,
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (e, st) => Text(apiErrorMessage(e)),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  enabled: !_saving,
                  title: const Text('Fecha de siembra'),
                  subtitle: Text(_aFecha(_fechaSiembra)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: _elegirFechaSiembra,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  enabled: !_saving,
                  title: const Text('Fecha de cosecha (opcional)'),
                  subtitle: Text(
                    _fechaCosecha == null
                        ? 'Sin cerrar: el ciclo sigue activo'
                        : _aFecha(_fechaCosecha!),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_fechaCosecha != null)
                        IconButton(
                          tooltip: 'Quitar fecha de cosecha',
                          icon: const Icon(Icons.clear),
                          onPressed: _saving
                              ? null
                              : () => setState(() => _fechaCosecha = null),
                        ),
                      const Icon(Icons.event_available),
                    ],
                  ),
                  onTap: _elegirFechaCosecha,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Activa'),
                  value: _activa,
                  onChanged: _saving
                      ? null
                      : (v) => setState(() => _activa = v),
                ),
                TextFormField(
                  controller: _notasController,
                  decoration: const InputDecoration(labelText: 'Notas'),
                  maxLines: 2,
                  enabled: !_saving,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _error!,
                      style: TextStyle(color: colorScheme.onErrorContainer),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Guardar'),
        ),
      ],
    );
  }
}
