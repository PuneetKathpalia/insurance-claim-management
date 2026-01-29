import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/claim.dart';
import '../models/bill.dart';

class ClaimService extends ChangeNotifier {
  final List<Claim> _claims = [];

  List<Claim> get claims => _claims;

  void createClaim(Claim claim) {
    _claims.add(claim);
    notifyListeners();
  }

  void updateClaim(Claim claim) {
    final index = _claims.indexWhere((c) => c.id == claim.id);
    if (index != -1) {
      _claims[index] = claim;
      notifyListeners();
    }
  }

  void deleteClaim(String claimId) {
    _claims.removeWhere((c) => c.id == claimId);
    notifyListeners();
  }

  Claim? getClaimById(String claimId) {
    try {
      return _claims.firstWhere((c) => c.id == claimId);
    } catch (e) {
      return null;
    }
  }

  String generateId() {
    return const Uuid().v4().substring(0, 8);
  }
}
