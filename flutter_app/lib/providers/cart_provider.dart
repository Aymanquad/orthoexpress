import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/products.dart';

class CartItem {
  final String productId;
  final int quantity;

  const CartItem({required this.productId, required this.quantity});

  Map<String, dynamic> toJson() => {'productId': productId, 'quantity': quantity};

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        productId: json['productId'] as String,
        quantity: json['quantity'] as int,
      );
}

class CartLine {
  final CartItem item;
  final Product product;
  final double lineTotal;

  const CartLine({
    required this.item,
    required this.product,
    required this.lineTotal,
  });
}

class CartProvider extends ChangeNotifier {
  static const _storageKey = 'orthoexpress_cart';

  List<CartItem> _items = [];
  bool _loaded = false;

  List<CartItem> get items => List.unmodifiable(_items);

  List<CartLine> get cartLines {
    return _items
        .map((item) {
          final product = getProductById(item.productId);
          if (product == null) return null;
          return CartLine(
            item: item,
            product: product,
            lineTotal: product.price * item.quantity,
          );
        })
        .whereType<CartLine>()
        .toList();
  }

  int get cartCount =>
      _items.fold<int>(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      cartLines.fold<double>(0, (sum, line) => sum + line.lineTotal);

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_storageKey);
    if (raw != null) {
      _items = raw
          .map((s) {
            final parts = s.split(':');
            if (parts.length != 2) return null;
            final qty = int.tryParse(parts[1]);
            if (qty == null || qty < 1) return null;
            return CartItem(productId: parts[0], quantity: qty);
          })
          .whereType<CartItem>()
          .where((i) => getProductById(i.productId) != null)
          .toList();
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _storageKey,
      _items.map((i) => '${i.productId}:${i.quantity}').toList(),
    );
  }

  Future<void> addToCart(String productId, {int quantity = 1}) async {
    if (getProductById(productId) == null) return;
    final index = _items.indexWhere((i) => i.productId == productId);
    if (index >= 0) {
      _items[index] = CartItem(
        productId: productId,
        quantity: _items[index].quantity + quantity,
      );
    } else {
      _items = [..._items, CartItem(productId: productId, quantity: quantity)];
    }
    await _persist();
    notifyListeners();
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity < 1) {
      await removeFromCart(productId);
      return;
    }
    _items = _items
        .map((i) => i.productId == productId
            ? CartItem(productId: productId, quantity: quantity)
            : i)
        .toList();
    await _persist();
    notifyListeners();
  }

  Future<void> removeFromCart(String productId) async {
    _items = _items.where((i) => i.productId != productId).toList();
    await _persist();
    notifyListeners();
  }

  Future<void> clearCart() async {
    _items = [];
    await _persist();
    notifyListeners();
  }
}
