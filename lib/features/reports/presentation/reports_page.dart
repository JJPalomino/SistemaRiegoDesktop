import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_riego_desktop/core/network/api_error.dart';
import 'package:sistema_riego_desktop/features/parcels/providers/parcels_provider.dart';
import 'package:sistema_riego_desktop/features/reports/data/reports_repository.dart';
import 'package:sistema_riego_desktop/features/siembras/providers/siembras_provider.dart';

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  int? _selectedSiembraId;
  bool _downloading = false;

  @override
  Widget build(BuildContext context) {
    final parcelsState = ref.watch(parcelsProvider);
    final siembrasState = ref.watch(siembrasProvider);
    final selectedParcelaId = ref.watch(selectedParcelaIdProvider);
    final repo = ReportsRepository();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reportes PDF',
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
                        onChanged: (v) =>
                            setState(() => _selectedSiembraId = v),
                      ),
                      loading: () => const LinearProgressIndicator(),
                      error: (e, st) => Text(apiErrorMessage(e)),
                    ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _selectedSiembraId == null || _downloading
                        ? null
                        : () async {
                            setState(() => _downloading = true);
                            try {
                              await repo.downloadReport(_selectedSiembraId!);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'El reporte se descargó correctamente.')));
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(apiErrorMessage(e))));
                              }
                            } finally {
                              if (mounted) setState(() => _downloading = false);
                            }
                          },
                    icon: _downloading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.picture_as_pdf),
                    label: const Text('Descargar reporte PDF'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Información',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(
                      'El reporte PDF incluye los datos de la siembra, las condiciones climáticas, la recomendación de riego, la recomendación general y las alertas de la última recomendación generada para esa siembra.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
