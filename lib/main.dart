import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'database/app_database.dart';
import 'providers/chat_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/simulation_provider.dart';
import 'providers/player_provider.dart';
import 'providers/time_provider.dart';
import 'providers/career_provider.dart';
import 'providers/education_provider.dart';
import 'services/ai_service.dart';
import 'services/memory_service.dart';
import 'services/time_service.dart';
import 'services/event_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();
  await database.initialize();

  final aiService = AiService();
  final memoryService = MemoryService(database);
  final timeService = TimeService();
  final eventService = EventService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider(database)),
        ChangeNotifierProvider(create: (_) => TimeProvider(timeService)),
        ChangeNotifierProvider(create: (_) => ChatProvider(aiService, memoryService)),
        ChangeNotifierProvider(create: (_) => SimulationProvider(
          database, aiService, memoryService, timeService, eventService,
        )),
        ChangeNotifierProvider(create: (_) => CareerProvider(database)),
        ChangeNotifierProvider(create: (_) => EducationProvider(database)),
      ],
      child: const LifeSimulatorApp(),
    ),
  );
}
