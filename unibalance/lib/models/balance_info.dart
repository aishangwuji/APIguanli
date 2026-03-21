/// Balance information for an API provider
class BalanceInfo {
  final String providerId;
  final double total;
  final double used;
  final double available;
  final String currency;
  final DateTime? expiresAt;
  final DateTime lastUpdated;

  const BalanceInfo({
    required this.providerId,
    required this.total,
    required this.used,
    required this.available,
    this.currency = 'USD',
    this.expiresAt,
    required this.lastUpdated,
  });

  double get usagePercentage => total > 0 ? (used / total) * 100 : 0;

  Map<String, dynamic> toJson() => {
        'providerId': providerId,
        'total': total,
        'used': used,
        'available': available,
        'currency': currency,
        'expiresAt': expiresAt?.toIso8601String(),
        'lastUpdated': lastUpdated.toIso8601String(),
      };

  factory BalanceInfo.fromJson(Map<String, dynamic> json) => BalanceInfo(
        providerId: json['providerId'] as String,
        total: (json['total'] as num).toDouble(),
        used: (json['used'] as num).toDouble(),
        available: (json['available'] as num).toDouble(),
        currency: json['currency'] as String? ?? 'USD',
        expiresAt: json['expiresAt'] != null
            ? DateTime.parse(json['expiresAt'] as String)
            : null,
        lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      );
}
