class PortalPatient {
  final String id;
  final String phone;
  final String? firstName;
  final String? lastName;
  final String? email;

  const PortalPatient({
    required this.id,
    required this.phone,
    this.firstName,
    this.lastName,
    this.email,
  });

  String get displayFirstName {
    final name = firstName?.trim() ?? '';
    return name;
  }

  factory PortalPatient.fromJson(Map<String, dynamic> json) => PortalPatient(
        id: json['id'] as String,
        phone: json['phone'] as String? ?? '',
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        email: json['email'] as String?,
      );
}

class PortalAppointment {
  final String id;
  final String locationName;
  final String serviceName;
  final String? preferredAt;
  final String? reason;
  final String status;
  final String? scheduledAt;
  final String? providerName;

  const PortalAppointment({
    required this.id,
    required this.locationName,
    required this.serviceName,
    this.preferredAt,
    this.reason,
    required this.status,
    this.scheduledAt,
    this.providerName,
  });

  factory PortalAppointment.fromJson(Map<String, dynamic> json) => PortalAppointment(
        id: json['id'] as String,
        locationName: json['locationName'] as String? ?? '',
        serviceName: json['serviceName'] as String? ?? '',
        preferredAt: json['preferredAt'] as String?,
        reason: json['reason'] as String?,
        status: json['status'] as String? ?? 'REQUESTED',
        scheduledAt: json['scheduledAt'] as String?,
        providerName: json['providerName'] as String?,
      );
}
