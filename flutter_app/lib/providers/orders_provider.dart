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
    _orders = [order, ..._orders];
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_orders.map((o) => o.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }
}
