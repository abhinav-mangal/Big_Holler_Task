import '../imports.dart';

class OrderButton extends StatelessWidget {
  final BuildContext context;
  final Metadata metadata;
  final Color appColor;
  OrderButton(this.context, this.metadata, this.appColor);

  @override
  Widget build(BuildContext context) {
    var orderLinks = metadata.locations.list[0].links.list
        .where((l) => l.type == 7)
        .toList();
    void showOrderLinks() async {
      if (orderLinks == null && metadata.locations.list[0].orderLink != null) {
        await utils.launchURL(
            context, appColor, metadata.locations.list[0].orderLink);
      } else if (orderLinks.length == 1)
        await utils.launchURL(context, appColor, orderLinks.first.url);
      else
        showDialog(
          context: context,
          builder: (BuildContext context) => DialogOrder(
            metadata.locations.list[0],
            appColor,
          ),
        );
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: MaterialButton(
            height: 55,
            onPressed: showOrderLinks,
            color: appColor,
            child:
                AppText(btn_order, color: Colors.white, bold: true, size: 16),
            elevation: 2.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
        ),
      ],
    );
  }
}
