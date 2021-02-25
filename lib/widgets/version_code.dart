import '../imports.dart';

class VersionCode extends StatelessWidget {
  final String version;
  VersionCode(this.version);

  @override
  Widget build(BuildContext context) {
    String v = version;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Text(
            '$v',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
