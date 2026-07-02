import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../models/education_stage.dart';

class EducationProvider extends ChangeNotifier {
  final AppDatabase _database;
  EducationStage? _currentStage;
  List<EducationStage> _allStages = [];

  EducationProvider(this._database);

  EducationStage? get currentStage => _currentStage;
  List<EducationStage> get allStages => _allStages;

  Future<void> loadEducation(int playerId) async {
    final results = await _database.query('education_stages',
        where: 'player_id = ?', whereArgs: [playerId]);
    _allStages = results.map((r) => EducationStage.fromMap(r)).toList();

    try {
      _currentStage = _allStages.firstWhere((s) => s.isCurrent);
    } catch (_) {
      _currentStage = null;
    }
    notifyListeners();
  }

  Future<void> updatePerformance(int stageId, double newPerformance) async {
    await _database.update('education_stages', {'academic_performance': newPerformance},
        where: 'id = ?', whereArgs: [stageId]);
    if (_currentStage?.id == stageId) {
      _currentStage = EducationStage(
        id: stageId,
        playerId: _currentStage!.playerId,
        stage: _currentStage!.stage,
        isCurrent: _currentStage!.isCurrent,
        startedAt: _currentStage!.startedAt,
        completedAt: _currentStage!.completedAt,
        status: _currentStage!.status,
        academicPerformance: newPerformance,
        socialStatus: _currentStage!.socialStatus,
        major: _currentStage!.major,
        minor: _currentStage!.minor,
        gpa: _currentStage!.gpa,
        completedSemesters: _currentStage!.completedSemesters,
      );
      notifyListeners();
    }
  }

  Future<void> updateSocialStatus(int stageId, double newStatus) async {
    await _database.update('education_stages', {'social_status': newStatus},
        where: 'id = ?', whereArgs: [stageId]);
    if (_currentStage?.id == stageId) {
      _currentStage = EducationStage(
        id: stageId,
        playerId: _currentStage!.playerId,
        stage: _currentStage!.stage,
        isCurrent: _currentStage!.isCurrent,
        startedAt: _currentStage!.startedAt,
        completedAt: _currentStage!.completedAt,
        status: _currentStage!.status,
        academicPerformance: _currentStage!.academicPerformance,
        socialStatus: newStatus,
        major: _currentStage!.major,
        minor: _currentStage!.minor,
        gpa: _currentStage!.gpa,
        completedSemesters: _currentStage!.completedSemesters,
      );
      notifyListeners();
    }
  }

  Future<void> declareMajor(int stageId, String major) async {
    await _database.update('education_stages', {'major': major},
        where: 'id = ?', whereArgs: [stageId]);
    if (_currentStage?.id == stageId) {
      _currentStage = EducationStage(
        id: stageId,
        playerId: _currentStage!.playerId,
        stage: _currentStage!.stage,
        isCurrent: _currentStage!.isCurrent,
        startedAt: _currentStage!.startedAt,
        completedAt: _currentStage!.completedAt,
        status: _currentStage!.status,
        academicPerformance: _currentStage!.academicPerformance,
        socialStatus: _currentStage!.socialStatus,
        major: major,
        minor: _currentStage!.minor,
        gpa: _currentStage!.gpa,
        completedSemesters: _currentStage!.completedSemesters,
      );
      notifyListeners();
    }
  }

  Future<void> updateGpa(int stageId, double newGpa) async {
    await _database.update('education_stages', {'gpa': newGpa},
        where: 'id = ?', whereArgs: [stageId]);
    if (_currentStage?.id == stageId) {
      _currentStage = EducationStage(
        id: stageId,
        playerId: _currentStage!.playerId,
        stage: _currentStage!.stage,
        isCurrent: _currentStage!.isCurrent,
        startedAt: _currentStage!.startedAt,
        completedAt: _currentStage!.completedAt,
        status: _currentStage!.status,
        academicPerformance: _currentStage!.academicPerformance,
        socialStatus: _currentStage!.socialStatus,
        major: _currentStage!.major,
        minor: _currentStage!.minor,
        gpa: newGpa,
        completedSemesters: _currentStage!.completedSemesters,
      );
      notifyListeners();
    }
  }

  String getStageDisplayName(String stage) {
    switch (stage) {
      case 'kindergarten':
        return 'Kindergarten';
      case 'elementary':
        return 'Elementary School';
      case 'middle_school':
        return 'Middle School';
      case 'high_school':
        return 'High School';
      case 'university':
        return 'University';
      default:
        return stage;
    }
  }

  String getStageAgeRange(String stage) {
    switch (stage) {
      case 'kindergarten':
        return 'Ages 3–5';
      case 'elementary':
        return 'Ages 6–10';
      case 'middle_school':
        return 'Ages 11–13';
      case 'high_school':
        return 'Ages 14–18';
      case 'university':
        return 'Ages 18–22+';
      default:
        return '';
    }
  }
}
