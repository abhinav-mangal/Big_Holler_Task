import '../imports.dart';

class ShowOffline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(img_offline),
              const SizedBox(height: 20.0),
              Text('Not Internet Connection...')
            ],
          ),
        ),
      ),
    );
  }
}
