import 'package:flutter/material.dart';
import '../models/claim.dart';
import '../services/claim_service.dart';
import '../widgets/bill_list_widget.dart';
import '../widgets/status_chip.dart';
import 'claim_form_screen.dart';

class ClaimDetailScreen extends StatefulWidget {
  final Claim claim;
  final ClaimService claimService;

  const ClaimDetailScreen({
    Key? key,
    required this.claim,
    required this.claimService,
  }) : super(key: key);

  @override
  State<ClaimDetailScreen> createState() => _ClaimDetailScreenState();
}

class _ClaimDetailScreenState extends State<ClaimDetailScreen> {
  late Claim _claim;
  late TextEditingController _settlementAmountController;

  @override
  void initState() {
    super.initState();
    _claim = widget.claim;
    _settlementAmountController =
        TextEditingController(text: _claim.settlementAmount.toString());
  }

  @override
  void dispose() {
    _settlementAmountController.dispose();
    super.dispose();
  }

  void _updateSettlement() {
    final settlementAmount =
        double.tryParse(_settlementAmountController.text) ?? 0;

    if (settlementAmount < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settlement amount cannot be negative')),
      );
      return;
    }

    if (settlementAmount > _claim.pendingAmount + _claim.settlementAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settlement amount exceeds pending amount')),
      );
      return;
    }

    ClaimStatus newStatus = _claim.status;

    if (_claim.status == ClaimStatus.approved) {
      if (settlementAmount > 0 &&
          settlementAmount < _claim.pendingAmount + _claim.settlementAmount) {
        newStatus = ClaimStatus.partiallySettled;
      }
    } else if (_claim.status == ClaimStatus.partiallySettled) {
      final totalPending = _claim.totalBills - _claim.advanceAmount;
      if (settlementAmount >= totalPending) {
        newStatus = ClaimStatus.approved;
      }
    }

    setState(() {
      _claim = _claim.copyWith(
        settlementAmount: settlementAmount,
        status: newStatus,
      );
    });

    widget.claimService.updateClaim(_claim);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settlement amount updated')),
    );
  }

  void _transitionStatus(ClaimStatus newStatus) {
    setState(() {
      _claim = _claim.copyWith(status: newStatus);
    });

    widget.claimService.updateClaim(_claim);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Claim status changed to ${_getStatusLabel(newStatus)}')),
    );
  }

  String _getStatusLabel(ClaimStatus status) {
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

  void _editClaim() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClaimFormScreen(
          claimService: widget.claimService,
          existingClaim: _claim,
        ),
      ),
    ).then((_) {
      final updated = widget.claimService.getClaimById(_claim.id);
      if (updated != null) {
        setState(() {
          _claim = updated;
        });
      }
    });
  }

  void _deleteClaim() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Claim'),
        content: const Text('Are you sure you want to delete this claim?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.claimService.deleteClaim(_claim.id);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Claim deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Claim Details'),
        actions: [
          if (_claim.status == ClaimStatus.draft)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _editClaim,
            ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Delete'),
                onTap: _deleteClaim,
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Patient Name',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                            Text(
                              _claim.patientName,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        StatusChip(status: _claim.status),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Bills',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                            Text(
                              '₹${_claim.totalBills.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Advance Amount',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                            Text(
                              '₹${_claim.advanceAmount.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Settlement',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                            Text(
                              '₹${_claim.settlementAmount.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange[200]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pending Amount',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                              Text(
                                '₹${_claim.pendingAmount.toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.orange[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Bills',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            BillListWidget(
              bills: _claim.bills,
              onEdit: (_) {},
              onDelete: (_) {},
              isEditable: false,
            ),
            const SizedBox(height: 24),
            if (_claim.status == ClaimStatus.approved ||
                _claim.status == ClaimStatus.partiallySettled)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Settlement Amount',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _settlementAmountController,
                    decoration: const InputDecoration(
                      labelText: 'Settlement Amount',
                      border: OutlineInputBorder(),
                      prefixText: '₹ ',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _updateSettlement,
                      child: const Text('Update Settlement'),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            if (_claim.status == ClaimStatus.submitted)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          _transitionStatus(ClaimStatus.approved),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Approve'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _transitionStatus(ClaimStatus.rejected),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Reject'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
