import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sistema_riego_desktop/core/network/api_error.dart';
import 'package:sistema_riego_desktop/core/utils/etiquetas.dart';
import 'package:sistema_riego_desktop/features/history/providers/history_provider.dart';
import 'package:sistema_riego_desktop/features/parcels/providers/parcels_provider.dart';
import 'package:sistema_riego_desktop/features/recommendation/data/models/recommendation_models.dart';
import 'package:sistema_riego_desktop/features/recommendation/providers/recommendation_provider.dart';
import 'package:sistema_riego_desktop/features/siembras/providers/siembras_provider.dart';

class RecommendationPage extends ConsumerStatefulWidget {
  const RecommendationPage({super.key});

  @override
  ConsumerState<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends ConsumerState<RecommendationPage> {
  int? _selectedSiembraId;
  bool _useSiembra = true;

  @override
  Widget build(BuildContext context) {
    final parcelsState = ref.watch(parcelsProvider);
    final siembrasState = ref.watch(siembrasProvider);
    final recommendationState = ref.watch(recommendationProvider);
    final selectedParcelaId = ref.watch(selectedParcelaIdProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recomendación de riego',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: const Text('Usar una siembra registrada'),
                    subtitle: const Text(
                        'La recomendación se guarda en el historial de la siembra.'),
                    value: _useSiembra,
                    onChanged: (v) => setState(() => _useSiembra = v),
                  ),
                  const SizedBox(height: 12),
                  if (_useSiembra) ...[
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
                  ],
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: recommendationState.isLoading
                        ? null
                        : () => _generateRecommendation(ref),
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Generar recomendación'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: recommendationState.when(
              data: (rec) {
                if (rec == null) {
                  return const Center(
                      child: Text('Genera una recomendación para ver los resultados'));
                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Cultivo: ${rec.nombreHortaliza}',
                                  style: Theme.of(context).textTheme.titleLarge),
                              Text('Etapa: ${etapaEtiqueta(rec.etapa)} • Días: ${rec.diasSiembra}'),
                              if (rec.idConsulta != null)
                                Text('ID de consulta: ${rec.idConsulta}'),
                              Text('Nivel de urgencia: ${urgenciaEtiqueta(rec.nivelUrgenciaMax)}'),
                              if (rec.demoMode)
                                const Chip(label: Text('Modo de demostración')),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _TarjetaClima(clima: rec.clima),
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Recomendación de riego',
                                  style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Text(rec.recomendacionRiego),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Recomendación general',
                                  style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Text(rec.recomendacionGeneral),
                            ],
                          ),
                        ),
                      ),
                      if (rec.alertas.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Alertas',
                                    style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: 8),
                                ...rec.alertas.map((a) => Padding(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 4),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.warning,
                                            color: _getAlertColor(a.nivel),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                              child: Text(
                                                  '[${urgenciaEtiqueta(a.nivel)}] ${a.descripcion}')),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
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

  Color _getAlertColor(String? nivel) {
    switch (nivel) {
      case 'critica':
        return Colors.red;
      case 'precaucion':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  Future<void> _generateRecommendation(WidgetRef ref) async {
    if (_useSiembra && _selectedSiembraId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecciona una siembra')));
      return;
    }
    final solicitud = SolicitudRecomendacion(
      siembraId: _useSiembra ? _selectedSiembraId : null,
      parcelaId: _useSiembra ? ref.read(selectedParcelaIdProvider) : null,
    );
    await ref.read(recommendationProvider.notifier).getRecommendation(solicitud);
    if (!mounted) return;
    if (ref.read(recommendationProvider).hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              apiErrorMessage(ref.read(recommendationProvider).error!)),
        ),
      );
      return;
    }
    final siembraId = _selectedSiembraId;
    if (siembraId != null) {
      // La recomendacion quedo registrada en el historial de la siembra.
      await ref.read(historyProvider.notifier).load(siembraId);
    }
  }
}

/// Fecha ISO (`2026-10-28`) en formato local corto (`28/10/2026`).
String _fechaCorta(String? iso) {
  if (iso == null || iso.trim().isEmpty) return '';
  final fecha = DateTime.tryParse(iso);
  return fecha == null ? iso : DateFormat('dd/MM/yyyy').format(fecha);
}

/// Valor con unidad y decimales fijos; `null` si el clima no trajo el dato.
String? _medida(double? valor, String unidad, {int decimales = 1}) =>
    valor == null ? null : '${valor.toStringAsFixed(decimales)} $unidad';

/// Dato climático listo para mostrar, o `null` si el clima no lo trajo.
Widget? _datoClima({
  required IconData icono,
  required String etiqueta,
  required String? valor,
}) =>
    valor == null
        ? null
        : _DatoClima(icono: icono, etiqueta: etiqueta, valor: valor);

/// Datos del pronóstico de Open-Meteo con los que se generó la recomendación.
class _TarjetaClima extends StatelessWidget {
  const _TarjetaClima({required this.clima});

  final ClimaPronostico clima;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inicio = _fechaCorta(clima.fechaInicioPronostico);
    final fin = _fechaCorta(clima.fechaFinPronostico);
    final rango = inicio.isEmpty || fin.isEmpty
        ? '${clima.diasPronostico} días'
        : '$inicio a $fin (${clima.diasPronostico} días)';
    final fuente = clima.fuente == 'open_meteo' ? 'Open-Meteo' : clima.fuente;
    final ubicacion =
        '${clima.latitud.toStringAsFixed(4)}, ${clima.longitud.toStringAsFixed(4)}';

    final datos = <Widget?>[
      _datoClima(
        icono: Icons.place_outlined,
        etiqueta: 'Ubicación',
        valor: ubicacion,
      ),
      _datoClima(
        icono: Icons.water_drop_outlined,
        etiqueta: 'Precipitación acumulada',
        valor: _medida(clima.precipitacionMm, 'mm'),
      ),
      _datoClima(
        icono: Icons.air,
        etiqueta: 'Evapotranspiración',
        valor: _medida(clima.evapotranspiracionRefMm, 'mm'),
      ),
      _datoClima(
        icono: Icons.thermostat,
        etiqueta: 'Temperatura máxima',
        valor: _medida(clima.tempMaxC, '°C'),
      ),
      _datoClima(
        icono: Icons.ac_unit,
        etiqueta: 'Temperatura mínima',
        valor: _medida(clima.tempMinC, '°C'),
      ),
      _datoClima(
        icono: Icons.water,
        etiqueta: 'Humedad relativa',
        valor: _medida(clima.humedadRelativaPct, '%'),
      ),
      _datoClima(
        icono: Icons.opacity,
        etiqueta: 'Punto de rocío',
        valor: _medida(clima.puntoRocioC, '°C'),
      ),
      _datoClima(
        icono: Icons.speed,
        etiqueta: 'Velocidad del viento',
        valor: _medida(clima.velocidadVientoKmh, 'km/h'),
      ),
      _datoClima(
        icono: Icons.umbrella_outlined,
        etiqueta: 'Probabilidad de lluvia',
        valor: _medida(clima.probabilidadPrecipitacionPct, '%'),
      ),
      _datoClima(
        icono: Icons.wb_sunny_outlined,
        etiqueta: 'Radiación solar',
        valor: _medida(clima.radiacionSolarWm2, 'W/m²', decimales: 0),
      ),
      _datoClima(
        icono: Icons.cloud_outlined,
        etiqueta: 'Cobertura de nubes',
        valor: _medida(clima.coberturaNubesPct, '%'),
      ),
      _datoClima(
        icono: Icons.grass,
        etiqueta: 'Humedad del suelo',
        valor: _medida(clima.humedadSueloPct, '%'),
      ),
      _datoClima(
        icono: Icons.thermostat_auto,
        etiqueta: 'Temperatura del suelo',
        valor: _medida(clima.temperaturaSueloC, '°C'),
      ),
    ].whereType<Widget>().toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.cloud_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text('Datos climáticos del pronóstico',
                    style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '$rango · Fuente: $fuente',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 14,
              children: datos,
            ),
          ],
        ),
      ),
    );
  }
}

class _DatoClima extends StatelessWidget {
  const _DatoClima({
    required this.icono,
    required this.etiqueta,
    required this.valor,
  });

  final IconData icono;
  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 220,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  etiqueta,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                Text(valor, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
