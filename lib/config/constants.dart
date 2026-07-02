class AppConstants {
  AppConstants._();

  // Database
  static const String databaseName = 'life_simulator.db';
  static const int databaseVersion = 1;

  // Player
  static const int startingAge = 3;
  static const double defaultStatValue = 50.0;
  static const double maxStatValue = 100.0;
  static const double minStatValue = 0.0;
  static const double startingMoney = 0.0;

  // Time
  static const int defaultTimeAdvanceMinutes = 30;
  static const int fastForwardMultiplier = 5;
  static const int realTimeTickSeconds = 60;

  // AI
  static const int maxRecentMessages = 50;
  static const int maxContextMessages = 20;
  static const int memoryTrimThreshold = 1000;
  static const int maxSuggestedActions = 5;

  // Education
  static const Map<String, int> educationStages = {
    'kindergarten': 3,
    'elementary': 6,
    'middle_school': 11,
    'high_school': 14,
    'university': 18,
  };

  static const Map<String, int> educationDurations = {
    'kindergarten': 3,
    'elementary': 5,
    'middle_school': 3,
    'high_school': 4,
    'university': 4,
  };

  // Career
  static const int maxActivePaths = 3;
  static const int maxCrewSize = 5;

  // Reputation ranges
  static const double repMin = 0.0;
  static const double repMax = 100.0;

  // Relationship
  static const double relationshipMax = 100.0;
  static const double relationshipMin = 0.0;
  static const double relationshipDecayRate = 0.5;

  // Skills
  static const int maxSkillLevel = 100;
  static const double skillExpPerLevel = 100.0;

  // UI
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;
}
