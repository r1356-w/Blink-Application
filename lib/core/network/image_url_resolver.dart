import 'api_endpoints.dart';

/// The API sometimes returns image fields as relative paths
/// (e.g. `/storage/banners/1.png`). This centralizes the rule for
/// turning those into fully-qualified URLs so no widget or model has to
/// duplicate the string-concatenation logic.
class ImageUrlResolver {
  ImageUrlResolver._();

  static String? resolve(String? rawUrl) {
    if (rawUrl == null || rawUrl.isEmpty) return null;
    if (rawUrl.startsWith('http://') || rawUrl.startsWith('https://')) {
      return rawUrl;
    }
    if (rawUrl.startsWith('/')) {
      return '${ApiEndpoints.baseOrigin}$rawUrl';
    }
    return '${ApiEndpoints.baseOrigin}/$rawUrl';
  }
}
