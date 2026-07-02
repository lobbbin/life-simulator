import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'providers/settings_provider.dart';
import 'screens/chat_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/locations_screen.dart';
import 'screens/world_map_screen.dart';
import 'screens/contacts_screen.dart';
import 'screens/npc_detail_screen.dart';
import 'screens/career_screen.dart';
import 'screens/education_screen.dart';
import 'screens/crime_screen.dart';
import 'screens/prison_screen.dart';
import 'screens/politics_screen.dart';
import 'screens/business_screen.dart';
import 'screens/tycoon_screen.dart';
import 'screens/movie_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/timeline_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/will_screen.dart';
import 'screens/life_review_screen.dart';
import 'screens/heir_selection_screen.dart';

class LifeSimulatorApp extends StatelessWidget {
  const LifeSimulatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return MaterialApp(
          title: 'Life Simulator',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,
          initialRoute: AppRoutes.chat,
          onGenerateRoute: _generateRoute,
        );
      },
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.chat:
        return MaterialPageRoute(builder: (_) => const ChatScreen());
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case AppRoutes.inventory:
        return MaterialPageRoute(builder: (_) => const InventoryScreen());
      case AppRoutes.locations:
        return MaterialPageRoute(builder: (_) => const LocationsScreen());
      case AppRoutes.worldMap:
        return MaterialPageRoute(builder: (_) => const WorldMapScreen());
      case AppRoutes.contacts:
        return MaterialPageRoute(builder: (_) => const ContactsScreen());
      case AppRoutes.npcDetail:
        final npcId = settings.arguments as int?;
        return MaterialPageRoute(builder: (_) => NpcDetailScreen(npcId: npcId ?? 0));
      case AppRoutes.career:
        return MaterialPageRoute(builder: (_) => const CareerScreen());
      case AppRoutes.education:
        return MaterialPageRoute(builder: (_) => const EducationScreen());
      case AppRoutes.crime:
        return MaterialPageRoute(builder: (_) => const CrimeScreen());
      case AppRoutes.prison:
        return MaterialPageRoute(builder: (_) => const PrisonScreen());
      case AppRoutes.politics:
        return MaterialPageRoute(builder: (_) => const PoliticsScreen());
      case AppRoutes.business:
        return MaterialPageRoute(builder: (_) => const BusinessScreen());
      case AppRoutes.tycoon:
        return MaterialPageRoute(builder: (_) => const TycoonScreen());
      case AppRoutes.movie:
        return MaterialPageRoute(builder: (_) => const MovieScreen());
      case AppRoutes.calendar:
        return MaterialPageRoute(builder: (_) => const CalendarScreen());
      case AppRoutes.timeline:
        return MaterialPageRoute(builder: (_) => const TimelineScreen());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case AppRoutes.will:
        return MaterialPageRoute(builder: (_) => const WillScreen());
      case AppRoutes.lifeReview:
        return MaterialPageRoute(builder: (_) => const LifeReviewScreen());
      case AppRoutes.heirSelection:
        return MaterialPageRoute(builder: (_) => const HeirSelectionScreen());
      default:
        return MaterialPageRoute(builder: (_) => const ChatScreen());
    }
  }
}
