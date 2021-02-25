import '../imports.dart';

class IMenuURL {
  int id;
  String path;
  String lastUpdated;
  IMenuURL(this.id, this.path, this.lastUpdated);

  factory IMenuURL.fromJson(Map<String, dynamic> json) {
    return IMenuURL(
      json[j_id],
      json[j_path],
      json[j_last_updated],
    );
  }

  Map<String, dynamic> toJson() => menuUrlToJson(this);
  Map<String, dynamic> menuUrlToJson(IMenuURL m) {
    return <String, dynamic>{
      j_id: m.id,
      j_path: m.path,
      j_last_updated: m.lastUpdated
    };
  }
}

class IMenuTab {
  List<IMenuURL> list;
  IMenuTab(this.list);

  factory IMenuTab.fromJson(List parsedJson) {
    var linkList = parsedJson.map((m) => IMenuURL.fromJson(m)).toList();
    return IMenuTab(linkList);
  }

  List<dynamic> toJson() => menuUrlsToJson(this);
  List<dynamic> menuUrlsToJson(IMenuTab m) {
    return m.list.map((l) => l.toJson()).toList();
  }
}

class IMenu {
  String name;
  IMenuTab urls;
  IMenu(this.name, this.urls);

  factory IMenu.fromJson(Map<String, dynamic> json) {
    return IMenu(
      json[j_name],
      IMenuTab.fromJson(json[j_urls] as List),
    );
  }

  Map<String, dynamic> toJson() => menuToJson(this);
  Map<String, dynamic> menuToJson(IMenu m) {
    return <String, dynamic>{j_name: m.name, j_urls: m.urls};
  }
}

class IMenus {
  List<IMenu> list;
  IMenus(this.list);

  factory IMenus.fromJson(List parsedJson) {
    var menuList = parsedJson.map((c) => IMenu.fromJson(c)).toList();
    return IMenus(menuList);
  }

  Map<String, dynamic> toJson() => menusToJson(this);
  Map<String, dynamic> menusToJson(IMenus mn) {
    return <String, dynamic>{j_menus: mn.list.map((m) => m.toJson())};
  }
}
