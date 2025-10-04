import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  bool _showPercent = true;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TravelAppState>();
    final d = state.selectedDestination;

    final percent = (state.progress * 100).round();
    final progressLabel = _showPercent
        ? 'Прогресс: $percent%'
        : 'Прогресс: ${state.completedStops} из ${state.totalStops}';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Сводка по маршруту', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(d == null ? 'Направление не выбрано' : '${d.name}, ${d.country}'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.timeline),
              const SizedBox(width: 8),
              Text(progressLabel),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: state.progress),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Показывать прогресс в процентах'),
            value: _showPercent,
            onChanged: (v) => setState(() => _showPercent = v),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Посещено: ${state.completedStops}'),
                Text('Всего точек: ${state.totalStops}'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: state.resetProgress,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Сбросить прогресс'),
                    ),
                    TextButton.icon(
                      onPressed: () => _hintGoTrip(context),
                      icon: const Icon(Icons.route),
                      label: const Text('К маршруту'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Совет: отмечайте точки на экране «Маршрут», чтобы прогресс обновлялся автоматически.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _hintGoTrip(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Откройте вкладку «Маршрут» (иконка маршрута) внизу.'),
      ),
    );
  }
}
