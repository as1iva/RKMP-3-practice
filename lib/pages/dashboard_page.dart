import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TravelAppState>();
    final d = state.selectedDestination;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Travel Navigator', style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 8),
                const Text(
                  'Добро пожаловать! Это главный экран вашего путешествия. '
                      'Выберите направление, постройте маршрут и отмечайте посещённые места.',
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.account_circle, size: 48),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Профиль путешественника', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                            SizedBox(height: 4),
                            Text('Имя: Тимофей Фадеев • Группа: ИКБО-12-22'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.place, size: 28),
                            const SizedBox(width: 8),
                            Text('Текущее направление', style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Theme.of(context).dividerColor),
                          ),
                          child: Text(
                            d == null
                                ? 'Не выбрано. Перейдите во вкладку «Направления».'
                                : '${d.name}, ${d.country} • Точек: ${d.stops.length}',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _goTab(context, 1),
                                icon: const Icon(Icons.map),
                                label: const Text('Направления'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _goTab(context, 2),
                                icon: const Icon(Icons.route),
                                label: const Text('Маршрут'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => _goTab(context, 4),
                            icon: const Icon(Icons.info_outline),
                            label: const Text('Справка'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (d != null) ...[
                  Row(
                    children: [
                      const Icon(Icons.timeline),
                      const SizedBox(width: 8),
                      const Text('Ваш прогресс'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: state.progress),
                  const SizedBox(height: 6),
                  Text('${state.completedStops} из ${state.totalStops} посещено'),
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void _goTab(BuildContext context, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          switch (index) {
            1 => 'Перейдите во вкладку «Направления» (иконка карты) внизу.',
            2 => 'Перейдите во вкладку «Маршрут» (иконка маршрута) внизу.',
            4 => 'Перейдите во вкладку «Справка» (иконка i) внизу.',
            _ => 'Откройте нужную вкладку внизу экрана.',
          },
        ),
      ),
    );
  }
}
