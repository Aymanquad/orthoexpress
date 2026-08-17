class OrderCustomer {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String zip;

  const OrderCustomer({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.zip,
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'address': address,
        'city': city,
        'state': state,
        'zip': zip,
      };

  factory OrderCustomer.fromJson(Map<String, dynamic> json) => OrderCustomer(
        firstName: _asString(json['firstName']),
        lastName: _asString(json['lastName']),
        email: _asString(json['email']),
        phone: _asString(json['phone']),
        address: _asString(json['address']),
        city: _asString(json['city']),
        state: _asString(json['state']),
        zip: _asString(json['zip']),
      );
}

class OrderTotals {
  final double subtotal;
  final double shipping;
  final double tax;
  final double total;

  const OrderTotals({
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
  });

  Map<String, dynamic> toJson() => {
        'subtotal': subtotal,
        'shipping': shipping,
        'tax': tax,
        'total': total,
      };

  factory OrderTotals.fromJson(Map<String, dynamic> json) => OrderTotals(
        subtotal: _asDouble(json['subtotal']),
        shipping: _asDouble(json['shipping']),
        tax: _asDouble(json['tax']),
        total: _asDouble(json['total']),
      );
}

class OrderLineItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final double lineTotal;
  final String imagePath;

  const OrderLineItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.lineTotal,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'name': name,
        'price': price,
        'quantity': quantity,
        'lineTotal': lineTotal,
        'image': imagePath,
      };

  factory OrderLineItem.fromJson(Map<String, dynamic> json) => OrderLineItem(
        productId: _asString(json['productId']),
        name: _asString(json['name']),
        price: _asDouble(json['price']),
        quantity: _asInt(json['quantity']),
        lineTotal: _asDouble(json['lineTotal']),
        imagePath: _asString(json['image'] ?? json['imagePath']),
      );
}

class OrderPayment {
  final String provider;
  final String status;
  final String? last4;
  final String? brand;

  const OrderPayment({
    required this.provider,
    required this.status,
    this.last4,
    this.brand,
  });

  Map<String, dynamic> toJson() => {
        'provider': provider,
        'status': status,
        if (last4 != null) 'last4': last4,
        if (brand != null) 'brand': brand,
      };

  factory OrderPayment.fromJson(Map<String, dynamic> json) => OrderPayment(
        provider: _asString(json['provider'], 'demo'),
        status: _asString(json['status'], 'confirmed'),
        last4: json['last4'] as String?,
        brand: json['brand'] as String?,
      );
}

class Order {
  final String id;
  final String createdAt;
  final String status;
  final OrderCustomer customer;
  final List<OrderLineItem> items;
  final OrderTotals totals;
  final OrderPayment? payment;
  final String lang;

  const Order({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.customer,
    required this.items,
    required this.totals,
    this.payment,
    required this.lang,
  });

  int get itemCount => items.fold<int>(0, (sum, i) => sum + i.quantity);

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt,
        'status': status,
        'customer': customer.toJson(),
        'items': items.map((i) => i.toJson()).toList(),
        'totals': totals.toJson(),
        if (payment != null) 'payment': payment!.toJson(),
        'lang': lang,
      };

  factory Order.fromJson(Map<String, dynamic> json) {
    final customerRaw = json['customer'];
    final customerMap = customerRaw is Map<String, dynamic>
        ? customerRaw
        : <String, dynamic>{
            if (json['phone'] != null) 'phone': json['phone'],
          };
    final itemsRaw = json['items'];
    final totalsRaw = json['totals'];
    final paymentRaw = json['payment'];

    return Order(
      id: _asString(json['id']),
      createdAt: _asString(json['createdAt']),
      status: _asString(json['status'], 'confirmed'),
      customer: OrderCustomer.fromJson(customerMap),
      items: itemsRaw is List
          ? itemsRaw
              .whereType<Map<String, dynamic>>()
              .map(OrderLineItem.fromJson)
              .toList()
          : const [],
      totals: OrderTotals.fromJson(
        totalsRaw is Map<String, dynamic> ? totalsRaw : const {'total': 0},
      ),
      payment: paymentRaw is Map<String, dynamic>
          ? OrderPayment.fromJson(paymentRaw)
          : null,
      lang: _asString(json['lang'], 'en'),
    );
  }

  static Order? tryFromJson(Map<String, dynamic> json) {
    try {
      final order = Order.fromJson(json);
      if (order.id.isEmpty) return null;
      return order;
    } catch (_) {
      return null;
    }
  }
}

String _asString(dynamic value, [String fallback = '']) {
  if (value == null) return fallback;
  final text = value.toString();
  return text.isEmpty ? fallback : text;
}

double _asDouble(dynamic value, [double fallback = 0]) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? fallback;
  return fallback;
}

int _asInt(dynamic value, [int fallback = 0]) {
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}
