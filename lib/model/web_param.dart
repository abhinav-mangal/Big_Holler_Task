import 'package:flutter/rendering.dart';

enum LinkType { ORDER, BROWSER, INAPP }

class WebParam {
  final String url;
  final Color color;
  final LinkType type;

  WebParam(this.url, this.color, this.type);
}
