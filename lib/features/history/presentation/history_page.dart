import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_riego_desktop/core/network/api_error.dart';
import 'package:sistema_riego_desktop/features/history/data/models/history_models.dart';
import 'package:sistema_riego_desktop/features/history/providers/history_provider.dart';
import 'package:sistema_riego_desktop/features/parcels/providers/parcels_provider.dart';
import 'package:sistema_riego_desktop/features/siembras/providers/siembras_provider.dart';
import 'package:intl/intl.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  int? _selectedSiembraId;

  @override
  Widget build(BuildContext context) {
    final parcelsState = ref.watch(parcelsProvider);
    final siembrasState = ref.watch(siembrasProvider);
    final historyState = ref.watch(historyProvider);
    final selectedParcelaId = ref.watch(selectedParcelaIdProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Historial de recomendaciones',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  parcelsState.when(
                    data: (parcelas) => DropdownButtonFormField<int>(
                      initialValue: selectedParcelaId,
                      decoration: const InputDecoration(
                        labelText: 'Parcela',
                        border: OutlineInputBorder(),
                      ),
                      items: parcelas
                          .map((p) =>
                              DropdownMenuItem(value: p.id, child: Text(p.nombre)))
                          .toList(),
                      onChanged: (v) {
                        ref.read(selectedParcelaIdProvider.notifier).state = v;
                        setState(() => _selectedSiembraId = null);
                      },
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (e, st) => Text(apiErrorMessage(e)),
                  ),
                  const SizedBox(height: 12),
                  if (selectedParcelaId != null)
                    siembrasState.when(
                      data: (siembras) => DropdownButtonFormField<int>(
                        initialValue: _selectedSiembraId,
                        decoration: const InputDecoration(
                          labelText: 'Siembra',
                          border: OutlineInputBorder(),
                        ),
                        items: siembras
                            .map((s) => DropdownMenuItem(
                                value: s.id,
                                child: Text(
                                    '${s.nombreHortaliza ?? "Hortaliza"} - ${s.diasDesdeSiembra} días')))
                            .toList(),
                        onChanged: (v) {
                          setState(() => _selectedSiembraId = v);
                          if (v != null) {
                            ref.read(historyProvider.notifier).load(v);
                          }
                        },
                      ),
                      loading: () => const LinearProgressIndicator(),
                      error: (e, st) => Text(apiErrorMessage(e)),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _selectedSiembraId == null
                ? const Center(
                    child: Text('Selecciona una siembra para ver el historial'))
                : historyState.when(
                    data: (history) {
                      if (history.isEmpty) {
                        return const Center(
                            child: Text('No hay recomendaciones en el historial'));
                      }
                      return Card(
                        child: ListView.separated(
                          itemCount: history.length,
                          separatorBuilder: (context, index) =>
                              const Divider(),
                          itemBuilder: (context, index) {
                            final item = history[index];
                            return ListTile(
                              leading: const Icon(Icons.history),
                              title: Text(
                                  '${item.nombreHortaliza} - ${item.etapa ?? "N/A"}'),
                              subtitle: Text(
                                  '${DateFormat('dd/MM/yyyy HH:mm').format(item.consultadoEn ?? DateTime.now())} • Urgencia: ${item.nivelUrgenciaMax}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.visibility),
                                onPressed: () =>
                                    _showDetailDialog(context, ref, item.id),
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

  void _showDetailDialog(BuildContext context, WidgetRef ref, int consultaId) {
    showDialog(
      context: context,
      builder: (context) => _HistoryDetailDialog(consultaId: consultaId),
    );
  }
}

class _HistoryDetailDialog extends ConsumerWidget {
  const _HistoryDetailDialog({required this.consultaId});
  final int consultaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(historyRepositoryProvider);

    return FutureBuilder<ConsultaRecomendacionDetalle>(
      future: repo.getHistoryDetail(consultaId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AlertDialog(
            content: SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        if (snapshot.hasError) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(apiErrorMessage(snapshot.error!)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar')),
            ],
          );
        }
        final detail = snapshot.data!;
        return AlertDialog(
          title: Text('Detalle - ${detail.nombreHortaliza}'),
          content: SizedBox(
            width: 600,
            height: 500,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Etapa: ${detail.etapa ?? "N/A"} • Días: ${detail.diasSiembra}'),
                  Text('Consultado: ${DateFormat('dd/MM/yyyy HH:mm').format(detail.consultadoEn ?? DateTime.now())}'),
                  Text('Modelo: ${detail.modeloLlm ?? "N/A"}'),
                  Text('Nivel: ${detail.nivelUrgenciaMax}'),
                  const Divider(),
                  Text('Recomendación de riego',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(detail.recomendacionRiego),
                  const SizedBox(height: 12),
                  Text('Recomendación general',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(detail.recomendacionGeneral),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar')),
          ],
        );
      },
    );
  }
}
