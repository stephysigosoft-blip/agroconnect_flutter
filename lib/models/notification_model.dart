class NotificationModel {
  final String id;
  final String message;
  final String time;
  final String? type;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.message,
    required this.time,
    this.type,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // Handling different potential field names from API
    String msg = json['message'] ?? json['content'] ?? json['body'] ?? '';
    String id = (json['id'] ?? '').toString();
    String type = json['type'] ?? '';

    DateTime dt;
    if (json['created_at'] != null) {
      dt = DateTime.parse(json['created_at'].toString());
    } else {
      dt = DateTime.now();
    }

    // Format time for display (e.g., 10:00 AM)
    String timeStr = _formatDisplayTime(dt);

    return NotificationModel(
      id: id,
      message: msg,
      time: timeStr,
      type: type,
      createdAt: dt,
    );
  }

  static String _formatDisplayTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $amPm';
  }
}
