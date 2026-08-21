import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../data/doctor_labels.dart';
import '../../data/doctors.dart';
import '../../providers/chat_provider.dart';
import '../../providers/doctor_auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/portal_auth_provider.dart';

class DoctorChatScreen extends StatefulWidget {
  final String doctorId;
  final String? conversationId;

  const DoctorChatScreen({
    super.key,
    required this.doctorId,
    this.conversationId,
  });

  @override
  State<DoctorChatScreen> createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final _focus = FocusNode();
  String? _conversationId;
  bool _ready = false;
  bool _sending = false;
  String _error = '';
  bool _asDoctor = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    final chat = context.read<ChatProvider>();
    final patientAuth = context.read<PortalAuthProvider>();
    final doctorAuth = context.read<DoctorAuthProvider>();
    final doctor = doctorById(widget.doctorId);

    if (doctor == null) {
      if (!mounted) return;
      setState(() {
        _error = DoctorLabels.conversationMissing.forLang(
          context.read<LanguageProvider>().locale.languageCode,
        );
        _ready = true;
      });
      return;
    }

    await chat.load();
    if (!mounted) return;

    final requestedId = widget.conversationId?.trim();
    final loggedInDoctor = doctorAuth.doctor;

    // Doctor thread: must be signed in as this doctor and own the conversation.
    if (requestedId != null && requestedId.isNotEmpty) {
      if (loggedInDoctor == null || loggedInDoctor.id != doctor.id) {
        if (mounted) context.go('/more/doctors/login');
        return;
      }
      final conversation = chat.conversationById(requestedId);
      if (conversation == null || conversation.doctorId != doctor.id) {
        setState(() {
          _error = DoctorLabels.conversationMissing.forLang(
            context.read<LanguageProvider>().locale.languageCode,
          );
          _ready = true;
        });
        return;
      }
      await chat.markDoctorRead(conversation.id);
      if (!mounted) return;
      setState(() {
        _conversationId = conversation.id;
        _asDoctor = true;
        _ready = true;
      });
      _scrollToEnd();
      return;
    }

    // Patient thread
    final patient = patientAuth.patient;
    if (patient == null) {
      if (mounted) context.go('/more/portal/login');
      return;
    }

    final conversation = await chat.ensureConversation(
      doctorId: doctor.id,
      patientId: patient.id,
      patientName: _patientDisplayName(patient.displayFullName, patient.displayFirstName, patient.phone),
      patientPhone: patient.phone,
    );

    if (!mounted) return;
    setState(() {
      _conversationId = conversation.id;
      _asDoctor = false;
      _ready = true;
    });
    _scrollToEnd();
  }

  String _patientDisplayName(String full, String first, String phone) {
    if (full.trim().isNotEmpty) return full.trim();
    if (first.trim().isNotEmpty) return first.trim();
    return phone;
  }

  void _scrollToEnd({bool animate = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      final target = _scroll.position.maxScrollExtent + 100;
      if (animate) {
        _scroll.animateTo(
          target,
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOut,
        );
      } else {
        _scroll.jumpTo(target);
      }
    });
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _conversationId == null || _sending) return;

    final chat = context.read<ChatProvider>();
    final patientAuth = context.read<PortalAuthProvider>();
    final doctorAuth = context.read<DoctorAuthProvider>();
    final doctor = doctorById(widget.doctorId);
    if (doctor == null) return;

    setState(() => _sending = true);
    try {
      if (_asDoctor) {
        final loggedIn = doctorAuth.doctor;
        if (loggedIn == null || loggedIn.id != doctor.id) return;
        await chat.sendMessage(
          conversationId: _conversationId!,
          senderRole: 'doctor',
          senderId: doctor.id,
          senderName: doctor.name,
          text: text,
        );
      } else {
        final patient = patientAuth.patient;
        if (patient == null) return;
        await chat.sendMessage(
          conversationId: _conversationId!,
          senderRole: 'patient',
          senderId: patient.id,
          senderName: _patientDisplayName(
            patient.displayFullName,
            patient.displayFirstName,
            patient.phone,
          ),
          text: text,
        );
      }
      _controller.clear();
      _focus.requestFocus();
      _scrollToEnd();
    } catch (_) {
      if (!mounted) return;
      final lang = context.read<LanguageProvider>().locale.languageCode;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            lang == 'es' ? 'No se pudo enviar el mensaje.' : 'Could not send message.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final doctor = doctorById(widget.doctorId);
    final chat = context.watch<ChatProvider>();
    final messages =
        _conversationId == null ? const <ChatMessage>[] : chat.messagesFor(_conversationId!);
    final conversation =
        _conversationId == null ? null : chat.conversationById(_conversationId!);

    if (!_ready) {
      return const ColoredBox(
        color: AppColors.bgLight,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error.isNotEmpty || doctor == null) {
      return ColoredBox(
        color: AppColors.bgLight,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.chat_bubble_outline_rounded, size: 40, color: AppColors.textMuted),
                const SizedBox(height: 12),
                Text(
                  _error.isNotEmpty ? _error : DoctorLabels.conversationMissing.forLang(lang),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(lang == 'es' ? 'Volver' : 'Go back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final headerName = _asDoctor
        ? (conversation?.patientName.isNotEmpty == true
            ? conversation!.patientName
            : (conversation?.patientPhone.isNotEmpty == true
                ? conversation!.patientPhone
                : DoctorLabels.patient.forLang(lang)))
        : doctor.name;
    final headerSub = _asDoctor
        ? (conversation?.patientPhone ?? '')
        : '${doctor.specialty.forLang(lang)} · ${doctor.clinic.forLang(lang)}';
    final headerMono = _asDoctor
        ? (headerName.isNotEmpty ? headerName[0].toUpperCase() : 'P')
        : doctor.monogram;
    final online = !_asDoctor && doctor.availableNow;

    return ColoredBox(
      color: const Color(0xFFF0F3F8),
      child: Column(
        children: [
          _ChatHeader(
            monogram: headerMono,
            name: headerName,
            subtitle: headerSub,
            online: online,
            asDoctor: _asDoctor,
            lang: lang,
          ),
          Expanded(
            child: messages.isEmpty
                ? _EmptyChat(lang: lang)
                : ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final mine = _asDoctor
                          ? msg.senderRole == 'doctor'
                          : msg.senderRole == 'patient';
                      final showDate = index == 0 ||
                          !_sameDay(messages[index - 1].createdAt, msg.createdAt);
                      return Column(
                        children: [
                          if (showDate) _DateChip(date: msg.createdAt, lang: lang),
                          _Bubble(message: msg, mine: mine, lang: lang),
                        ],
                      );
                    },
                  ),
          ),
          _Composer(
            controller: _controller,
            focusNode: _focus,
            lang: lang,
            sending: _sending,
            onSend: _send,
          ),
        ],
      ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) {
    final la = a.toLocal();
    final lb = b.toLocal();
    return la.year == lb.year && la.month == lb.month && la.day == lb.day;
  }
}

class _ChatHeader extends StatelessWidget {
  final String monogram;
  final String name;
  final String subtitle;
  final bool online;
  final bool asDoctor;
  final String lang;

  const _ChatHeader({
    required this.monogram,
    required this.name,
    required this.subtitle,
    required this.online,
    required this.asDoctor,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgWhite,
      elevation: 0,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primarySoft,
                  child: Text(
                    monogram.length > 2 ? monogram.substring(0, 2) : monogram,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                if (online)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textMuted,
                          ),
                    ),
                  Text(
                    asDoctor
                        ? DoctorLabels.patient.forLang(lang)
                        : (online
                            ? DoctorLabels.availableNow.forLang(lang)
                            : DoctorLabels.away.forLang(lang)),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: online ? AppColors.accentHover : AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyChat extends StatelessWidget {
  final String lang;
  const _EmptyChat({required this.lang});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.forum_outlined,
                color: AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              DoctorLabels.emptyChat.forLang(lang),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              DoctorLabels.emptyChatHint.forLang(lang),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                    height: 1.4,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final DateTime date;
  final String lang;

  const _DateChip({required this.date, required this.lang});

  @override
  Widget build(BuildContext context) {
    final local = date.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(local.year, local.month, local.day);
    String label;
    if (day == today) {
      label = DoctorLabels.today.forLang(lang);
    } else if (day == today.subtract(const Duration(days: 1))) {
      label = DoctorLabels.yesterday.forLang(lang);
    } else {
      label = DateFormat.MMMd().format(local);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final ChatMessage message;
  final bool mine;
  final String lang;

  const _Bubble({
    required this.message,
    required this.mine,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.jm().format(message.createdAt.toLocal());
    final align = mine ? Alignment.centerRight : Alignment.centerLeft;
    final bg = mine ? AppColors.primary : Colors.white;
    final fg = mine ? Colors.white : AppColors.textDark;

    return Align(
      alignment: align,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment:
                mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(mine ? 16 : 4),
                    bottomRight: Radius.circular(mine ? 4 : 16),
                  ),
                  border: mine ? null : Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  message.text,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: fg,
                        height: 1.4,
                      ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$time · ${mine ? DoctorLabels.you.forLang(lang) : message.senderName}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String lang;
  final bool sending;
  final VoidCallback onSend;

  const _Composer({
    required this.controller,
    required this.focusNode,
    required this.lang,
    required this.sending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: const BoxDecoration(
          color: AppColors.bgWhite,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: DoctorLabels.typeMessage.forLang(lang),
                  filled: true,
                  fillColor: AppColors.bgSoft,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: const BorderSide(color: AppColors.primarySoft, width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: sending ? null : onSend,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.45),
                padding: const EdgeInsets.all(12),
              ),
              icon: sending
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.send_rounded),
              tooltip: DoctorLabels.send.forLang(lang),
            ),
          ],
        ),
      ),
    );
  }
}
