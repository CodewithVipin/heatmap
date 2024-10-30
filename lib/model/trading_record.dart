class TradingRecord {
  final double profitOrLoss;
  final String reason;
  final double investment;
  final DateTime date;

  TradingRecord({
    required this.profitOrLoss,
    required this.reason,
    required this.investment,
    required this.date,
  });

  // Convert object to a Hive-compatible map
  Map<String, dynamic> toMap() => {
        'profitOrLoss': profitOrLoss,
        'reason': reason,
        'investment': investment,
        'date': date.toIso8601String(),
      };

  // Create an object from a Hive-compatible map
  factory TradingRecord.fromMap(Map<String, dynamic> map) => TradingRecord(
        profitOrLoss: map['profitOrLoss'],
        reason: map['reason'],
        investment: map['investment'],
        date: DateTime.parse(map['date']),
      );
}
