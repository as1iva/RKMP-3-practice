import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';

class TripPage extends StatefulWidget {
  const TripPage({super.key});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  final TextEditingController _noteController = TextEditingController();
  bool _autoMarkNext = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TravelAppState>();
    final d = state.selectedDestination;

    if (d == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.place_outlined, size: 64),
              const SizedBox(height: 12),
              const Text('Направление не выбрано'),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _hintGoDestinations(context),
                icon: const Icon(Icons.map_outlined),
                label: const Text('Выбрать направление'),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${d.name}, ${d.country}', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text('Точек маршрута: ${d.stops.length}'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Switch(
                      value: _autoMarkNext,
                      onChanged: (v) {
                        setState(() => _autoMarkNext = v);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text(v
                                ? 'Авто-отметка включена: после сохранения заметки отметим следующую точку.'
                                : 'Авто-отметка отключена.'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    const Expanded(child: Text('Авто-отмечать следующую точку после сохранения заметки')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: d.stops.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final stop = d.stops[i];
                final visited = i < state.completedStops;

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: ListTile(
                    leading: Icon(
                      visited ? Icons.check_circle : Icons.radio_button_unchecked,
                    ),
                    title: Text(stop),
                    subtitle: Text(visited ? 'Посещено' : 'Ожидает посещения'),
                    trailing: ElevatedButton(
                      onPressed: visited ? null : state.markStopVisited,
                      child: const Text('Отметить'),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Заметка к поездке'),
                const SizedBox(height: 8),
                TextField(
                  controller: _noteController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Например: купить билеты на обзорную экскурсию',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          _noteController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text('Заметка очищена'),
                            ),
                          );
                        },
                        child: const Text('Очистить'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final text = _noteController.text.trim();
                          if (text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text('Введите текст заметки перед сохранением'),
                              ),
                            );
                            return;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text('Заметка сохранена: "$text"'),
                            ),
                          );
                          if (_autoMarkNext && state.completedStops < state.totalStops) {
                            state.markStopVisited();
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: const Text('Сохранить заметку'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: state.resetProgress,
                  child: const Text('Сбросить маршрут'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: state.completedStops >= state.totalStops
                      ? null
                      : state.markStopVisited,
                  icon: const Icon(Icons.flag),
                  label: const Text('Отметить след. точку'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _hintGoDestinations(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Откройте вкладку «Направления» снизу, чтобы выбрать город.'),
      ),
    );
  }
}
