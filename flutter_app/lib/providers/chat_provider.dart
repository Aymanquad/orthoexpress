import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatMessage {
  final String id;
  final String conversationId;
  final String senderRole; // patient | doctor
  final String senderId;
  final String senderName;
  final String text;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderRole,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'conversationId': conversationId,
        'senderRole': senderRole,
        'senderId': senderId,
        'senderName': senderName,
        'text': text,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String,
        conversationId: json['conversationId'] as String,
        senderRole: json['senderRole'] as String,
        senderId: json['senderId'] as String,
        senderName: json['senderName'] as String? ?? '',
        text: json['text'] as String? ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );
}

class ChatConversation {
  final String id;
  final String doctorId;
  final String patientId;
  final String patientName;
  final String patientPhone;
  final DateTime updatedAt;
  final String lastMessage;
  final String lastSenderRole; // patient | doctor | ''
  final DateTime? doctorLastReadAt;

  const ChatConversation({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.patientName,
    required this.patientPhone,
    required this.updatedAt,
    required this.lastMessage,
    this.lastSenderRole = '',
    this.doctorLastReadAt,
  });

  bool get awaitingDoctorReply =>
      lastSenderRole == 'patient' && lastMessage.trim().isNotEmpty;

  bool get unreadForDoctor {
    if (!awaitingDoctorReply) return false;
    final readAt = doctorLastReadAt;
    if (readAt == null) return true;
    return updatedAt.isAfter(readAt);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'doctorId': doctorId,
        'patientId': patientId,
        'patientName': patientName,
        'patientPhone': patientPhone,
        'updatedAt': updatedAt.toIso8601String(),
        'lastMessage': lastMessage,
        'lastSenderRole': lastSenderRole,
        'doctorLastReadAt': doctorLastReadAt?.toIso8601String(),
      };

  factory ChatConversation.fromJson(Map<String, dynamic> json) => ChatConversation(
        id: json['id'] as String,
        doctorId: json['doctorId'] as String,
        patientId: json['patientId'] as String,
        patientName: json['patientName'] as String? ?? '',
        patientPhone: json['patientPhone'] as String? ?? '',
        updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
            DateTime.now(),
        lastMessage: json['lastMessage'] as String? ?? '',
        lastSenderRole: json['lastSenderRole'] as String? ?? '',
        doctorLastReadAt: DateTime.tryParse(json['doctorLastReadAt'] as String? ?? ''),
      );

  ChatConversation copyWith({
    String? patientName,
    String? patientPhone,
    DateTime? updatedAt,
    String? lastMessage,
    String? lastSenderRole,
    DateTime? doctorLastReadAt,
    bool clearDoctorLastReadAt = false,
  }) {
    return ChatConversation(
      id: id,
      doctorId: doctorId,
      patientId: patientId,
      patientName: patientName ?? this.patientName,
      patientPhone: patientPhone ?? this.patientPhone,
      updatedAt: updatedAt ?? this.updatedAt,
      lastMessage: lastMessage ?? this.lastMessage,
      lastSenderRole: lastSenderRole ?? this.lastSenderRole,
      doctorLastReadAt:
          clearDoctorLastReadAt ? null : (doctorLastReadAt ?? this.doctorLastReadAt),
    );
  }
}

String conversationIdFor({required String doctorId, required String patientId}) =>
    '${doctorId}__${patientId.replaceAll(RegExp(r'\W'), '')}';

class ChatProvider extends ChangeNotifier {
  static const _messagesKey = 'orthoexpress_doctor_chat_messages_v1';
  static const _conversationsKey = 'orthoexpress_doctor_chat_conversations_v1';

  final List<ChatMessage> _messages = [];
  final List<ChatConversation> _conversations = [];
  bool _loaded = false;
  Future<void>? _loadFuture;

  bool get loaded => _loaded;
  List<ChatConversation> get conversations {
    final sorted = [..._conversations]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return List.unmodifiable(sorted);
  }

  Future<void> load() {
    _loadFuture ??= _loadInternal();
    return _loadFuture!;
  }

  Future<void> _loadInternal() async {
    final prefs = await SharedPreferences.getInstance();
    final rawMessages = prefs.getString(_messagesKey);
    final rawConversations = prefs.getString(_conversationsKey);
    _messages.clear();
    _conversations.clear();
    if (rawMessages != null && rawMessages.isNotEmpty) {
      final list = jsonDecode(rawMessages) as List? ?? const [];
      for (final item in list) {
        if (item is Map<String, dynamic>) {
          _messages.add(ChatMessage.fromJson(item));
        } else if (item is Map) {
          _messages.add(ChatMessage.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }
    if (rawConversations != null && rawConversations.isNotEmpty) {
      final list = jsonDecode(rawConversations) as List? ?? const [];
      for (final item in list) {
        ChatConversation? parsed;
        if (item is Map<String, dynamic>) {
          parsed = ChatConversation.fromJson(item);
        } else if (item is Map) {
          parsed = ChatConversation.fromJson(Map<String, dynamic>.from(item));
        }
        if (parsed != null) _conversations.add(parsed);
      }
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _messagesKey,
      jsonEncode(_messages.map((m) => m.toJson()).toList()),
    );
    await prefs.setString(
      _conversationsKey,
      jsonEncode(_conversations.map((c) => c.toJson()).toList()),
    );
  }

  ChatConversation? conversationById(String id) {
    for (final c in _conversations) {
      if (c.id == id) return c;
    }
    return null;
  }

  List<ChatMessage> messagesFor(String conversationId) {
    final list = _messages.where((m) => m.conversationId == conversationId).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return list;
  }

  List<ChatConversation> conversationsForDoctor(String doctorId) =>
      conversations.where((c) => c.doctorId == doctorId).toList();

  List<ChatConversation> conversationsForPatient(String patientId) =>
      conversations.where((c) => c.patientId == patientId).toList();

  int awaitingReplyCount(String doctorId) =>
      conversationsForDoctor(doctorId).where((c) => c.unreadForDoctor).length;

  Future<ChatConversation> ensureConversation({
    required String doctorId,
    required String patientId,
    required String patientName,
    required String patientPhone,
  }) async {
    await load();
    final id = conversationIdFor(doctorId: doctorId, patientId: patientId);
    final existingIndex = _conversations.indexWhere((c) => c.id == id);
    if (existingIndex >= 0) {
      final existing = _conversations[existingIndex];
      final nextName =
          patientName.isNotEmpty ? patientName : existing.patientName;
      final nextPhone =
          patientPhone.isNotEmpty ? patientPhone : existing.patientPhone;
      if (nextName == existing.patientName && nextPhone == existing.patientPhone) {
        return existing;
      }
      final updated = existing.copyWith(
        patientName: nextName,
        patientPhone: nextPhone,
      );
      _conversations[existingIndex] = updated;
      await _persist();
      notifyListeners();
      return updated;
    }

    final created = ChatConversation(
      id: id,
      doctorId: doctorId,
      patientId: patientId,
      patientName: patientName,
      patientPhone: patientPhone,
      updatedAt: DateTime.now(),
      lastMessage: '',
    );
    _conversations.add(created);
    await _persist();
    notifyListeners();
    return created;
  }

  Future<void> markDoctorRead(String conversationId) async {
    await load();
    final idx = _conversations.indexWhere((c) => c.id == conversationId);
    if (idx < 0) return;
    final c = _conversations[idx];
    _conversations[idx] = c.copyWith(doctorLastReadAt: DateTime.now());
    await _persist();
    notifyListeners();
  }

  Future<ChatMessage> sendMessage({
    required String conversationId,
    required String senderRole,
    required String senderId,
    required String senderName,
    required String text,
  }) async {
    await load();
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Message cannot be empty');
    }
    if (senderRole != 'patient' && senderRole != 'doctor') {
      throw ArgumentError('Invalid sender role');
    }

    final idx = _conversations.indexWhere((c) => c.id == conversationId);
    if (idx < 0) {
      throw StateError('Conversation not found');
    }

    final conversation = _conversations[idx];
    if (senderRole == 'doctor' && senderId != conversation.doctorId) {
      throw StateError('Doctor does not own this conversation');
    }
    if (senderRole == 'patient' && senderId != conversation.patientId) {
      throw StateError('Patient does not own this conversation');
    }

    final message = ChatMessage(
      id: 'msg_${DateTime.now().microsecondsSinceEpoch}',
      conversationId: conversationId,
      senderRole: senderRole,
      senderId: senderId,
      senderName: senderName,
      text: trimmed,
      createdAt: DateTime.now(),
    );
    _messages.add(message);

    _conversations[idx] = conversation.copyWith(
      updatedAt: message.createdAt,
      lastMessage: trimmed,
      lastSenderRole: senderRole,
      doctorLastReadAt: senderRole == 'doctor' ? message.createdAt : null,
      clearDoctorLastReadAt: senderRole == 'patient',
    );

    await _persist();
    notifyListeners();
    return message;
  }
}
