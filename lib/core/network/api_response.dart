/// Every Blink API response follows:
/// `{ "success": true, "message": "...", "data": { ... } }`
///
/// Models should never parse a raw response body directly — they go
/// through [ApiResponse.fromJson] first, then hand the unwrapped `data`
/// to the model's own `fromJson`. This keeps the envelope shape isolated
/// from every individual model.
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  const ApiResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromData,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      // Defensive: `data` may be null, a Map, or a List depending on
      // the endpoint — fromData decides how to interpret it.
      data: json['data'] != null ? fromData(json['data']) : null,
    );
  }
}
