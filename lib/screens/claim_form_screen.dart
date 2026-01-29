import 'package:flutter/material.dart';
import '../models/claim.dart';
import '../models/bill.dart';
import '../services/claim_service.dart';
import '../widgets/bill_list_widget.dart';

class ClaimFormScreen extends StatefulWidget {
  final ClaimService claimService;
  final Claim? existingClaim;

  const ClaimFormScreen({
    Key? key,
    required this.claimService,
    this.existingClaim,
  }) : super(key: key);

  @override
  State<ClaimFormScreen> createState() => _ClaimFormScreenState();
}

class _ClaimFormScreenState extends State<ClaimFormScreen> {
  late TextEditingController _patientNameController;
  late TextEditingController _advanceAmountController;
  late List<Bill> _bills;
  late String _claimId;
  late ClaimStatus _claimStatus;

  TextEditingController? _billDescriptionController;
  TextEditingController? _billAmountController;
  Bill? _editingBill;

  @override
  void initState() {
    super.initState();
    if (widget.existingClaim != null) {
      _claimId = widget.existingClaim!.id;
      _patientNameController =
          TextEditingController(text: widget.existingClaim!.patientName);
      _advanceAmountController = TextEditingController(
          text: widget.existingClaim!.advanceAmount.toString());
      _bills = List.from(widget.existingClaim!.bills);
      _claimStatus = widget.existingClaim!.status;
    } else {
      _claimId = widget.claimService.generateId();
      _patientNameController = TextEditingController();
      _advanceAmountController = TextEditingController();
      _bills = [];
      _claimStatus = ClaimStatus.draft;
    }
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _advanceAmountController.dispose();
    _billDescriptionController?.dispose();
    _billAmountController?.dispose();
    super.dispose();
  }

  void _showBillDialog({Bill? bill}) {
    _billDescriptionController = TextEditingController(text: bill?.description ?? '');
    _billAmountController =
        TextEditingController(text: bill?.amount.toString() ?? '');
    _editingBill = bill;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(bill != null ? 'Edit Bill' : 'Add Bill'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _billDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _billAmountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
                prefixText: '₹ ',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final description = _billDescriptionController?.text.trim() ?? '';
              final amountStr = _billAmountController?.text.trim() ?? '';

              if (description.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Description is required')),
                );
                return;
              }

              final amount = double.tryParse(amountStr);
              if (amount == null || amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Amount must be greater than 0')),
                );
                return;
              }

              if (bill != null) {
                final index =
                    _bills.indexWhere((b) => b.id == bill.id);
                _bills[index] = Bill(
                  id: bill.id,
                  description: description,
                  amount: amount,
                );
              } else {
                _bills.add(Bill(
                  id: widget.claimService.generateId(),
                  description: description,
                  amount: amount,
                ));
              }

              setState(() {});
              Navigator.pop(context);
              _billDescriptionController?.dispose();
              _billAmountController?.dispose();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteBill(String billId) {
    setState(() {
      _bills.removeWhere((b) => b.id == billId);
    });
  }

  void _saveDraft() {
    if (_patientNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Patient name is required')),
      );
      return;
    }

    final advanceAmount = double.tryParse(_advanceAmountController.text) ?? 0;

    final claim = Claim(
      id: _claimId,
      patientName: _patientNameController.text.trim(),
      bills: _bills,
      advanceAmount: advanceAmount,
      settlementAmount: 0,
      status: ClaimStatus.draft,
      createdAt: widget.existingClaim?.createdAt ?? DateTime.now(),
    );

    if (widget.existingClaim != null) {
      widget.claimService.updateClaim(claim);
    } else {
      widget.claimService.createClaim(claim);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Claim saved as draft')),
    );

    Navigator.pop(context);
  }

  void _submitClaim() {
    if (_patientNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Patient name is required')),
      );
      return;
    }

    if (_bills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one bill')),
      );
      return;
    }

    final advanceAmount = double.tryParse(_advanceAmountController.text) ?? 0;

    final claim = Claim(
      id: _claimId,
      patientName: _patientNameController.text.trim(),
      bills: _bills,
      advanceAmount: advanceAmount,
      settlementAmount: 0,
      status: ClaimStatus.submitted,
      createdAt: widget.existingClaim?.createdAt ?? DateTime.now(),
    );

    if (widget.existingClaim != null) {
      widget.claimService.updateClaim(claim);
    } else {
      widget.claimService.createClaim(claim);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Claim submitted successfully')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingClaim != null ? 'Edit Claim' : 'New Claim'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient Information',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _patientNameController,
              decoration: const InputDecoration(
                labelText: 'Patient Name *',
                border: OutlineInputBorder(),
                hintText: 'Enter patient name',
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bills',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ElevatedButton.icon(
                  onPressed: () => _showBillDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Bill'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            BillListWidget(
              bills: _bills,
              onEdit: (bill) => _showBillDialog(bill: bill),
              onDelete: _deleteBill,
              isEditable: true,
            ),
            const SizedBox(height: 24),
            Text(
              'Advance Amount',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _advanceAmountController,
              decoration: const InputDecoration(
                labelText: 'Advance Amount',
                border: OutlineInputBorder(),
                prefixText: '₹ ',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveDraft,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                    ),
                    child: const Text('Save as Draft'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitClaim,
                    child: const Text('Submit Claim'),
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
