import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/order.dart';

class OrdersProvider extends ChangeNotifier {
  static const _storageKey = 'orthoexpress_orders';

  List<Order> _orders = [];
  bool _loaded = false;

  List<Order> get orders => List.unmodifiable(_orders);

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List;
        _orders = list
            .map((e) => Order.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        _orders = [];
      }
    }
    _loaded = true;
    notifyListeners();
  }

  Order? getById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveOrder(Order order) async {
    _orders = [order, ..._orders.where((o) => o.id != order.id)];
    await _persist();
    notifyListeners();
  }

  /// Additive merge from the patient portal API. Local rows keep their items
  /// and totals; missing customer fields (especially phone) are filled in.
  Future<void> mergeRemoteOrders(List<Order> remoteOrders) async {
    if (remoteOrders.isEmpty) return;
    final byId = <String, Order>{for (final order in _orders) order.id: order};
    var changed = false;

    for (final remote in remoteOrders) {
      final existing = byId[remote.id];
      if (existing == null) {
        byId[remote.id] = remote;
        changed = true;
        continue;
      }
      final merged = _mergeCustomerFields(existing, remote);
      if (merged != existing) {
        byId[remote.id] = merged;
        changed = true;
      }
    }

    if (!changed) return;
    _orders = byId.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    await _persist();
    notifyListeners();
  }

  Order _mergeCustomerFields(Order local, Order remote) {
    final lc = local.customer;
    final rc = remote.customer;
    final customer = OrderCustomer(
      firstName: lc.firstName.isNotEmpty ? lc.firstName : rc.firstName,
      lastName: lc.lastName.isNotEmpty ? lc.lastName : rc.lastName,
      email: lc.email.isNotEmpty ? lc.email : rc.email,
      phone: lc.phone.isNotEmpty ? lc.phone : rc.phone,
      address: lc.address.isNotEmpty ? lc.address : rc.address,
      city: lc.city.isNotEmpty ? lc.city : rc.city,
      state: lc.state.isNotEmpty ? lc.state : rc.state,
      zip: lc.zip.isNotEmpty ? lc.zip : rc.zip,
    );
    final items = local.items.isNotEmpty ? local.items : remote.items;
    return Order(
      id: local.id,
      createdAt: local.createdAt.isNotEmpty ? local.createdAt : remote.createdAt,
      status: local.status,
      customer: customer,
      items: items,
      totals: local.totals,
      payment: local.payment ?? remote.payment,
      lang: local.lang,
    );
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_orders.map((o) => o.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }
}
