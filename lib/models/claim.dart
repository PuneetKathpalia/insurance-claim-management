import 'bill.dart';

enum ClaimStatus {
  draft,
  submitted,
  approved,
  rejected,
  partiallySettled,
}

class Claim {
  final String id;
  final String patientName;
  final List<Bill> bills;
  final double advanceAmount;
  final double settlementAmount;
  final ClaimStatus status;
  final DateTime createdAt;

  Claim({
    required this.id,
    required this.patientName,
    required this.bills,
    required this.advanceAmount,
    required this.settlementAmount,
    required this.status,
    required this.createdAt,
  });

  double get totalBills {
    return bills.fold(0, (sum, bill) => sum + bill.amount);
  }

  double get pendingAmount {
    final calculated = totalBills - advanceAmount - settlementAmount;
    return calculated > 0 ? calculated : 0;
  }

  Claim copyWith({
    String? id,
    String? patientName,
    List<Bill>? bills,
    double? advanceAmount,
    double? settlementAmount,
    ClaimStatus? status,
    DateTime? createdAt,
  }) {
    return Claim(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      bills: bills ?? this.bills,
      advanceAmount: advanceAmount ?? this.advanceAmount,
      settlementAmount: settlementAmount ?? this.settlementAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
