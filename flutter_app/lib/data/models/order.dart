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
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        address: json['address'] as String,
        city: json['city'] as String,
        state: json['state'] as String,
        zip: json['zip'] as String,
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
        subtotal: (json['subtotal'] as num).toDouble(),
        shipping: (json['shipping'] as num).toDouble(),
        tax: (json['tax'] as num).toDouble(),
        total: (json['total'] as num).toDouble(),
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
        productId: json['productId'] as String,
        name: json['name'] as String,
        price: (json['price'] as num).toDouble(),
        quantity: (json['quantity'] as num).toInt(),
        lineTotal: (json['lineTotal'] as num).toDouble(),
        imagePath: json['image'] as String? ?? '',
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
        provider: json['provider'] as String,
        status: json['status'] as String,
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

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'] as String,
        createdAt: json['createdAt'] as String,
        status: json['status'] as String? ?? 'confirmed',
        customer: OrderCustomer.fromJson(json['customer'] as Map<String, dynamic>),
        items: (json['items'] as List)
            .map((e) => OrderLineItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        totals: OrderTotals.fromJson(json['totals'] as Map<String, dynamic>),
        payment: json['payment'] != null
            ? OrderPayment.fromJson(json['payment'] as Map<String, dynamic>)
            : null,
        lang: json['lang'] as String? ?? 'en',
      );
}
