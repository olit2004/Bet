

// an object represesnting a bid

class Bid {

  final String id;
  final String bidderId;
  final double amount;
  final DateTime timestamp;

  const Bid({
    required this.id,
    required this.bidderId,
    required this.amount,
    required this.timestamp,
  });

  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bidderId': bidderId,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
    };
  }

 
  factory Bid.fromMap(Map<String, dynamic> map) {
    return Bid(
      id: map['id'] as String,
      bidderId: map['bidderId'] as String,
      amount: (map['amount'] as num).toDouble(),
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
}
