import 'package:intl/intl.dart';

class TimeService {
  DateTime _currentTime = DateTime.now();
  int _timeMultiplier = 1;
  bool _isRunning = false;

  DateTime get currentTime => _currentTime;
  int get timeMultiplier => _timeMultiplier;
  bool get isRunning => _isRunning;

  String get formattedDateTime =>
      DateFormat('EEEE, MMMM d, yyyy – h:mm a').format(_currentTime);

  String get season {
    final month = _currentTime.month;
    if (month >= 3 && month <= 5) return 'Spring';
    if (month >= 6 && month <= 8) return 'Summer';
    if (month >= 9 && month <= 11) return 'Fall';
    return 'Winter';
  }

  String get weather {
    // Simple deterministic weather based on season and day
    final daySeed = _currentTime.day + _currentTime.month;
    final conditions = ['Sunny', 'Cloudy', 'Rainy', 'Windy', 'Clear'];
    if (season == 'Summer') {
      conditions.addAll(['Hot', 'Humid', 'Thunderstorm']);
    } else if (season == 'Winter') {
      conditions.addAll(['Snowy', 'Freezing', 'Blizzard']);
    }
    return conditions[daySeed % conditions.length];
  }

  int get currentHour => _currentTime.hour;
  String get timeOfDay {
    final hour = _currentTime.hour;
    if (hour < 6) return 'Night';
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    if (hour < 21) return 'Evening';
    return 'Night';
  }

  bool get isWeekend =>
      _currentTime.weekday == DateTime.saturday ||
      _currentTime.weekday == DateTime.sunday;

  String get dayOfWeek =>
      DateFormat('EEEE').format(_currentTime);

  void setTimeMultiplier(int multiplier) {
    _timeMultiplier = multiplier.clamp(1, 10);
  }

  void advanceTime({int minutes = 30}) {
    _currentTime = _currentTime.add(Duration(minutes: minutes * _timeMultiplier));
  }

  void setTime(DateTime time) {
    _currentTime = time;
  }

  void start() {
    _isRunning = true;
  }

  void pause() {
    _isRunning = false;
  }

  /// Returns the player's age based on starting age and elapsed in-game time
  int calculateAge(int birthYear) {
    return _currentTime.year - birthYear;
  }

  /// Check if it's the player's birthday
  bool isBirthday(int birthMonth, int birthDay) {
    return _currentTime.month == birthMonth && _currentTime.day == birthDay;
  }

  String getHoliday() {
    final month = _currentTime.month;
    final day = _currentTime.day;

    if (month == 1 && day == 1) return "New Year's Day";
    if (month == 2 && day == 14) return "Valentine's Day";
    if (month == 3 && day == 17) return "St. Patrick's Day";
    if (month == 4 && day == 22) return 'Earth Day';
    if (month == 5 && day == 1) return 'May Day';
    if (month == 6 && day == 21) return 'Summer Solstice';
    if (month == 7 && day == 4) return 'Independence Day';
    if (month == 10 && day == 31) return 'Halloween';
    if (month == 11 && day == 1) return 'All Saints Day';
    if (month == 11 && day <= 7 && _currentTime.weekday == DateTime.thursday) return 'Thanksgiving';
    if (month == 12 && day == 24) return 'Christmas Eve';
    if (month == 12 && day == 25) return 'Christmas Day';
    if (month == 12 && day == 31) return "New Year's Eve";

    return '';
  }

  /// Get education stage based on age
  static String getEducationStage(int age) {
    if (age >= 3 && age <= 5) return 'kindergarten';
    if (age >= 6 && age <= 10) return 'elementary';
    if (age >= 11 && age <= 13) return 'middle_school';
    if (age >= 14 && age <= 17) return 'high_school';
    if (age >= 18 && age <= 22) return 'university';
    return 'adult';
  }
}
