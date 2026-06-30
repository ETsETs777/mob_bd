/// Периодичность пользовательского события календаря.
enum UserCalendarRecurrence {
  none,
  monthly,
  yearly;

  static UserCalendarRecurrence fromJson(String? raw) {
    return UserCalendarRecurrence.values.firstWhere(
      (v) => v.name == raw,
      orElse: () => UserCalendarRecurrence.none,
    );
  }
}

/// Пользовательское событие в личном календаре.
class UserCalendarEvent {
  const UserCalendarEvent({
    required this.id,
    required this.title,
    required this.date,
    this.amount,
    this.currency = 'RUB',
    this.note,
    this.attachmentName,
    this.attachmentMime,
    required this.createdAt,
    this.recurrence = UserCalendarRecurrence.none,
    this.reminderDaysBefore = const [],
  });

  final String id;
  final String title;
  final DateTime date;
  final double? amount;
  final String currency;
  final String? note;
  final String? attachmentName;
  final String? attachmentMime;
  final DateTime createdAt;
  final UserCalendarRecurrence recurrence;
  final List<int> reminderDaysBefore;

  bool get hasAttachment =>
      attachmentName != null && attachmentName!.isNotEmpty;

  bool get isRecurring => recurrence != UserCalendarRecurrence.none;

  UserCalendarEvent copyWith({
    String? title,
    DateTime? date,
    double? amount,
    bool clearAmount = false,
    String? currency,
    String? note,
    bool clearNote = false,
    String? attachmentName,
    String? attachmentMime,
    bool clearAttachment = false,
    UserCalendarRecurrence? recurrence,
    List<int>? reminderDaysBefore,
  }) {
    return UserCalendarEvent(
      id: id,
      title: title ?? this.title,
      date: date ?? this.date,
      amount: clearAmount ? null : (amount ?? this.amount),
      currency: currency ?? this.currency,
      note: clearNote ? null : (note ?? this.note),
      attachmentName:
          clearAttachment ? null : (attachmentName ?? this.attachmentName),
      attachmentMime:
          clearAttachment ? null : (attachmentMime ?? this.attachmentMime),
      createdAt: createdAt,
      recurrence: recurrence ?? this.recurrence,
      reminderDaysBefore: reminderDaysBefore ?? this.reminderDaysBefore,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date.toIso8601String(),
        if (amount != null) 'amount': amount,
        'currency': currency,
        if (note != null && note!.isNotEmpty) 'note': note,
        if (attachmentName != null) 'attachmentName': attachmentName,
        if (attachmentMime != null) 'attachmentMime': attachmentMime,
        'createdAt': createdAt.toIso8601String(),
        if (recurrence != UserCalendarRecurrence.none)
          'recurrence': recurrence.name,
        if (reminderDaysBefore.isNotEmpty)
          'reminderDaysBefore': reminderDaysBefore,
      };

  factory UserCalendarEvent.fromJson(Map<String, dynamic> json) {
    final remindersRaw = json['reminderDaysBefore'];
    List<int> reminders;
    if (remindersRaw is List) {
      reminders = remindersRaw
          .map((e) => (e as num).toInt())
          .where((d) => d > 0 && d <= 30)
          .toSet()
          .toList()
        ..sort();
    } else {
      reminders = const [];
    }

    return UserCalendarEvent(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ??
          DateTime.now(),
      amount: (json['amount'] as num?)?.toDouble(),
      currency: json['currency'] as String? ?? 'RUB',
      note: json['note'] as String?,
      attachmentName: json['attachmentName'] as String?,
      attachmentMime: json['attachmentMime'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      recurrence: UserCalendarRecurrence.fromJson(json['recurrence'] as String?),
      reminderDaysBefore: reminders,
    );
  }
}

/// Поддерживаемые валюты событий календаря.
const userCalendarCurrencies = ['RUB', 'USD', 'EUR', 'CNY'];

/// Доступные интервалы напоминаний (дней до события).
const userCalendarReminderOptions = [1, 3, 7];
