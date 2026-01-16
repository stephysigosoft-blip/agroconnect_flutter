class SettingsModel {
  final bool notificationEnabled;

  SettingsModel({required this.notificationEnabled});

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    // Handle different possible field names and types
    bool notifEnabled = false;

    if (json.containsKey('notification_enabled')) {
      final value = json['notification_enabled'];
      if (value is bool) {
        notifEnabled = value;
      } else if (value is int) {
        notifEnabled = value == 1;
      } else if (value is String) {
        notifEnabled = value == '1' || value.toLowerCase() == 'true';
      }
    } else if (json.containsKey('notifications')) {
      final value = json['notifications'];
      if (value is bool) {
        notifEnabled = value;
      } else if (value is int) {
        notifEnabled = value == 1;
      } else if (value is String) {
        notifEnabled = value == '1' || value.toLowerCase() == 'true';
      }
    }

    return SettingsModel(notificationEnabled: notifEnabled);
  }

  Map<String, dynamic> toJson() {
    return {'notification_enabled': notificationEnabled};
  }
}
