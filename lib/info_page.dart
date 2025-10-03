import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const [
      ('Главный экран', 'Быстрые действия, выбор вкладок, сводка.'),
      ('Направления', 'Выбор города/страны и старт маршрута.'),
      ('Маршрут', 'Список точек с отметкой посещения.'),
      ('Прогресс', 'Индикатор выполнения и сброс.'),
      ('Справка', 'Описание функциональности и навигации.'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('О приложении', style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 8),
                const Text(
                  'Travel Navigator — учебное кроссплатформенное приложение на Flutter '
                      'для демонстрации смены контента между логически связанными экранами.',
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 16),
                ...items.map(
                      (e) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_outline),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.$1, style: const TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text(e.$2),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => _hintBack(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Назад'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _hintBack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Вернитесь на вкладку «Главная» (иконка домика) внизу.'),
      ),
    );
  }
}
