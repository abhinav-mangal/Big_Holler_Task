import '../imports.dart';

class AppText extends StatelessWidget {
  final String text;
  final Color color;
  final bool bold;
  final bool italic;
  final double size;
  final TextAlign align;
  final double sf;

  AppText(
    this.text, {
    this.color = primaryTextColor,
    this.bold = false,
    this.italic = false,
    this.size = 14,
    this.align = TextAlign.left,
    this.sf = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontFamily: fontname,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
      textAlign: align,
      textScaleFactor: sf,
    );
  }
}
