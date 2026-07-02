import 'dart:math';
import 'package:intl/intl.dart';

class SimEvent {
  final String title;
  final String description;
  final String eventType;
  final Map<String, dynamic>? statEffects;
  final int? npcId;

  SimEvent({
    required this.title,
    required this.description,
    this.eventType = 'general',
    this.statEffects,
    this.npcId,
  });
}

class EventService {
  final Random _random = Random();

  SimEvent? getDailyEvent(int playerAge, String season) {
    // 30% chance of a random event each day
    if (_random.nextDouble() > 0.3) return null;

    if (playerAge <= 5) {
      return _kindergartenEvent();
    } else if (playerAge <= 10) {
      return _elementaryEvent();
    } else if (playerAge <= 13) {
      return _middleSchoolEvent();
    } else if (playerAge <= 17) {
      return _highSchoolEvent();
    } else if (playerAge <= 22) {
      return _universityEvent();
    } else {
      return _adultEvent(season);
    }
  }

  SimEvent _kindergartenEvent() {
    final events = [
      SimEvent(
        title: 'Show and Tell',
        description: 'Your teacher asks you to share something special. What do you show?',
        eventType: 'social',
        statEffects: {'social': 2, 'happiness': 3},
      ),
      SimEvent(
        title: 'Art Time',
        description: 'The class is doing finger painting today. Time to get creative!',
        eventType: 'creative',
        statEffects: {'intelligence': 1, 'happiness': 5},
      ),
      SimEvent(
        title: 'Recess Fun',
        description: 'It\'s playtime! The swings and slide are calling your name.',
        eventType: 'physical',
        statEffects: {'fitness': 2, 'happiness': 3, 'energy': -5},
      ),
    ];
    return events[_random.nextInt(events.length)];
  }

  SimEvent _elementaryEvent() {
    final events = [
      SimEvent(
        title: 'Field Trip',
        description: 'Your class is going to the science museum today!',
        eventType: 'educational',
        statEffects: {'intelligence': 5, 'happiness': 8, 'energy': -10},
      ),
      SimEvent(
        title: 'Pop Quiz',
        description: 'Your teacher springs a surprise math quiz on the class.',
        eventType: 'academic',
        statEffects: {'intelligence': 3, 'stress': 5},
      ),
      SimEvent(
        title: 'Lunch Drama',
        description: 'Someone took your seat in the cafeteria. What do you do?',
        eventType: 'social',
        statEffects: {'social': -2, 'happiness': -3},
      ),
    ];
    return events[_random.nextInt(events.length)];
  }

  SimEvent _middleSchoolEvent() {
    final events = [
      SimEvent(
        title: 'Social Drama',
        description: 'Rumors are spreading about you in the hallways.',
        eventType: 'social',
        statEffects: {'social': -5, 'stress': 10, 'happiness': -5},
      ),
      SimEvent(
        title: 'Elective Choice',
        description: 'It\'s time to choose your electives for next semester.',
        eventType: 'academic',
        statEffects: {'intelligence': 3},
      ),
      SimEvent(
        title: 'Crush Confession',
        description: 'Someone you like passes you a note. Your heart races.',
        eventType: 'romance',
        statEffects: {'social': 3, 'happiness': 5, 'stress': 8},
      ),
    ];
    return events[_random.nextInt(events.length)];
  }

  SimEvent _highSchoolEvent() {
    final events = [
      SimEvent(
        title: 'Exam Week',
        description: 'Finals are here. The next few days will determine your grades.',
        eventType: 'academic',
        statEffects: {'intelligence': 8, 'stress': 15, 'energy': -15},
      ),
      SimEvent(
        title: 'Homecoming Game',
        description: 'The big football game is tonight. The whole school is buzzing!',
        eventType: 'social',
        statEffects: {'social': 5, 'happiness': 10, 'energy': -10},
      ),
      SimEvent(
        title: 'Prom Invitation',
        description: 'Someone is trying to ask you to prom. How exciting!',
        eventType: 'romance',
        statEffects: {'social': 5, 'happiness': 10, 'stress': 5},
      ),
    ];
    return events[_random.nextInt(events.length)];
  }

  SimEvent _universityEvent() {
    final events = [
      SimEvent(
        title: 'Midterm Madness',
        description: 'Midterm week. Libraries are packed, and coffee is flowing.',
        eventType: 'academic',
        statEffects: {'intelligence': 10, 'stress': 20, 'energy': -20, 'happiness': -5},
      ),
      SimEvent(
        title: 'Campus Party',
        description: 'There\'s a huge party at the frat house tonight.',
        eventType: 'social',
        statEffects: {'social': 8, 'happiness': 15, 'energy': -15},
      ),
      SimEvent(
        title: 'Internship Opportunity',
        description: 'A professor mentions a promising internship opening at a top company.',
        eventType: 'career',
        statEffects: {'career': 10, 'stress': 5},
      ),
    ];
    return events[_random.nextInt(events.length)];
  }

  SimEvent _adultEvent(String season) {
    final events = <SimEvent>[
      SimEvent(
        title: 'Work Deadline',
        description: 'A major project deadline is approaching at work.',
        eventType: 'career',
        statEffects: {'career': 5, 'stress': 15, 'energy': -10},
      ),
      SimEvent(
        title: 'Unexpected Bill',
        description: 'An unexpected expense arrives in the mail.',
        eventType: 'financial',
        statEffects: {'money': -10, 'stress': 10},
      ),
      SimEvent(
        title: 'Neighborhood Event',
        description: 'Your neighbors are having a block party this weekend.',
        eventType: 'social',
        statEffects: {'social': 5, 'happiness': 8},
      ),
      SimEvent(
        title: 'Health Scare',
        description: 'You\'re not feeling well. Maybe you should see a doctor.',
        eventType: 'health',
        statEffects: {'health': -5, 'energy': -10},
      ),
    ];

    return events[_random.nextInt(events.length)];
  }
}
