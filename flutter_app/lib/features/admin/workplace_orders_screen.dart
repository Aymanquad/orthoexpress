import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/models/workplace.dart';
import '../../data/workplace_api.dart';
import '../../providers/workplace_auth_provider.dart';

const _orderStatuses = ['confirmed', 'processing', 'shipped', 'delivered', 'cancelled'];

class WorkplaceOrdersScreen extends StatefulWidget {
  const WorkplaceOrdersScreen({super.key});

  @override
  State<WorkplaceOrdersScreen> createState() => _WorkplaceOrdersScreenState();
}

class _WorkplaceOrdersScreenState extends State<WorkplaceOrdersScreen> {
  List<WorkplaceOrder> _rows = [];
  bool _loading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final list = await WorkplaceApi.listOrders();
      if (!mounted) return;
      setState(() {
        _rows = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final canWrite = context.watch<WorkplaceAuthProvider>().can('orders', access: 'write');

    return ResponsiveScrollPage(
      onRefresh: _load,
      children: [
        Text('Shop orders', style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 12),
        if (_error.isNotEmpty) Text(_error, style: TextStyle(color: Colors.red.shade700)),
        if (_loading)
          const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
        else if (_rows.isEmpty)
          const Text('No orders found.')
        else
          ..._rows.map((o) {
            final total = '\$${(o.totalCents / 100).toStringAsFixed(2)}';
            final statusItems = {
              ..._orderStatuses,
              if (!_orderStatuses.contains(o.status)) o.status,
            }.toList();
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(o.id, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                    Text(
                      '${o.patientName ?? o.phone} · $total',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textLight),
                    ),
                    if (canWrite) ...[
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        key: ValueKey('${o.id}-${o.status}'),
                        initialValue: o.status,
                        decoration: const InputDecoration(labelText: 'Status', isDense: true),
                        items: statusItems
                            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (v) async {
                          if (v == null) return;
                          await WorkplaceApi.updateOrder(o.id, {'status': v});
                          await _load();
                        },
                      ),
                    ] else
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(o.status, style: const TextStyle(fontWeight: FontWeight.w700)),
                      ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
