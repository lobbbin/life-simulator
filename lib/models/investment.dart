class Investment {
  final int? id;
  final int playerId;
  final String assetType; // stock, real_estate, crypto, bond, startup, art
  final String name;
  final String description;
  final double purchasePrice;
  final double currentValue;
  final double quantity;
  final DateTime purchasedAt;

  Investment({
    this.id,
    required this.playerId,
    required this.assetType,
    required this.name,
    this.description = '',
    required this.purchasePrice,
    this.currentValue = 0,
    this.quantity = 1,
    DateTime? purchasedAt,
  }) : purchasedAt = purchasedAt ?? DateTime.now();

  double get totalReturn => (currentValue - purchasePrice) * quantity;
  double get returnPercentage =>
      purchasePrice > 0 ? ((currentValue - purchasePrice) / purchasePrice) * 100 : 0;
  double get totalValue => currentValue * quantity;

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'player_id': playerId,
        'asset_type': assetType,
        'name': name,
        'description': description,
        'purchase_price': purchasePrice,
        'current_value': currentValue,
        'quantity': quantity,
        'purchased_at': purchasedAt.toIso8601String(),
      };

  factory Investment.fromMap(Map<String, dynamic> map) => Investment(
        id: map['id'] as int?,
        playerId: map['player_id'] as int,
        assetType: map['asset_type'] as String,
        name: map['name'] as String,
        description: map['description'] as String? ?? '',
        purchasePrice: (map['purchase_price'] as num?)?.toDouble() ?? 0,
        currentValue: (map['current_value'] as num?)?.toDouble() ?? 0,
        quantity: (map['quantity'] as num?)?.toDouble() ?? 1,
        purchasedAt: DateTime.parse(map['purchased_at'] as String),
      );
}
