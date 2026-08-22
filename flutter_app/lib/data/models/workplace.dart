class ModuleAccess {
  final bool read;
  final bool write;

  const ModuleAccess({this.read = false, this.write = false});

  factory ModuleAccess.fromJson(Map<String, dynamic>? json) => ModuleAccess(
        read: json?['read'] == true,
        write: json?['write'] == true,
      );

  Map<String, dynamic> toJson() => {'read': read, 'write': write};

  ModuleAccess copyWith({bool? read, bool? write}) => ModuleAccess(
        read: read ?? this.read,
        write: write ?? this.write,
      );
}

class WorkplacePermissions {
  final ModuleAccess appointments;
  final ModuleAccess orders;
  final ModuleAccess prescriptions;
  final ModuleAccess demographics;

  const WorkplacePermissions({
    this.appointments = const ModuleAccess(),
    this.orders = const ModuleAccess(),
    this.prescriptions = const ModuleAccess(),
    this.demographics = const ModuleAccess(),
  });

  factory WorkplacePermissions.fromJson(Map<String, dynamic>? json) =>
      WorkplacePermissions(
        appointments: ModuleAccess.fromJson(
          json?['appointments'] is Map<String, dynamic>
              ? json!['appointments'] as Map<String, dynamic>
              : null,
        ),
        orders: ModuleAccess.fromJson(
          json?['orders'] is Map<String, dynamic>
              ? json!['orders'] as Map<String, dynamic>
              : null,
        ),
        prescriptions: ModuleAccess.fromJson(
          json?['prescriptions'] is Map<String, dynamic>
              ? json!['prescriptions'] as Map<String, dynamic>
              : null,
        ),
        demographics: ModuleAccess.fromJson(
          json?['demographics'] is Map<String, dynamic>
              ? json!['demographics'] as Map<String, dynamic>
              : null,
        ),
      );

  Map<String, dynamic> toJson() => {
        'appointments': appointments.toJson(),
        'orders': orders.toJson(),
        'prescriptions': prescriptions.toJson(),
        'demographics': demographics.toJson(),
      };

  ModuleAccess of(String module) {
    switch (module) {
      case 'orders':
        return orders;
      case 'prescriptions':
        return prescriptions;
      case 'demographics':
        return demographics;
      default:
        return appointments;
    }
  }

  static const full = WorkplacePermissions(
    appointments: ModuleAccess(read: true, write: true),
    orders: ModuleAccess(read: true, write: true),
    prescriptions: ModuleAccess(read: true, write: true),
    demographics: ModuleAccess(read: true, write: true),
  );
}

class WorkplaceUser {
  final String typ; // admin | staff
  final String adminId;
  final String? staffId;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? role;
  final WorkplacePermissions permissions;
  final bool canManageStaff;

  const WorkplaceUser({
    required this.typ,
    required this.adminId,
    this.staffId,
    required this.email,
    this.firstName,
    this.lastName,
    this.role,
    required this.permissions,
    required this.canManageStaff,
  });

  bool get isAdmin => typ == 'admin' || canManageStaff;

  String get slug {
    final raw = displayName.contains('@')
        ? email.split('@').first
        : displayName;
    final slug = raw
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return slug.isEmpty ? 'staff' : slug;
  }

  String get workplaceHome {
    if (isAdmin) return '/more/admin';
    final id = staffId;
    if (id == null || id.isEmpty) return '/more/admin/login';
    return '/more/staff/$slug/$id';
  }

  String workplacePath(String page) {
    if (page.isEmpty) return workplaceHome;
    return '$workplaceHome/$page';
  }

  String get displayName {
    final parts = [firstName, lastName]
        .whereType<String>()
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (parts.isNotEmpty) return parts.join(' ');
    return email;
  }

  bool can(String module, {String access = 'read'}) {
    if (isAdmin) return true;
    final mod = permissions.of(module);
    return access == 'write' ? mod.write : mod.read;
  }

  factory WorkplaceUser.fromJson(Map<String, dynamic> json) => WorkplaceUser(
        typ: json['typ'] as String? ?? 'staff',
        adminId: json['adminId'] as String? ?? '',
        staffId: json['staffId'] as String?,
        email: json['email'] as String? ?? '',
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        role: json['role'] as String?,
        permissions: WorkplacePermissions.fromJson(
          json['permissions'] is Map<String, dynamic>
              ? json['permissions'] as Map<String, dynamic>
              : null,
        ),
        canManageStaff: json['canManageStaff'] == true,
      );
}

class WorkplaceStaffMember {
  final String id;
  final String adminId;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String role;
  final WorkplacePermissions permissions;
  final bool isActive;

  const WorkplaceStaffMember({
    required this.id,
    required this.adminId,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    required this.role,
    required this.permissions,
    required this.isActive,
  });

  String get displayName {
    final parts = [firstName, lastName]
        .whereType<String>()
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (parts.isNotEmpty) return parts.join(' ');
    return email;
  }

  factory WorkplaceStaffMember.fromJson(Map<String, dynamic> json) =>
      WorkplaceStaffMember(
        id: json['id'] as String,
        adminId: json['adminId'] as String? ?? '',
        email: json['email'] as String? ?? '',
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        phone: json['phone'] as String?,
        role: json['role'] as String? ?? 'FRONT_DESK',
        permissions: WorkplacePermissions.fromJson(
          json['permissions'] is Map<String, dynamic>
              ? json['permissions'] as Map<String, dynamic>
              : null,
        ),
        isActive: json['isActive'] != false,
      );
}

class WorkplaceAppointment {
  final String id;
  final String serviceName;
  final String locationName;
  final String status;
  final String? scheduledAt;
  final String? preferredAt;
  final String? patientName;
  final String? patientPhone;

  const WorkplaceAppointment({
    required this.id,
    required this.serviceName,
    required this.locationName,
    required this.status,
    this.scheduledAt,
    this.preferredAt,
    this.patientName,
    this.patientPhone,
  });

  factory WorkplaceAppointment.fromJson(Map<String, dynamic> json) {
    final patient = json['patient'];
    String? name;
    String? phone;
    if (patient is Map<String, dynamic>) {
      final parts = [patient['firstName'], patient['lastName']]
          .whereType<String>()
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      name = parts.isEmpty ? null : parts.join(' ');
      phone = patient['phone'] as String?;
    }
    return WorkplaceAppointment(
      id: json['id'] as String,
      serviceName: json['serviceName'] as String? ?? '',
      locationName: json['locationName'] as String? ?? '',
      status: json['status'] as String? ?? '',
      scheduledAt: json['scheduledAt'] as String?,
      preferredAt: json['preferredAt'] as String?,
      patientName: name,
      patientPhone: phone,
    );
  }
}

class WorkplaceOrder {
  final String id;
  final String phone;
  final int totalCents;
  final String status;
  final String createdAt;
  final String? patientName;

  const WorkplaceOrder({
    required this.id,
    required this.phone,
    required this.totalCents,
    required this.status,
    required this.createdAt,
    this.patientName,
  });

  factory WorkplaceOrder.fromJson(Map<String, dynamic> json) {
    final patient = json['patient'];
    String? name;
    if (patient is Map<String, dynamic>) {
      final parts = [patient['firstName'], patient['lastName']]
          .whereType<String>()
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      name = parts.isEmpty ? null : parts.join(' ');
    }
    return WorkplaceOrder(
      id: json['id'] as String,
      phone: json['phone'] as String? ?? '',
      totalCents: (json['totalCents'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      patientName: name,
    );
  }
}

class WorkplacePatient {
  final String id;
  final String phone;
  final String? firstName;
  final String? lastName;
  final Map<String, dynamic>? demographics;

  const WorkplacePatient({
    required this.id,
    required this.phone,
    this.firstName,
    this.lastName,
    this.demographics,
  });

  String get displayName {
    final parts = [firstName, lastName]
        .whereType<String>()
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    return parts.isEmpty ? phone : parts.join(' ');
  }

  factory WorkplacePatient.fromJson(Map<String, dynamic> json) => WorkplacePatient(
        id: json['id'] as String,
        phone: json['phone'] as String? ?? '',
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        demographics: json['demographics'] is Map<String, dynamic>
            ? json['demographics'] as Map<String, dynamic>
            : null,
      );
}

class WorkplacePrescription {
  final String id;
  final String medication;
  final String dosage;
  final String? instructions;
  final String? prescribedBy;
  final String status;
  final String? patientName;
  final String? patientPhone;

  const WorkplacePrescription({
    required this.id,
    required this.medication,
    required this.dosage,
    this.instructions,
    this.prescribedBy,
    required this.status,
    this.patientName,
    this.patientPhone,
  });

  factory WorkplacePrescription.fromJson(Map<String, dynamic> json) {
    final patient = json['patient'];
    String? name;
    String? phone;
    if (patient is Map<String, dynamic>) {
      final parts = [patient['firstName'], patient['lastName']]
          .whereType<String>()
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      name = parts.isEmpty ? null : parts.join(' ');
      phone = patient['phone'] as String?;
    }
    return WorkplacePrescription(
      id: json['id'] as String,
      medication: json['medication'] as String? ?? '',
      dosage: json['dosage'] as String? ?? '',
      instructions: json['instructions'] as String?,
      prescribedBy: json['prescribedBy'] as String?,
      status: json['status'] as String? ?? '',
      patientName: name,
      patientPhone: phone,
    );
  }
}
