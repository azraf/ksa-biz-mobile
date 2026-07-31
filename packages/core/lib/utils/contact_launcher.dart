import 'package:url_launcher/url_launcher.dart';

class ContactLauncher {
  /// Strips non-digits from a phone number for tel/wa.me URIs.
  static String? normalizePhone(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    return digits.isEmpty ? null : digits;
  }

  static Future<bool> dialPhone(String? number) async {
    final digits = normalizePhone(number);
    if (digits == null) return false;
    final uri = Uri(scheme: 'tel', path: digits);
    if (!await canLaunchUrl(uri)) return false;
    return launchUrl(uri);
  }

  static Future<bool> openWhatsApp(String? number, {String? message}) async {
    final digits = normalizePhone(number);
    if (digits == null) return false;

    final encodedMessage = message != null && message.isNotEmpty
        ? '?text=${Uri.encodeComponent(message)}'
        : '';
    final webUri = Uri.parse('https://wa.me/$digits$encodedMessage');
    if (await canLaunchUrl(webUri)) {
      return launchUrl(webUri, mode: LaunchMode.externalApplication);
    }

    final appUri = Uri.parse(
      'whatsapp://send?phone=$digits${message != null && message.isNotEmpty ? '&text=${Uri.encodeComponent(message)}' : ''}',
    );
    if (await canLaunchUrl(appUri)) {
      return launchUrl(appUri, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  static Future<bool> sendSms(String? number, {String? body}) async {
    final digits = normalizePhone(number);
    if (digits == null) return false;
    final uri = Uri(
      scheme: 'smsto',
      path: digits,
      query: body != null && body.isNotEmpty ? 'body=${Uri.encodeComponent(body)}' : null,
    );
    if (!await canLaunchUrl(uri)) return false;
    return launchUrl(uri);
  }

  static Future<bool> openUrl(String url, {bool external = true}) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    if (!await canLaunchUrl(uri)) return false;
    return launchUrl(
      uri,
      mode: external ? LaunchMode.externalApplication : LaunchMode.platformDefault,
    );
  }
}
