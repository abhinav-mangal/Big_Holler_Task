import 'dart:math';

import '../imports.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  PieChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return charts.PieChart(
      seriesList,
      animate: animate,
      animationDuration: Duration(seconds: 1),
      defaultRenderer: charts.ArcRendererConfig(
        arcWidth: 30,
        startAngle: 4 / 5 * pi,
        arcLength: 7 / 5 * pi,
        // arcRendererDecorators: [
        //   charts.ArcLabelDecorator(
        //     labelPosition: charts.ArcLabelPosition.outside,
        //     showLeaderLines: false,
        //     outsideLabelStyleSpec: charts.TextStyleSpec(fontSize: 32),
        //   )
        // ],
      ),
    );
  }
}
