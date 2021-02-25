import 'package:path/path.dart' as p;
import '../imports.dart';
import 'dart:io';

class MenuView extends StatefulWidget {
  final Metadata metadata;
  final MenuTab menuTab;
  final Color appColor;
  final String orderUrl;
  final Directory dirToSave;
  MenuView(
    this.metadata,
    this.menuTab,
    this.orderUrl,
    this.appColor,
    this.dirToSave,
  );

  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  double _scaleFactor = 1.0;
  double _baseScaleFactor = 1.0;

  Widget menuImage(context, String imageUrl) {
    String fileName;
    File localFile;
    bool isExist = false;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      fileName = p.basename(imageUrl);
      localFile = File("${widget.dirToSave.path}/$fileName");
      isExist = localFile.existsSync();
    }
    var w = MediaQuery.of(context).size.width;
    var imgSize = w < 500 ? w : w / 2;
    return isExist
        ? ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.file(
              localFile,
              fit: BoxFit.contain,
              width: imgSize,
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              width: imgSize,
            ),
          );
  }

  headingView(String text) {
    return text != null && text.isNotEmpty
        ? AppText(
            text,
            size: 16,
            bold: true,
            align: TextAlign.center,
            sf: _scaleFactor,
          )
        : SizedBox();
  }

  customSeprator(String text) {
    double w = text != null ? text.length.roundToDouble() : 100.0;
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      height: 3,
      color: widget.appColor,
      width: w * 11,
    );
  }

  menuCatView(String text) {
    return text != null && text.isNotEmpty
        ? AppText(
            text,
            size: 18,
            bold: true,
            align: TextAlign.center,
            sf: _scaleFactor,
          )
        : SizedBox();
  }

  menuItemView(String text) {
    return text != null && text.isNotEmpty
        ? AppText(
            text,
            size: 14,
            bold: true,
            align: TextAlign.center,
            sf: _scaleFactor,
          )
        : SizedBox();
  }

  menuDescView(String text) {
    return text != null && text.isNotEmpty
        ? AppText(
            text,
            size: 12,
            italic: true,
            color: Colors.black87,
            align: TextAlign.center,
            sf: _scaleFactor,
          )
        : SizedBox();
  }

  priceView(String text) {
    return text != null && text.isNotEmpty
        ? AppText(
            text,
            size: 14,
            bold: true,
            align: TextAlign.center,
            sf: _scaleFactor,
          )
        : SizedBox();
  }

  getPrice(double p) {
    var price = p.round();
    switch (price) {
      case 0:
        return "";
      case -1:
        return "";
      case -2:
        return "/ Market";
      case -3:
        return "/ Seasonal";
      case -4:
        return "/ P/A";
      case -5:
        return "/ See Above";
      case -6:
        return "/ Select";
      case -7:
        return "/ Free";
      default:
        return "/ \$" + p.toStringAsFixed(2);
    }
  }

  itemView(MenuItem item) {
    return item.prices.count > 1
        ? Column(
            children: <Widget>[
              menuItemView(item.name),
              item.description != null
                  ? menuDescView(item.description)
                  : SizedBox(),
              const SizedBox(height: 5),
              Column(
                children: <Widget>[
                  for (var p in item.prices.list)
                    priceView('${p.heading} ${getPrice(p.price)}'),
                ],
              ),
              const SizedBox(height: 25),
            ],
          )
        : Column(
            children: <Widget>[
              menuItemView(
                '${item.name}' + getPrice(item.prices.list[0].price),
              ),
              item.description != null
                  ? menuDescView(item.description)
                  : SizedBox(),
              const SizedBox(height: 25),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        _baseScaleFactor = _scaleFactor;
      },
      onScaleUpdate: (details) {
        setState(() {
          if (details.scale < 1)
            _scaleFactor = 1.0;
          else
            _scaleFactor = _baseScaleFactor * details.scale;
        });
      },
      child: Container(
        padding: pagePadding,
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  for (var cat in widget.menuTab.categories.list)
                    Column(
                      children: <Widget>[
                        menuCatView(cat.name),
                        customSeprator(cat.name),
                        cat.header != null
                            ? menuDescView(cat.header)
                            : SizedBox(),
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: cat.headerURL != null
                              ? menuImage(context, cat.headerURL.path)
                              : SizedBox(),
                        ),
                        for (var mi in cat.menuItems.list) itemView(mi),
                        const SizedBox(height: 10),
                        menuDescView(cat.footer),
                      ],
                    ),
                  SizedBox(height: 60),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                OrderButton(context, widget.metadata, widget.appColor),
              ],
            )
          ],
        ),
      ),
    );
  }
}
