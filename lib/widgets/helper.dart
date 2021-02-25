import '../imports.dart';

class Helper {
  static Color getColorFromHex(String hexColor) {
    if (hexColor == null || hexColor.isEmpty) hexColor = "#000000";

    hexColor = hexColor.replaceAll("#", "");
    return Color(int.parse('FF' + hexColor, radix: 16));
  }

  String checkStartwithHttps(String text) {
    if (text.isNotEmpty) text = text.trim();
    if (text.isEmpty) return text;
    final RegExp nameExp = RegExp(r'^(https?):');
    if (!nameExp.hasMatch(text)) {
      return 'https://$text';
    }
    return text;
  }
}

final helper = Helper();
