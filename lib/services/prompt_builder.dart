import 'dart:convert';
import '../models/player.dart';
import '../models/player_stats.dart';
import '../models/player_skill.dart';
import '../models/player_trait.dart';
import '../models/location.dart';
import '../models/npc_character.dart';
import '../models/relationship.dart';
import '../models/memory.dart';
import '../models/career_path.dart';
import '../models/education_stage.dart';

class PromptBuilder {
  String buildSystemPrompt({
    required Player player,
    required PlayerStats stats,
    required List<PlayerSkill> skills,
    required List<PlayerTrait> traits,
    required Location currentLocation,
    required List<NpcCharacter> npcsPresent,
    required List<Relationship> relationships,
    required List<Memory> coreMemories,
    required List<Memory> recentMemories,
    required String currentDateTime,
    required String season,
    required String weather,
    required List<CareerPath> activePaths,
    required List<EducationStage> educationStages,
  }) {
    final buffer = StringBuffer();

    // World context
    buffer.writeln('[WORLD CONTEXT]');
    buffer.writeln('Current date/time: $currentDateTime');
    buffer.writeln('Season: $season');
    buffer.writeln('Weather: $weather');
    buffer.writeln('Player location: ${currentLocation.name}');
    buffer.writeln('');

    // Player profile
    buffer.writeln('[PLAYER PROFILE]');
    buffer.writeln('Name: ${player.name}, Age: ${player.age}');
    buffer.writeln('Stats: Health=${stats.health.toStringAsFixed(0)}, '
        'Energy=${stats.energy.toStringAsFixed(0)}, '
        'Happiness=${stats.happiness.toStringAsFixed(0)}, '
        'Money=\$${stats.money.toStringAsFixed(0)}');
    buffer.writeln('Intelligence=${stats.intelligence.toStringAsFixed(0)}, '
        'Social=${stats.social.toStringAsFixed(0)}, '
        'Fitness=${stats.fitness.toStringAsFixed(0)}');
    buffer.writeln('Hunger=${stats.hunger.toStringAsFixed(0)}, '
        'Stress=${stats.stress.toStringAsFixed(0)}, '
        'Reputation=${stats.reputation.toStringAsFixed(0)}');
    buffer.writeln('');

    // Skills
    if (skills.isNotEmpty) {
      buffer.writeln('[SKILLS]');
      for (final skill in skills) {
        buffer.writeln('- ${skill.skillName}: Level ${skill.skillLevel}');
      }
      buffer.writeln('');
    }

    // Traits
    if (traits.isNotEmpty) {
      buffer.writeln('[TRAITS]');
      for (final trait in traits) {
        buffer.writeln('- ${trait.traitName} (${trait.traitType}): ${trait.description}');
      }
      buffer.writeln('');
    }

    // Education
    if (educationStages.isNotEmpty) {
      buffer.writeln('[EDUCATION]');
      for (final stage in educationStages) {
        if (stage.isCurrent) {
          buffer.writeln('- Current: ${stage.stage.replaceAll('_', ' ').toUpperCase()} '
              '(Performance: ${stage.academicPerformance.toStringAsFixed(0)}/100, '
              'Social: ${stage.socialStatus.toStringAsFixed(0)}/100)');
          if (stage.major != null) buffer.writeln('  Major: ${stage.major}');
          if (stage.gpa != null) buffer.writeln('  GPA: ${stage.gpa!.toStringAsFixed(1)}');
        }
      }
      buffer.writeln('');
    }

    // Active career paths
    if (activePaths.isNotEmpty) {
      buffer.writeln('[ACTIVE CAREER PATHS]');
      for (final path in activePaths) {
        buffer.writeln('- ${path.pathType.toUpperCase()}: Status: ${path.status}');
        _appendPathReps(buffer, path);
      }
      buffer.writeln('');
    }

    // Current location
    buffer.writeln('[CURRENT LOCATION]');
    buffer.writeln('Location: ${currentLocation.name}');
    buffer.writeln('Description: ${currentLocation.description}');
    if (npcsPresent.isNotEmpty) {
      buffer.writeln('NPCs present: ${npcsPresent.map((n) => n.name).join(', ')}');
    }
    buffer.writeln('');

    // Active NPCs with relationship data
    if (npcsPresent.isNotEmpty) {
      buffer.writeln('[ACTIVE NPCS]');
      for (final npc in npcsPresent) {
        buffer.writeln('- ${npc.name} (${npc.age}, ${npc.gender})');
        buffer.writeln('  Backstory: ${npc.backstory}');
        buffer.writeln('  Occupation: ${npc.occupation}');
        if (npc.personality != null) {
          buffer.writeln('  Personality: ${npc.personality}');
        }
      }
      buffer.writeln('');

      buffer.writeln('[RELATIONSHIPS WITH PRESENT NPCS]');
      for (final rel in relationships) {
        final npc = npcsPresent.where((n) => n.id == rel.npcId).firstOrNull;
        if (npc != null) {
          buffer.writeln('- ${npc.name}: '
              'Friendship=${rel.friendship.toStringAsFixed(0)}, '
              'Romance=${rel.romance.toStringAsFixed(0)}, '
              'Rivalry=${rel.rivalry.toStringAsFixed(0)}');
        }
      }
      buffer.writeln('');
    }

    // Core memories
    if (coreMemories.isNotEmpty) {
      buffer.writeln('[CORE MEMORIES]');
      for (final memory in coreMemories) {
        buffer.writeln('- ${memory.summary}');
      }
      buffer.writeln('');
    }

    // Recent memories
    if (recentMemories.isNotEmpty) {
      buffer.writeln('[RECENT MEMORIES]');
      for (final memory in recentMemories.take(5)) {
        buffer.writeln('- ${memory.summary}');
      }
      buffer.writeln('');
    }

    // System rules
    buffer.writeln('[SYSTEM RULES]');
    buffer.writeln('- You are a modern-day life simulator. Narrate in second person ("You wake up...").');
    buffer.writeln('- Track all stats consistently and update them based on player actions.');
    buffer.writeln('- Suggest 3-5 contextual actions at the end of each response.');
    buffer.writeln('- Keep responses 2-4 paragraphs unless the player asks for more.');
    buffer.writeln('- Time advances appropriately with each action (30 min to 2 hours per action).');
    buffer.writeln('- NPCs have their own personalities, memories, and schedules.');
    buffer.writeln('- Education and career paths have realistic prerequisites and consequences.');
    buffer.writeln('- Cross-path interactions are encouraged (crime affects politics, etc.).');
    buffer.writeln('- Player can pursue multiple careers simultaneously (max 3).');
    buffer.writeln('- The player starts at age 3 in Kindergarten and progresses through life.');
    buffer.writeln('- Enforce realistic education requirements for careers.');
    buffer.writeln('- Past actions follow the player (criminal record, reputation, etc.).');

    // Output format
    buffer.writeln('');
    buffer.writeln('[OUTPUT FORMAT]');
    buffer.writeln('Respond in the following format:');
    buffer.writeln('NARRATION: <narrative text>');
    buffer.writeln('ACTIONS: <JSON array of suggested actions>');
    buffer.writeln('STAT_CHANGES: <JSON object of stat changes>');

    return buffer.toString();
  }

  void _appendPathReps(StringBuffer buffer, CareerPath path) {
    switch (path.pathType) {
      case 'crime':
        buffer.writeln('  Street Cred: ${path.streetCred?.toStringAsFixed(0) ?? "N/A"}, '
            'Heat: ${path.heatLevel?.toStringAsFixed(0) ?? "N/A"}');
        break;
      case 'politics':
        buffer.writeln('  Approval: ${path.voterApproval?.toStringAsFixed(0) ?? "N/A"}, '
            'Party Standing: ${path.partyStanding?.toStringAsFixed(0) ?? "N/A"}');
        break;
      case 'business':
        buffer.writeln('  Industry Rep: ${path.industryRep?.toStringAsFixed(0) ?? "N/A"}, '
            'Customer Trust: ${path.customerTrust?.toStringAsFixed(0) ?? "N/A"}');
        break;
      case 'tycoon':
        buffer.writeln('  Investor Cred: ${path.investorCred?.toStringAsFixed(0) ?? "N/A"}, '
            'Market Savvy: ${path.marketSavvy?.toStringAsFixed(0) ?? "N/A"}');
        break;
      case 'movie':
        buffer.writeln('  Critical Rep: ${path.criticalRep?.toStringAsFixed(0) ?? "N/A"}, '
            'Box Office: ${path.boxOfficeTrack?.toStringAsFixed(0) ?? "N/A"}');
        break;
      case 'prison':
        buffer.writeln('  Inmate Respect: ${path.inmateRespect?.toStringAsFixed(0) ?? "N/A"}, '
            'Guard Rapport: ${path.guardRapport?.toStringAsFixed(0) ?? "N/A"}');
        break;
    }
  }
}
