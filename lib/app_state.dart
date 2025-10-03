import 'package:flutter/material.dart';

class Destination {
  final String id;
  final String name;
  final String country;
  final List<String> stops;

  const Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.stops,
  });
}

class TravelAppState extends ChangeNotifier {
  final List<Destination> _destinations = const [
    Destination(
      id: 'spain_barcelona',
      name: 'Барселона',
      country: 'Испания',
      stops: [
        'Саграда Фамилия',
        'Готический квартал',
        'Парк Гуэль',
        'Дом Мила',
        'Пляж Барселонета',
      ],
    ),
    Destination(
      id: 'italy_rome',
      name: 'Рим',
      country: 'Италия',
      stops: [
        'Колизей',
        'Форум',
        'Фонтан Треви',
        'Пантеон',
        'Площадь Навона',
      ],
    ),
    Destination(
      id: 'germany_berlin',
      name: 'Берлин',
      country: 'Германия',
      stops: [
        'Бранденбургские ворота',
        'Музейный остров',
        'Рейхстаг',
        'Ист-Сайд-Галере',
        'Потсдамская площадь',
      ],
    ),
  ];

  Destination? _selected;
  int _completed = 0;

  List<Destination> get destinations => _destinations;
  Destination? get selectedDestination => _selected;
  int get completedStops => _completed;
  int get totalStops => _selected?.stops.length ?? 0;

  double get progress =>
      totalStops == 0 ? 0.0 : (_completed / totalStops).clamp(0.0, 1.0);

  void selectDestination(Destination d) {
    _selected = d;
    _completed = 0;
    notifyListeners();
  }

  void markStopVisited() {
    if (_selected == null) return;
    if (_completed < totalStops) {
      _completed += 1;
      notifyListeners();
    }
  }

  void resetProgress() {
    _completed = 0;
    notifyListeners();
  }
}
