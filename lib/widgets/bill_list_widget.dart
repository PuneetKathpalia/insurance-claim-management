import 'package:flutter/material.dart';
import '../models/bill.dart';

class BillListWidget extends StatefulWidget {
  final List<Bill> bills;
  final Function(Bill) onEdit;
  final Function(String) onDelete;
  final bool isEditable;

  const BillListWidget({
    Key? key,
    required this.bills,
    required this.onEdit,
    required this.onDelete,
    this.isEditable = false,
  }) : super(key: key);

  @override
  State<BillListWidget> createState() => _BillListWidgetState();
}

class _BillListWidgetState extends State<BillListWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.bills.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'No bills added',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.bills.length,
      itemBuilder: (context, index) {
        final bill = widget.bills[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text(bill.description),
            subtitle: Text('Amount: ₹${bill.amount.toStringAsFixed(2)}'),
            trailing: widget.isEditable
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => widget.onEdit(bill),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => widget.onDelete(bill.id),
                      ),
                    ],
                  )
                : null,
          ),
        );
      },
    );
  }
}
