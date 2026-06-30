/// Настройки личного календаря событий.
class UserCalendarSettings {
  const UserCalendarSettings({this.showPortfolioEvents = true});

  final bool showPortfolioEvents;

  UserCalendarSettings copyWith({bool? showPortfolioEvents}) {
    return UserCalendarSettings(
      showPortfolioEvents: showPortfolioEvents ?? this.showPortfolioEvents,
    );
  }

  Map<String, dynamic> toJson() => {
        'showPortfolioEvents': showPortfolioEvents,
      };

  factory UserCalendarSettings.fromJson(Map<String, dynamic> json) {
    return UserCalendarSettings(
      showPortfolioEvents: json['showPortfolioEvents'] as bool? ?? true,
    );
  }
}
