import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../models/career_path.dart';
import '../models/career_milestone.dart';
import '../models/business.dart';
import '../models/investment.dart';
import '../models/film_project.dart';
import '../models/film_crew_member.dart';
import '../models/political_position.dart';
import '../models/policy_stance.dart';
import '../models/scandal.dart';
import '../models/crime_crew.dart';
import '../models/prison_sentence.dart';

class CareerProvider extends ChangeNotifier {
  final AppDatabase _database;

  List<CareerPath> _paths = [];
  List<CareerMilestone> _milestones = [];
  List<Business> _businesses = [];
  List<Investment> _investments = [];
  List<FilmProject> _filmProjects = [];
  List<PoliticalPosition> _positions = [];
  List<PolicyStance> _stances = [];
  List<Scandal> _scandals = [];
  List<CrimeCrew> _crew = [];
  PrisonSentence? _currentSentence;

  CareerProvider(this._database);

  List<CareerPath> get paths => _paths;
  List<CareerMilestone> get milestones => _milestones;
  List<Business> get businesses => _businesses;
  List<Investment> get investments => _investments;
  List<FilmProject> get filmProjects => _filmProjects;
  List<PoliticalPosition> get positions => _positions;
  List<PolicyStance> get stances => _stances;
  List<Scandal> get scandals => _scandals;
  List<CrimeCrew> get crew => _crew;
  PrisonSentence? get currentSentence => _currentSentence;

  Future<void> loadCareerData(int playerId) async {
    await Future.wait([
      _loadPaths(playerId),
      _loadMilestones(playerId),
      _loadBusinesses(playerId),
      _loadInvestments(playerId),
      _loadFilmProjects(playerId),
      _loadPositions(playerId),
      _loadStances(playerId),
      _loadScandals(playerId),
      _loadCrew(playerId),
      _loadPrisonSentence(playerId),
    ]);
    notifyListeners();
  }

  Future<void> _loadPaths(int playerId) async {
    final results = await _database.query('career_paths',
        where: 'player_id = ?', whereArgs: [playerId]);
    _paths = results.map((r) => CareerPath.fromMap(r)).toList();
  }

  Future<void> _loadBusinesses(int playerId) async {
    final results = await _database.query('businesses',
        where: 'player_id = ?', whereArgs: [playerId]);
    _businesses = results.map((r) => Business.fromMap(r)).toList();
  }

  Future<void> _loadInvestments(int playerId) async {
    final results = await _database.query('investments',
        where: 'player_id = ?', whereArgs: [playerId]);
    _investments = results.map((r) => Investment.fromMap(r)).toList();
  }

  Future<void> _loadFilmProjects(int playerId) async {
    final results = await _database.query('film_projects',
        where: 'player_id = ?', whereArgs: [playerId]);
    _filmProjects = results.map((r) => FilmProject.fromMap(r)).toList();
  }

  Future<void> _loadPositions(int playerId) async {
    final results = await _database.query('political_positions',
        where: 'player_id = ?', whereArgs: [playerId]);
    _positions = results.map((r) => PoliticalPosition.fromMap(r)).toList();
  }

  Future<void> _loadStances(int playerId) async {
    final results = await _database.query('policy_stances',
        where: 'player_id = ?', whereArgs: [playerId]);
    _stances = results.map((r) => PolicyStance.fromMap(r)).toList();
  }

  Future<void> _loadScandals(int playerId) async {
    final results = await _database.query('scandals',
        where: 'player_id = ?', whereArgs: [playerId]);
    _scandals = results.map((r) => Scandal.fromMap(r)).toList();
  }

  Future<void> _loadCrew(int playerId) async {
    final results = await _database.query('crime_crew',
        where: 'player_id = ?', whereArgs: [playerId]);
    _crew = results.map((r) => CrimeCrew.fromMap(r)).toList();
  }

  Future<void> _loadMilestones(int playerId) async {
    final results = await _database.query('career_milestones',
        where: 'career_path_id IN (SELECT id FROM career_paths WHERE player_id = ?)',
        whereArgs: [playerId]);
    _milestones = results.map((r) => CareerMilestone.fromMap(r)).toList();
  }

  Future<void> _loadPrisonSentence(int playerId) async {
    final result = await _database.queryFirst('prison_sentences',
        where: 'player_id = ? AND status = \'serving\'',
        whereArgs: [playerId]);
    if (result != null) {
      _currentSentence = PrisonSentence.fromMap(result);
    }
  }

  Future<void> addBusiness(Business business) async {
    final id = await _database.insert('businesses', business.toMap());
    _businesses.add(business);
    notifyListeners();
  }

  Future<void> addInvestment(Investment investment) async {
    final id = await _database.insert('investments', investment.toMap());
    _investments.add(investment);
    notifyListeners();
  }

  Future<void> addFilmProject(FilmProject project) async {
    final id = await _database.insert('film_projects', project.toMap());
    _filmProjects.add(project);
    notifyListeners();
  }

  Future<void> addPosition(PoliticalPosition position) async {
    final id = await _database.insert('political_positions', position.toMap());
    _positions.add(position);
    notifyListeners();
  }

  Future<void> addStance(PolicyStance stance) async {
    await _database.insert('policy_stances', stance.toMap());
    await _loadStances(stance.playerId);
    notifyListeners();
  }

  Future<void> addScandal(Scandal scandal) async {
    await _database.insert('scandals', scandal.toMap());
    await _loadScandals(scandal.playerId);
    notifyListeners();
  }

  Future<void> addCrewMember(CrimeCrew member) async {
    await _database.insert('crime_crew', member.toMap());
    await _loadCrew(member.playerId);
    notifyListeners();
  }

  Future<void> addMilestone(CareerMilestone milestone) async {
    await _database.insert('career_milestones', milestone.toMap());
    notifyListeners();
  }

  List<CareerMilestone> getMilestonesForPath(int careerPathId) {
    return _milestones.where((m) => m.careerPathId == careerPathId).toList();
  }

  double get totalPortfolioValue {
    return _investments.fold(0.0, (sum, inv) => sum + inv.totalValue);
  }

  double get totalBusinessValue {
    return _businesses.fold(0.0, (sum, biz) => sum + biz.revenue);
  }
}
