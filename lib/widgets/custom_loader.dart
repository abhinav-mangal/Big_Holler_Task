import '../imports.dart';

class CustomLoader extends StatelessWidget {
  final String text;
  final double size;
  final String colorString;
  CustomLoader({this.text = '', this.size = 32, this.colorString = ''});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Helper.getColorFromHex(colorString),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
