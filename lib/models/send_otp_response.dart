class SendOtpResponse {
  final bool status;
  final dynamic data;
  final Map<String, dynamic> message;

  SendOtpResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendOtpResponse(
      status: json['status'] ?? false,
      data: json['data'] ?? [],
      message:
          json['message'] is Map
              ? Map<String, dynamic>.from(json['message'] as Map)
              : {},
    );
  }

  String getLocalizedMessage(String langCode) {
    // Priority: message_[langCode] (success msg)
    if (message.containsKey('message_$langCode')) {
      var msg = message['message_$langCode'];
      if (msg is List && msg.isNotEmpty) return msg[0].toString();
    }

    // Check for validation errors (e.g., mobile_[langCode], country_code_[langCode])
    List<String> errors = [];
    message.forEach((key, value) {
      if (key.endsWith('_$langCode') && value is List && value.isNotEmpty) {
        errors.add(value[0].toString());
      }
    });

    if (errors.isNotEmpty) {
      return errors.join('\n');
    }

    return 'An error occurred';
  }
}
