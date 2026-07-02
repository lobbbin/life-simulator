class InventoryItem {
  final int? id;
  final int playerId;
  final String name;
  final String description;
  final String category; // food, clothing, electronics, books, furniture, tools, documents, misc
  final int quantity;
  final double condition;
  final DateTime acquiredAt;

  InventoryItem({
    this.id,
    required this.playerId,
    required this.name,
    this.description = '',
    required this.category,
    this.quantity = 1,
    this.condition = 1.0,
    DateTime? acquiredAt,
  }) : acquiredAt = acquiredAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'player_id': playerId,
        'name': name,
        'description': description,
        'category': category,
        'quantity': quantity,
        'condition': condition,
        'acquired_at': acquiredAt.toIso8601String(),
      };

  factory InventoryItem.fromMap(Map<String, dynamic> map) => InventoryItem(
        id: map['id'] as int?,
        playerId: map['player_id'] as int,
        name: map['name'] as String,
        description: map['description'] as String? ?? '',
        category: map['category'] as String,
        quantity: map['quantity'] as int? ?? 1,
        condition: (map['condition'] as num?)?.toDouble() ?? 1.0,
        acquiredAt: DateTime.parse(map['acquired_at'] as String),
      );

  InventoryItem copyWith({
    int? id,
    int? playerId,
    String? name,
    String? description,
    String? category,
    int? quantity,
    double? condition,
    DateTime? acquiredAt,
  }) =>
      InventoryItem(
        id: id ?? this.id,
        playerId: playerId ?? this.playerId,
        name: name ?? this.name,
        description: description ?? this.description,
        category: category ?? this.category,
        quantity: quantity ?? this.quantity,
        condition: condition ?? this.condition,
        acquiredAt: acquiredAt ?? this.acquiredAt,
      );
}
