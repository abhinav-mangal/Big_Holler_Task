import 'package:charts_flutter/flutter.dart' as charts;
import '../imports.dart';

class LoyaltyScreen extends StatefulWidget {
  @override
  _LoyaltyScreenState createState() => _LoyaltyScreenState();
}

class _LoyaltyScreenState extends State<LoyaltyScreen> {
  @override
  Widget build(BuildContext context) {
    Param param = ModalRoute.of(context).settings.arguments;
    Metadata metadata = param.metadata;
    User user = param.user;
    Color appColor = Helper.getColorFromHex(metadata.primaryColor);
    double loyaltyRewardBalance = user.loyaltyRewardBalance;
    double loyaltyThresholdBalance = user.loyaltyThresholdBalance;

    Widget getChart(double a, double b, double c) {
      final data = [
        LoyaltyPoints(b, charts.MaterialPalette.deepOrange.shadeDefault),
        LoyaltyPoints(c, charts.MaterialPalette.gray.shadeDefault),
      ];

      return Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width / 1.5,
            child: PieChart(
              [
                charts.Series<LoyaltyPoints, double>(
                  id: 'My Loyalty Points',
                  domainFn: (LoyaltyPoints lp, _) => lp.pointEarned,
                  measureFn: (LoyaltyPoints lp, _) => lp.pointEarned,
                  colorFn: (LoyaltyPoints lp, _) => lp.clr,
                  data: data,
                  labelAccessorFn: (LoyaltyPoints lp, _) => '${lp.pointEarned}',
                )
              ],
              animate: true,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.width / 1.5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    b.toStringAsFixed(2),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Points Earned',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    height: 2,
                    width: 100,
                    color: Colors.green,
                  ),
                  Text(
                    a.toStringAsFixed(2),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    'Target Points',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appColor,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('${user.firstName}\'s Loyalty Point',
              style: TextStyle(color: Colors.white)),
        ),
        body: SingleChildScrollView(
          padding: pagePadding,
          child: Column(
            children: <Widget>[
              Card(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Next reward',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '\$${metadata.loyaltyReward.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: Colors.green.shade600,
                          ),
                        ),
                      ],
                    ),
                    getChart(metadata.loyaltyThreshold, loyaltyThresholdBalance,
                        metadata.loyaltyThreshold - loyaltyThresholdBalance),
                    Text(
                      'Get 1 point for every \$1.00 you spend!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '\$${loyaltyRewardBalance.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Colors.green.shade900,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      '${user.firstName}\'s reward balance as of today',
                      overflow: TextOverflow.clip,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              OrderButton(context, metadata, appColor),
            ],
          ),
        ),
      ),
    );
  }
}
