class CareerPath {
  final int? id;
  final int playerId;
  final String pathType; // crime, politics, business, tycoon, movie, prison
  final bool isActive;
  final DateTime startedAt;
  final String status; // active, retired, failed, deceased

  // Sub-reputations per path type
  final double? streetCred; // crime
  final double? heatLevel; // crime
  final double? crewLoyalty; // crime
  final double? inmateRespect; // prison
  final double? guardRapport; // prison
  final double? voterApproval; // politics
  final double? partyStanding; // politics
  final double? mediaFavorability; // politics
  final double? industryRep; // business
  final double? customerTrust; // business
  final double? employeeMorale; // business
  final double? investorCred; // tycoon
  final double? marketSavvy; // tycoon
  final double? publicImage; // tycoon / movie
  final double? criticalRep; // movie
  final double? boxOfficeTrack; // movie
  final double? industryStatus; // movie
  final double? talentRapport; // movie

  CareerPath({
    this.id,
    required this.playerId,
    required this.pathType,
    this.isActive = false,
    DateTime? startedAt,
    this.status = 'active',
    this.streetCred,
    this.heatLevel,
    this.crewLoyalty,
    this.inmateRespect,
    this.guardRapport,
    this.voterApproval,
    this.partyStanding,
    this.mediaFavorability,
    this.industryRep,
    this.customerTrust,
    this.employeeMorale,
    this.investorCred,
    this.marketSavvy,
    this.publicImage,
    this.criticalRep,
    this.boxOfficeTrack,
    this.industryStatus,
    this.talentRapport,
  }) : startedAt = startedAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'player_id': playerId,
        'path_type': pathType,
        'is_active': isActive ? 1 : 0,
        'started_at': startedAt.toIso8601String(),
        'status': status,
        'street_cred': streetCred,
        'heat_level': heatLevel,
        'crew_loyalty': crewLoyalty,
        'inmate_respect': inmateRespect,
        'guard_rapport': guardRapport,
        'voter_approval': voterApproval,
        'party_standing': partyStanding,
        'media_favorability': mediaFavorability,
        'industry_rep': industryRep,
        'customer_trust': customerTrust,
        'employee_morale': employeeMorale,
        'investor_cred': investorCred,
        'market_savvy': marketSavvy,
        'public_image': publicImage,
        'critical_rep': criticalRep,
        'box_office_track': boxOfficeTrack,
        'industry_status': industryStatus,
        'talent_rapport': talentRapport,
      };

  factory CareerPath.fromMap(Map<String, dynamic> map) => CareerPath(
        id: map['id'] as int?,
        playerId: map['player_id'] as int,
        pathType: map['path_type'] as String,
        isActive: (map['is_active'] as int?) == 1,
        startedAt: DateTime.parse(map['started_at'] as String),
        status: map['status'] as String? ?? 'active',
        streetCred: (map['street_cred'] as num?)?.toDouble(),
        heatLevel: (map['heat_level'] as num?)?.toDouble(),
        crewLoyalty: (map['crew_loyalty'] as num?)?.toDouble(),
        inmateRespect: (map['inmate_respect'] as num?)?.toDouble(),
        guardRapport: (map['guard_rapport'] as num?)?.toDouble(),
        voterApproval: (map['voter_approval'] as num?)?.toDouble(),
        partyStanding: (map['party_standing'] as num?)?.toDouble(),
        mediaFavorability: (map['media_favorability'] as num?)?.toDouble(),
        industryRep: (map['industry_rep'] as num?)?.toDouble(),
        customerTrust: (map['customer_trust'] as num?)?.toDouble(),
        employeeMorale: (map['employee_morale'] as num?)?.toDouble(),
        investorCred: (map['investor_cred'] as num?)?.toDouble(),
        marketSavvy: (map['market_savvy'] as num?)?.toDouble(),
        publicImage: (map['public_image'] as num?)?.toDouble(),
        criticalRep: (map['critical_rep'] as num?)?.toDouble(),
        boxOfficeTrack: (map['box_office_track'] as num?)?.toDouble(),
        industryStatus: (map['industry_status'] as num?)?.toDouble(),
        talentRapport: (map['talent_rapport'] as num?)?.toDouble(),
      );
}
