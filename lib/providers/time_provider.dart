import 'package:flutter/material.dart';
import '../services/time_service.dart';

class TimeProvider extends ChangeNotifier {
  final TimeService _timeService;

  TimeProvider(this._timeService);

  TimeService get timeService => _timeService;
  String get formattedDateTime => _timeService.formattedDateTime;
  String get season => _timeService.season;
  String get weather => _timeService.weather;
  String get timeOfDay => _timeService.timeOfDay;
  int get timeMultiplier => _timeService.timeMultiplier;
  bool get isRunning => _timeService.isRunning;

  void advanceTime({int minutes = 30}) {
    _timeService.advanceTime(minutes: minutes);
    notifyListeners();
  }

  void setTimeMultiplier(int multiplier) {
    _timeService.setTimeMultiplier(multiplier);
    notifyListeners();
  }

  void start() {
    _timeService.start();
    notifyListeners();
  }

  void pause() {
    _timeService.pause();
    notifyListeners();
  }

  String get holiday {
    final h = _timeService.getHoliday();
    return h;
  }

  bool get isWeekend => _timeService.isWeekend;
  String get dayOfWeek => _timeService.dayOfWeek;
}
