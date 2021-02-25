import '../imports.dart';

class ColoredButton extends StatelessWidget {
  final bool outline;
  final Color color;
  final Color textColor;
  final String text;
  final Function function;
  final EdgeInsets padding;
  final double radius;
  final double borderWidth;

  ColoredButton(this.text, this.function,
      {this.color = PrimaryColor,
      this.textColor,
      this.padding,
      this.outline = false,
      this.radius = 5,
      this.borderWidth = 2});

  @override
  Widget build(BuildContext context) {
    var pd = padding == null ? EdgeInsets.all(10) : padding;
    return outline
        ? OutlineButton(
            onPressed: function,
            textColor: textColor == null ? color : textColor,
            borderSide: BorderSide(color: color, width: borderWidth),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius)),
            child: Padding(child: Text(text), padding: pd),
            highlightedBorderColor: color,
          )
        : FlatButton(
            splashColor: Colors.white30,
            textColor: textColor == null ? Colors.white : textColor,
            onPressed: function,
            color: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Padding(child: Text(text), padding: pd),
          );
  }
}
