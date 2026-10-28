import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_riego_desktop/core/network/api_error.dart';
import 'package:sistema_riego_desktop/features/parcels/data/models/parcela_models.dart';
import 'package:sistema_riego_desktop/features/parcels/providers/parcels_provider.dart';

class ParcelsPage extends ConsumerWidget {
  const ParcelsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parcelsState = ref.watch(parcelsProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Parcelas',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              FilledButton.icon(
                onPressed: () => _showCreateDialog(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Nueva parcela'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: parcelsState.when(
              data: (parcels) {
                if (parcels.isEmpty) {
                  return const Center(child: Text('No hay parcelas registradas'));
                }
                return Card(
                  child: ListView.separated(
                    itemCount: parcels.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final parcela = parcels[index];
                      return ListTile(
                        leading: const Icon(Icons.landscape),
                        title: Text(parcela.nombre),
                        subtitle: Text(
                            '${parcela.latitud}, ${parcela.longitud} • ${parcela.texturaSuelo.label}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Editar parcela',
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _showEditDialog(context, ref, parcela),
                            ),
                            IconButton(
                              tooltip: 'Eliminar parcela',
                              icon: const Icon(Icons.delete),
                              onPressed: () => _confirmDelete(context, ref, parcela),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text(apiErrorMessage(e))),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _ParcelaDialog(
        onSave: (data) async {
          await ref.read(parcelsProvider.notifier).create(data);
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, Parcela parcela) {
    showDialog(
      context: context,
      builder: (context) => _ParcelaDialog(
        parcela: parcela,
        onSave: (data) async {
          await ref.read(parcelsProvider.notifier).update(parcela.id, data);
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Parcela parcela) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar parcela'),
        content: Text('¿Deseas eliminar la parcela "${parcela.nombre}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          FilledButton(
            onPressed: () async {
              await ref.read(parcelsProvider.notifier).delete(parcela.id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

class _ParcelaDialog extends StatefulWidget {
  const _ParcelaDialog({this.parcela, required this.onSave});
  final Parcela? parcela;
  final Future<void> Function(ParcelaCreate) onSave;

  @override
  State<_ParcelaDialog> createState() => _ParcelaDialogState();
}

class _ParcelaDialogState extends State<_ParcelaDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _latController;
  late final TextEditingController _lngController;
  late final TextEditingController _altController;
  late final TextEditingController _areaController;
  late final TextEditingController _notasController;
  TexturaSuelo _textura = TexturaSuelo.franco;
  bool _activa = true;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.parcela?.nombre);
    _latController =
        TextEditingController(text: widget.parcela?.latitud.toString());
    _lngController =
        TextEditingController(text: widget.parcela?.longitud.toString());
    _altController = TextEditingController(
        text: widget.parcela?.altitudMsnm?.toString() ?? '');
    _areaController =
        TextEditingController(text: widget.parcela?.areaM2?.toString() ?? '');
    _notasController = TextEditingController(text: widget.parcela?.notas ?? '');
    if (widget.parcela != null) {
      _textura = widget.parcela!.texturaSuelo;
      _activa = widget.parcela!.activa;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _altController.dispose();
    _areaController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final data = ParcelaCreate(
      nombre: _nombreController.text.trim(),
      latitud: double.parse(_latController.text),
      longitud: double.parse(_lngController.text),
      altitudMsnm: _altController.text.isEmpty
          ? null
          : double.parse(_altController.text),
      areaM2:
          _areaController.text.isEmpty ? null : double.parse(_areaController.text),
      texturaSuelo: _textura,
      activa: _activa,
      notas: _notasController.text.isEmpty ? null : _notasController.text.trim(),
    );
    await widget.onSave(data);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.parcela == null ? 'Nueva parcela' : 'Editar parcela'),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _latController,
                        decoration: const InputDecoration(labelText: 'Latitud'),
                        keyboardType: TextInputType.number,
                        validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _lngController,
                        decoration: const InputDecoration(labelText: 'Longitud'),
                        keyboardType: TextInputType.number,
                        validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _altController,
                        decoration: const InputDecoration(labelText: 'Altitud (msnm)'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _areaController,
                        decoration: const InputDecoration(labelText: 'Área (m²)'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<TexturaSuelo>(
                  initialValue: _textura,
                  decoration: const InputDecoration(labelText: 'Textura del suelo'),
                  items: TexturaSuelo.values
                      .map((e) => DropdownMenuItem(
                          value: e, child: Text(e.label)))
                      .toList(),
                  onChanged: (v) => setState(() => _textura = v!),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('Activa'),
                  value: _activa,
                  onChanged: (v) => setState(() => _activa = v),
                ),
                TextFormField(
                  controller: _notasController,
                  decoration: const InputDecoration(labelText: 'Notas'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar')),
        FilledButton(onPressed: _submit, child: const Text('Guardar')),
      ],
    );
  }
}
