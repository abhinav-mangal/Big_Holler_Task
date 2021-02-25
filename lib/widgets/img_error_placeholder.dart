import '../imports.dart';

class ImgErrorPlaceholder extends StatelessWidget {
  final double height;
  final BoxFit fit;
  ImgErrorPlaceholder({this.height = 100, this.fit = BoxFit.none});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      img_broken,
      width: MediaQuery.of(context).size.width,
      height: height,
      fit: fit,
    );
  }
}
