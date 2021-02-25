import '../imports.dart';
import 'dart:io';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var pages = <Widget>[];
    var tabList = <Widget>[];

    Param param = ModalRoute.of(context).settings.arguments;
    Metadata metadata = param.metadata;
    Location location = param.location;
    Directory dirToSave = param.dir;
    Color appColor = Helper.getColorFromHex(metadata.primaryColor);
    int tabCount = location.menuTabs.list.length;
    bool isScroll = tabCount > 2;
    for (var m in location.menuTabs.list) {
      tabList.add(
        Tab(
          icon: AppText(
            m.name.toUpperCase(),
            color: Colors.white,
            bold: true,
          ),
        ),
      );
      pages.add(
        MenuView(
          metadata,
          m,
          location.orderLink,
          appColor,
          dirToSave,
        ),
      );
    }

    return SafeArea(
      child: DefaultTabController(
        length: tabCount,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: appColor,
            iconTheme: IconThemeData(color: Colors.white),
            centerTitle: true,
            title: Text('MENU', style: TextStyle(color: Colors.white)),
            bottom: TabBar(
              isScrollable: isScroll,
              indicatorColor: Colors.white,
              tabs: tabList,
            ),
          ),
          body: TabBarView(
            physics: AlwaysScrollableScrollPhysics(),
            children: pages,
          ),
        ),
        initialIndex: 0,
        key: UniqueKey(),
      ),
    );
  }
}
