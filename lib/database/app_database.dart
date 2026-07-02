import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../config/constants.dart';

class AppDatabase {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> initialize() async {
    await database;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.databaseName);

    return openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE players (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER NOT NULL DEFAULT 3,
        created_at TEXT NOT NULL,
        last_played TEXT NOT NULL,
        total_time_played INTEGER NOT NULL DEFAULT 0,
        is_alive INTEGER NOT NULL DEFAULT 1,
        cause_of_death TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE player_stats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        health REAL NOT NULL DEFAULT 100,
        energy REAL NOT NULL DEFAULT 100,
        happiness REAL NOT NULL DEFAULT 50,
        money REAL NOT NULL DEFAULT 0,
        intelligence REAL NOT NULL DEFAULT 10,
        social REAL NOT NULL DEFAULT 10,
        fitness REAL NOT NULL DEFAULT 10,
        career REAL NOT NULL DEFAULT 0,
        hunger REAL NOT NULL DEFAULT 0,
        stress REAL NOT NULL DEFAULT 0,
        reputation REAL NOT NULL DEFAULT 0,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE player_skills (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        skill_name TEXT NOT NULL,
        skill_level INTEGER NOT NULL DEFAULT 1,
        experience REAL NOT NULL DEFAULT 0,
        FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE player_traits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        trait_name TEXT NOT NULL,
        trait_type TEXT NOT NULL,
        acquired_at TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE inventory_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        category TEXT NOT NULL,
        quantity INTEGER NOT NULL DEFAULT 1,
        condition REAL NOT NULL DEFAULT 1.0,
        acquired_at TEXT NOT NULL,
        FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE locations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        location_type TEXT NOT NULL,
        is_core INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE npc_characters (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER NOT NULL DEFAULT 30,
        gender TEXT NOT NULL DEFAULT 'unknown',
        personality TEXT,
        backstory TEXT NOT NULL DEFAULT '',
        occupation TEXT NOT NULL DEFAULT '',
        current_location_id INTEGER,
        schedule TEXT,
        is_core INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY (current_location_id) REFERENCES locations(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE relationships (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        npc_id INTEGER NOT NULL,
        friendship REAL NOT NULL DEFAULT 0,
        romance REAL NOT NULL DEFAULT 0,
        rivalry REAL NOT NULL DEFAULT 0,
        last_updated TEXT NOT NULL,
        FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE,
        FOREIGN KEY (npc_id) REFERENCES npc_characters(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE careers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        job_title TEXT NOT NULL DEFAULT '',
        company TEXT NOT NULL DEFAULT '',
        industry TEXT NOT NULL DEFAULT '',
        salary REAL NOT NULL DEFAULT 0,
        performance_rating REAL NOT NULL DEFAULT 50,
        started_at TEXT NOT NULL,
        is_current INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE memories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        content TEXT NOT NULL,
        summary TEXT NOT NULL DEFAULT '',
        embedding TEXT,
        timestamp TEXT NOT NULL,
        location_id INTEGER,
        involved_npcs TEXT,
        importance INTEGER NOT NULL DEFAULT 5,
        is_core INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE,
        FOREIGN KEY (location_id) REFERENCES locations(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE conversation_messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        session_id TEXT NOT NULL,
        role TEXT NOT NULL,
        npc_id INTEGER,
        content TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        stat_changes TEXT,
        FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE,
        FOREIGN KEY (npc_id) REFERENCES npc_characters(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE calendar_events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        event_date TEXT NOT NULL,
        event_type TEXT NOT NULL DEFAULT 'general',
        recurring TEXT NOT NULL DEFAULT 'none',
        location_id INTEGER,
        involved_npcs TEXT,
        is_completed INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE,
        FOREIGN KEY (location_id) REFERENCES locations(id)
      )
    ''');

    // Career & Education tables

    await db.execute('''
      CREATE TABLE career_paths (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        path_type TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 0,
        started_at TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'active',
        street_cred REAL,
        heat_level REAL,
        crew_loyalty REAL,
        inmate_respect REAL,
        guard_rapport REAL,
        voter_approval REAL,
        party_standing REAL,
        media_favorability REAL,
        industry_rep REAL,
        customer_trust REAL,
        employee_morale REAL,
        investor_cred REAL,
        market_savvy REAL,
        public_image REAL,
        critical_rep REAL,
        box_office_track REAL,
        industry_status REAL,
        talent_rapport REAL,
        FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE career_milestones (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        career_path_id INTEGER NOT NULL,
        milestone_type TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        achieved_at TEXT NOT NULL,
        importance INTEGER NOT NULL DEFAULT 5,
        FOREIGN KEY (career_path_id) REFERENCES career_paths(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE crime_crew (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        npc_id INTEGER NOT NULL,
        role TEXT NOT NULL,
        loyalty REAL NOT NULL DEFAULT 50,
        skill REAL NOT NULL DEFAULT 50,
        joined_at TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'active',
        FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE,
        FOREIGN KEY (npc_id) REFERENCES npc_characters(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE prison_sentences (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        crime_path_id INTEGER,
        started_at TEXT NOT NULL,
        sentence_length INTEGER NOT NULL,
        good_conduct REAL NOT NULL DEFAULT 50,
        inmate_respect REAL NOT NULL DEFAULT 0,
        guard_rapport REAL NOT NULL DEFAULT 0,
        status TEXT NOT NULL DEFAULT 'serving',
        FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE,
        FOREIGN KEY (crime_path_id) REFERENCES career_paths(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE political_positions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        office_title TEXT NOT NULL,
        jurisdiction TEXT NOT NULL DEFAULT 'local',
        district TEXT NOT NULL DEFAULT '',
        party TEXT NOT NULL DEFAULT 'independent',
        started_at TEXT NOT NULL,
        ended_at TEXT,
        performance REAL NOT NULL DEFAULT 50,
        FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE policy_stances (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        issue TEXT NOT NULL,
        stance TEXT NOT NULL,
        strength INTEGER NOT NULL DEFAULT 5,
        FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE scandals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        severity INTEGER NOT NULL DEFAULT 5,
        exposed_at TEXT NOT NULL,
        is_resolved INTEGER NOT NULL DEFAULT 0,
        resolution TEXT,
        FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE businesses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        business_type TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        location_id INTEGER,
        founded_at TEXT NOT NULL,
        revenue REAL NOT NULL DEFAULT 0,
        profit REAL NOT NULL DEFAULT 0,
        employees INTEGER NOT NULL DEFAULT 1,
        customer_satisfaction REAL NOT NULL DEFAULT 50,
        industry_rep REAL NOT NULL DEFAULT 0,
        status TEXT NOT NULL DEFAULT 'operating',
        FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE,
        FOREIGN KEY (location_id) REFERENCES locations(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE investments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        asset_type TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        purchase_price REAL NOT NULL,
        current_value REAL NOT NULL DEFAULT 0,
        quantity REAL NOT NULL DEFAULT 1,
        purchased_at TEXT NOT NULL,
        FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE film_projects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        genre TEXT NOT NULL DEFAULT 'drama',
        budget REAL NOT NULL DEFAULT 0,
        box_office REAL,
        critical_score REAL,
        audience_score REAL,
        stage TEXT NOT NULL DEFAULT 'development',
        art_score INTEGER NOT NULL DEFAULT 5,
        commerce_score INTEGER NOT NULL DEFAULT 5,
        started_at TEXT NOT NULL,
        released_at TEXT,
        FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE film_crew (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        film_project_id INTEGER NOT NULL,
        npc_id INTEGER NOT NULL,
        role TEXT NOT NULL,
        salary REAL NOT NULL DEFAULT 0,
        performance REAL NOT NULL DEFAULT 50,
        FOREIGN KEY (film_project_id) REFERENCES film_projects(id) ON DELETE CASCADE,
        FOREIGN KEY (npc_id) REFERENCES npc_characters(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE wills (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        last_updated TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE will_bequests (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        will_id INTEGER NOT NULL,
        asset_type TEXT NOT NULL,
        asset_id INTEGER,
        description TEXT NOT NULL DEFAULT '',
        beneficiary_type TEXT NOT NULL,
        beneficiary_id INTEGER,
        beneficiary_name TEXT NOT NULL DEFAULT '',
        percentage REAL,
        FOREIGN KEY (will_id) REFERENCES wills(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE family_tree (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        npc_id INTEGER NOT NULL,
        relationship TEXT NOT NULL,
        FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE,
        FOREIGN KEY (npc_id) REFERENCES npc_characters(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE education_stages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        stage TEXT NOT NULL,
        is_current INTEGER NOT NULL DEFAULT 0,
        started_at TEXT NOT NULL,
        completed_at TEXT,
        status TEXT NOT NULL DEFAULT 'enrolled',
        academic_performance REAL NOT NULL DEFAULT 50,
        social_status REAL NOT NULL DEFAULT 50,
        major TEXT,
        minor TEXT,
        gpa REAL,
        completed_semesters INTEGER,
        FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
      )
    ''');

    // Indexes
    await db.execute('CREATE INDEX idx_player_stats_player ON player_stats(player_id)');
    await db.execute('CREATE INDEX idx_memories_player ON memories(player_id)');
    await db.execute('CREATE INDEX idx_messages_session ON conversation_messages(session_id)');
    await db.execute('CREATE INDEX idx_relationships_player ON relationships(player_id)');
    await db.execute('CREATE INDEX idx_career_paths_player ON career_paths(player_id)');
    await db.execute('CREATE INDEX idx_education_stages_player ON education_stages(player_id)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle future migrations
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return db.insert(table, values);
  }

  Future<int> update(String table, Map<String, dynamic> values,
      {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    return db.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String table,
      {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    return db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<List<Map<String, dynamic>>> query(String table,
      {bool? distinct,
      List<String>? columns,
      String? where,
      List<dynamic>? whereArgs,
      String? groupBy,
      String? having,
      String? orderBy,
      int? limit,
      int? offset}) async {
    final db = await database;
    return db.query(table,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset);
  }

  Future<Map<String, dynamic>?> queryFirst(String table,
      {String? where, List<dynamic>? whereArgs, String? orderBy}) async {
    final results = await query(table,
        where: where, whereArgs: whereArgs, orderBy: orderBy, limit: 1);
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> close() async {
    final db = await database;
    db.close();
    _database = null;
  }
}
