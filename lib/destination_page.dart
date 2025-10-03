import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';

class DestinationsPage extends StatelessWidget {
  const DestinationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TravelAppState>();
    final list = state.destinations;

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final d = list[i];
        final isSelected = d.id == state.selectedDestination?.id;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).dividerColor,
            ),
          ),
          leading: CircleAvatar(
            child: Text('${d.stops.length}'),
          ),
          title: Text('${d.name} • ${d.country}'),
          subtitle: Text('Основные точки: ${d.stops.take(3).join(", ")}${d.stops.length > 3 ? "..." : ""}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            state.selectDestination(d);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text('Вы выбрали: ${d.name}. Маршрут и прогресс сброшены.'),
              ),
            );
          },
        );
      },
    );
  }
}
