import '../imports.dart';

class DialogOrder extends StatefulWidget {
  final Location location;
  final Color appColor;
  DialogOrder(this.location, this.appColor);

  @override
  _DialogOrderState createState() => _DialogOrderState();
}

class _DialogOrderState extends State<DialogOrder> {
  dialogContent(BuildContext context) {
    void orderLink(Link l) async {
      Navigator.pop(context);
      await utils.launchURL(context, widget.appColor, l.url);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[CloseBtn()],
            ),
            const SizedBox(height: 20),
            Container(
              height: 76,
              width: 76,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: widget.appColor),
              child: Icon(
                Icons.fastfood,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              height: 1,
              color: Colors.black12,
            ),
            for (var link in widget.location.links.list
                .where((l) => l.type == 7)
                .toList())
              Column(
                children: <Widget>[
                  InkWell(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: AppText(link.name,
                          color: widget.appColor, bold: true, size: 18),
                    ),
                    onTap: () => orderLink(link),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    height: 1,
                    color: Colors.black12,
                  ),
                ],
              ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
