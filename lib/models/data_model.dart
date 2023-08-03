import 'dart:convert';

class Expense {
  final String id;
  final String text;
  final double amount;
  final String date;
  final bool isIncome;

  Expense({
    required this.id,
    required this.text,
    required this.amount,
    required this.date,
    required this.isIncome,
  });

  Expense copyWith({
    String? id,
    String? text,
    double? amount,
    String? date,
    bool? isIncome,
  }) {
    return Expense(
      id: id ?? this.id,
      text: text ?? this.text,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      isIncome: isIncome ?? this.isIncome,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'amount': amount,
      'date': date,
      'isIncome': isIncome,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      date: map['date'] ?? '',
      isIncome: map['isIncome'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Expense.fromJson(String source) =>
      Expense.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Expense(id: $id, text: $text, amount: $amount, date: $date, isIncome: $isIncome)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Expense &&
        other.id == id &&
        other.text == text &&
        other.amount == amount &&
        other.date == date &&
        other.isIncome == isIncome;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        amount.hashCode ^
        date.hashCode ^
        isIncome.hashCode;
  }
}
