class Business {
  final int? id;
  final int playerId;
  final String name;
  final String businessType; // retail, food_beverage, tech_saas, services, manufacturing, hospitality, construction, ecommerce
  final String description;
  final int? locationId;
  final DateTime foundedAt;
  final double revenue;
  final double profit;
  final int employees;
  final double customerSatisfaction;
  final double industryRep;
  final String status; // operating, closed, bankrupt, acquired

  Business({
    this.id,
    required this.playerId,
    required this.name,
    required this.businessType,
    this.description = '',
    this.locationId,
    DateTime? foundedAt,
    this.revenue = 0,
    this.profit = 0,
    this.employees = 1,
    this.customerSatisfaction = 50,
    this.industryRep = 0,
    this.status = 'operating',
  }) : foundedAt = foundedAt ?? DateTime.now();

  double get profitMargin => revenue > 0 ? (profit / revenue) * 100 : 0;

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'player_id': playerId,
        'name': name,
        'business_type': businessType,
        'description': description,
        'location_id': locationId,
        'founded_at': foundedAt.toIso8601String(),
        'revenue': revenue,
        'profit': profit,
        'employees': employees,
        'customer_satisfaction': customerSatisfaction,
        'industry_rep': industryRep,
        'status': status,
      };

  factory Business.fromMap(Map<String, dynamic> map) => Business(
        id: map['id'] as int?,
        playerId: map['player_id'] as int,
        name: map['name'] as String,
        businessType: map['business_type'] as String,
        description: map['description'] as String? ?? '',
        locationId: map['location_id'] as int?,
        foundedAt: DateTime.parse(map['founded_at'] as String),
        revenue: (map['revenue'] as num?)?.toDouble() ?? 0,
        profit: (map['profit'] as num?)?.toDouble() ?? 0,
        employees: map['employees'] as int? ?? 1,
        customerSatisfaction: (map['customer_satisfaction'] as num?)?.toDouble() ?? 50,
        industryRep: (map['industry_rep'] as num?)?.toDouble() ?? 0,
        status: map['status'] as String? ?? 'operating',
      );
}
