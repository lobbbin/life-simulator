class Will {
  final int? id;
  final int playerId;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final bool isActive;

  Will({
    this.id,
    required this.playerId,
    DateTime? createdAt,
    DateTime? lastUpdated,
    this.isActive = true,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastUpdated = lastUpdated ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'player_id': playerId,
        'created_at': createdAt.toIso8601String(),
        'last_updated': lastUpdated.toIso8601String(),
        'is_active': isActive ? 1 : 0,
      };

  factory Will.fromMap(Map<String, dynamic> map) => Will(
        id: map['id'] as int?,
        playerId: map['player_id'] as int,
        createdAt: DateTime.parse(map['created_at'] as String),
        lastUpdated: DateTime.parse(map['last_updated'] as String),
        isActive: (map['is_active'] as int?) == 1,
      );
}

class WillBequest {
  final int? id;
  final int willId;
  final String assetType;
  final int? assetId;
  final String description;
  final String beneficiaryType; // npc, charity
  final int? beneficiaryId;
  final String beneficiaryName;
  final double? percentage;

  WillBequest({
    this.id,
    required this.willId,
    required this.assetType,
    this.assetId,
    this.description = '',
    required this.beneficiaryType,
    this.beneficiaryId,
    this.beneficiaryName = '',
    this.percentage,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'will_id': willId,
        'asset_type': assetType,
        'asset_id': assetId,
        'description': description,
        'beneficiary_type': beneficiaryType,
        'beneficiary_id': beneficiaryId,
        'beneficiary_name': beneficiaryName,
        'percentage': percentage,
      };

  factory WillBequest.fromMap(Map<String, dynamic> map) => WillBequest(
        id: map['id'] as int?,
        willId: map['will_id'] as int,
        assetType: map['asset_type'] as String,
        assetId: map['asset_id'] as int?,
        description: map['description'] as String? ?? '',
        beneficiaryType: map['beneficiary_type'] as String,
        beneficiaryId: map['beneficiary_id'] as int?,
        beneficiaryName: map['beneficiary_name'] as String? ?? '',
        percentage: (map['percentage'] as num?)?.toDouble(),
      );
}
