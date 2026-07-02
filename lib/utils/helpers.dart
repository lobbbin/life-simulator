import 'dart:math';
import 'package:intl/intl.dart';

class Helpers {
  static final Random _random = Random();

  /// Generate a random number between min and max (inclusive)
  static int randomInt(int min, int max) {
    return min + _random.nextInt(max - min + 1);
  }

  /// Generate a random double between min and max
  static double randomDouble(double min, double max) {
    return min + _random.nextDouble() * (max - min);
  }

  /// Pick a random element from a list
  static T randomElement<T>(List<T> list) {
    return list[_random.nextInt(list.length)];
  }

  /// Format money value
  static String formatMoney(double amount) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return '\$${formatter.format(amount)}';
  }

  /// Format large numbers with K, M, B suffixes
  static String formatLargeNumber(double value) {
    if (value >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(1)}B';
    } else if (value >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(1)}M';
    } else if (value >= 1e3) {
      return '${(value / 1e3).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }

  /// Get age description
  static String ageDescription(int age) {
    if (age <= 5) return 'Toddler';
    if (age <= 10) return 'Child';
    if (age <= 13) return 'Pre-teen';
    if (age <= 18) return 'Teenager';
    if (age <= 25) return 'Young Adult';
    if (age <= 40) return 'Adult';
    if (age <= 60) return 'Middle-aged';
    if (age <= 75) return 'Senior';
    return 'Elderly';
  }

  /// Get life stage from age
  static String lifeStage(int age) {
    if (age <= 5) return 'Early Childhood';
    if (age <= 10) return 'Childhood';
    if (age <= 13) return 'Pre-adolescence';
    if (age <= 18) return 'Adolescence';
    if (age <= 25) return 'Emerging Adulthood';
    if (age <= 40) return 'Early Adulthood';
    if (age <= 60) return 'Middle Adulthood';
    if (age <= 75) return 'Late Adulthood';
    return 'Elderly Years';
  }

  /// Determine if an education level is required for a career
  static bool requiresDegree(String careerType) {
    const degreeCareers = ['doctor', 'lawyer', 'engineer', 'architect', 'pharmacist',
      'professor', 'scientist', 'psychologist', 'veterinarian', 'dentist'];
    return degreeCareers.contains(careerType.toLowerCase());
  }

  /// Get stat change description
  static String statChangeDescription(Map<String, dynamic>? changes) {
    if (changes == null || changes.isEmpty) return '';

    final parts = <String>[];
    changes.forEach((key, value) {
      final numValue = (value as num).toDouble();
      final sign = numValue >= 0 ? '+' : '';
      parts.add('$key $sign${numValue.toStringAsFixed(0)}');
    });

    return '[${parts.join(', ')}]';
  }
}
