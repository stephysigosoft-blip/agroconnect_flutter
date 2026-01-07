class CountryCode {
  final int id;
  final String countryCode;

  CountryCode({required this.id, required this.countryCode});

  factory CountryCode.fromJson(Map<String, dynamic> json) {
    return CountryCode(
      id: json['id'] as int,
      countryCode: json['country_code'] as String,
    );
  }
}

class CountryCodesResponse {
  final bool status;
  final List<CountryCode> countryCodes;
  final String message;

  CountryCodesResponse({
    required this.status,
    required this.countryCodes,
    required this.message,
  });

  factory CountryCodesResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data']['country_codes'] as List;
    List<CountryCode> codes = list.map((i) => CountryCode.fromJson(i)).toList();

    return CountryCodesResponse(
      status: json['status'] as bool,
      countryCodes: codes,
      message: json['message'] as String,
    );
  }
}
