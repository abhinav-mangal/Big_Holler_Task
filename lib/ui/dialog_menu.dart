import '../imports.dart';

class MenuDialog extends StatefulWidget {
  final Location location;
  final Color appColor;
  MenuDialog(this.location, this.appColor);

  @override
  _MenuDialogState createState() => _MenuDialogState();
}

class _MenuDialogState extends State<MenuDialog> {
  var allowedLinkType = [0, 1, 2];

  dialogContent(BuildContext context) {
    void showLink(Link l) async {
      Navigator.pop(context);
      switch (l.type) {
        case 0:
          Navigator.pushNamed(
            context,
            P_OpenLink,
            arguments: WebParam(
              l.url,
              widget.appColor,
              LinkType.INAPP,
            ),
          );
          break;
        case 1:
          var number = "tel:${l.url}";
          await launch(number);
          break;
        case 2:
          var mail = "mailto:${l.url}";
          await launch(mail);
          break;
      }
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
            AppText(
              t_options,
              align: TextAlign.center,
              size: 24,
              bold: true,
              color: Colors.black,
            ),
            const SizedBox(height: 30),
            Container(
              height: 76,
              width: 76,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: widget.appColor),
              child: Icon(
                Icons.settings,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              height: 1,
              color: Colors.black12,
            ),
            for (var link in widget.location.links.list
                .where((l) => allowedLinkType.contains(l.type))
                .toList())
              Column(
                children: <Widget>[
                  InkWell(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: AppText(link.name,
                          color: widget.appColor, bold: true, size: 18),
                    ),
                    onTap: () => showLink(link),
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
