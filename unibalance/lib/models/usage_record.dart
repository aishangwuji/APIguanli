/// Usage record for historical tracking
class UsageRecord {
  final String providerId;
  final DateTime date;
  final double cost;
  final int requests;
  final int inputTokens;
  final int outputTokens;

  const UsageRecord({
    required this.providerId,
    required this.date,
    required this.cost,
    required this.requests,
    required this.inputTokens,
    required this.outputTokens,
  });

  Map<String, dynamic> toJson() => {
        'providerId': providerId,
        'date': date.toIso8601String(),
        'cost': cost,
        'requests': requests,
        'inputTokens': inputTokens,
        'outputTokens': outputTokens,
      };

  factory UsageRecord.fromJson(Map<String, dynamic> json) => UsageRecord(
        providerId: json['providerId'] as String,
        date: DateTime.parse(json['date'] as String),
        cost: (json['cost'] as num).toDouble(),
        requests: json['requests'] as int,
        inputTokens: json['inputTokens'] as int,
        outputTokens: json['outputTokens'] as int,
      );
}
