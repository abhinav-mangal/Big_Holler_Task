import '../imports.dart';

const String fontname = 'Roboto Regular';

const textSizeSmall = 14.0;
const textSizeNormal = 16.0;
const textSizeHeadingOne = 22.0;
const textSizeHeadingTwo = 20.0;
const textSizeHeadingThree = 18.0;

//Themes and AppBar
AppBarTheme appBarTheme = AppBarTheme(color: PrimaryColor);
ThemeData appTheme = ThemeData(
    fontFamily: fontname,
    primaryColor: PrimaryColor,
    accentColor: Colors.amber,
    appBarTheme: appBarTheme);

AppBar appBar([String title = app_name, bool elevation = true]) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(color: Colors.white),
    ),
    iconTheme: IconThemeData(color: Colors.white),
    backgroundColor: PrimaryColor,
    elevation: elevation ? 5 : 0,
    centerTitle: true,
  );
}

//Text Styles
Text appText(
  String text, {
  double size = 14.0,
  color = Colors.white,
  bool isBold = false,
  TextAlign textAlign = TextAlign.center,
}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontSize: size,
      fontFamily: fontname,
      color: color,
    ),
  );
}

//Drawer Item
ListTile drawerItem(IconData icon, String text, Function onClick) {
  return ListTile(
    dense: true,
    leading: Icon(icon),
    title: Text(text),
    onTap: onClick,
  );
}

//Padding
EdgeInsets pagePadding = EdgeInsets.all(16.0);
EdgeInsets buttonPadding = EdgeInsets.all(8.0);

//Alert Dialog
void alertDialog(BuildContext context, Color appColor, String message,
    {bool dismiss = true}) {
  showDialog(
    barrierDismissible: dismiss,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: AppText(
          message,
          color: primaryTextColor,
          size: textSizeNormal,
          align: TextAlign.center,
        ),
        actions: <Widget>[
          Center(
            child: FlatButton(
              child: AppText(
                t_ok.toUpperCase(),
                color: appColor,
                bold: true,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      );
    },
  );
}

void alertActionDialog(
  BuildContext context,
  Color appColor,
  String message,
  String okBtn,
  Function onClick,
) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: AppText(
          message,
          color: primaryTextColor,
          size: textSizeNormal,
          align: TextAlign.center,
        ),
        actions: <Widget>[
          Center(
            child: FlatButton(
              child: AppText(
                okBtn.toUpperCase(),
                color: PrimaryColor,
                bold: true,
              ),
              onPressed: onClick,
            ),
          ),
        ],
      );
    },
  );
}
