import 'package:flutter/material.dart';

extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String titleCase() {
    return split('_')
        .map((word) => word.capitalize())
        .join(' ');
  }

  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }
}

extension IntExtensions on int {
  String toOrdinal() {
    if (this % 100 >= 11 && this % 100 <= 13) {
      return '${this}th';
    }
    switch (this % 10) {
      case 1: return '${this}st';
      case 2: return '${this}nd';
      case 3: return '${this}rd';
      default: return '${this}th';
    }
  }
}

extension DoubleExtensions on double {
  double clampToRange(double min, double max) {
    return clamp(min, max).toDouble();
  }

  String toCurrency({String symbol = '\$', int decimals = 0}) {
    return '$symbol${toStringAsFixed(decimals)}';
  }

  String toPercentage({int decimals = 0}) {
    return '${toStringAsFixed(decimals)}%';
  }
}

extension DateTimeExtensions on DateTime {
  String toDateString() {
    return '${year}/${month.toString().padLeft(2, '0')}/${day.toString().padLeft(2, '0')}';
  }

  String toTimeString() {
    final hour = this.hour > 12 ? this.hour - 12 : (this.hour == 0 ? 12 : this.hour);
    final ampm = this.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${minute.toString().padLeft(2, '0')} $ampm';
  }

  String toDateTimeString() {
    return '$toDateString() ${toTimeString()}';
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => MediaQuery.of(this).size;
  bool get isSmallScreen => MediaQuery.of(this).size.width < 360;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

extension ListExtensions<T> on List<T> {
  T? firstOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  List<T> sortedBy(Comparable Function(T) key) {
    final copy = List<T>.from(this);
    copy.sort((a, b) => key(a).compareTo(key(b)));
    return copy;
  }
}
