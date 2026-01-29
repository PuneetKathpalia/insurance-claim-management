import 'package:flutter/material.dart';
import '../models/claim.dart';
import '../services/claim_service.dart';
import '../widgets/status_chip.dart';
import 'claim_form_screen.dart';
import 'claim_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late ClaimService _claimService;

  @override
  void initState() {
    super.initState();
    _claimService = ClaimService();
  }

  void _createNewClaim() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClaimFormScreen(
          claimService: _claimService,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  void _openClaimDetail(Claim claim) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClaimDetailScreen(
          claim: claim,
          claimService: _claimService,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insurance Claims'),
        elevation: 0,
      ),
      body: _claimService.claims.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No claims yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create a new claim to get started',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _claimService.claims.length,
              itemBuilder: (context, index) {
                final claim = _claimService.claims[index];
                return GestureDetector(
                  onTap: () => _openClaimDetail(claim),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      claim.patientName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    StatusChip(status: claim.status),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Total Bill',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                  Text(
                                    '₹${claim.totalBills.toStringAsFixed(2)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                                    '₹${claim.advanceAmount.toStringAsFixed(2)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                                    '₹${claim.pendingAmount.toStringAsFixed(2)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: claim.pendingAmount > 0
                                              ? Colors.orange[700]
                                              : Colors.green[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewClaim,
        child: const Icon(Icons.add),
      ),
    );
  }
}
