import 'package:flutter/material.dart';
import '../models/claim.dart';

class StatusChip extends StatelessWidget {
  final ClaimStatus status;

  const StatusChip({
    Key? key,
    required this.status,
  }) : super(key: key);

  Color _getBackgroundColor() {
    switch (status) {
      case ClaimStatus.draft:
        return Colors.grey[300]!;
      case ClaimStatus.submitted:
        return Colors.blue[100]!;
      case ClaimStatus.approved:
        return Colors.green[100]!;
      case ClaimStatus.rejected:
        return Colors.red[100]!;
      case ClaimStatus.partiallySettled:
        return Colors.orange[100]!;
    }
  }

  Color _getTextColor() {
    switch (status) {
      case ClaimStatus.draft:
        return Colors.grey[800]!;
      case ClaimStatus.submitted:
        return Colors.blue[900]!;
      case ClaimStatus.approved:
        return Colors.green[900]!;
      case ClaimStatus.rejected:
        return Colors.red[900]!;
      case ClaimStatus.partiallySettled:
        return Colors.orange[900]!;
    }
  }

  String _getStatusLabel() {
    switch (status) {
      case ClaimStatus.draft:
        return 'Draft';
      case ClaimStatus.submitted:
        return 'Submitted';
      case ClaimStatus.approved:
        return 'Approved';
      case ClaimStatus.rejected:
        return 'Rejected';
      case ClaimStatus.partiallySettled:
        return 'Partially Settled';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        _getStatusLabel(),
        style: TextStyle(
          color: _getTextColor(),
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: _getBackgroundColor(),
    );
  }
}
