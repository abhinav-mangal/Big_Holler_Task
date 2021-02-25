import '../imports.dart';

class MenuTabs {
  final List<MenuTab> list;
  MenuTabs({this.list});

  factory MenuTabs.fromJson(List<dynamic> data) {
    List<MenuTab> tabs =
        data != null ? data.map((mg) => MenuTab.fromJson(mg)).toList() : [];
    return MenuTabs(list: tabs);
  }

  List<dynamic> toJson() => objToJson(this);
  List<dynamic> objToJson(MenuTabs tabs) =>
      tabs.list.map((m) => m.toJson()).toList();
}

class MenuTab {
  final String name;
  final bool defaul;
  final String description;
  final Categories categories;
  MenuTab({this.name, this.description, this.defaul, this.categories});

  factory MenuTab.fromJson(Map<String, dynamic> data) {
    return MenuTab(
      name: data[j_name],
      defaul: data[j_default],
      description: data[j_description],
      categories: Categories.fromJson(
        data[j_categories],
      ),
    );
  }

  Map<String, dynamic> toJson() => objToJson(this);
  Map<String, dynamic> objToJson(MenuTab mt) {
    return <String, dynamic>{
      j_name: mt.name,
      j_default: mt.defaul,
      j_description: mt.description,
      j_categories: mt.categories.toJson()
    };
  }
}

class Categories {
  final List<Category> list;
  Categories({this.list});

  factory Categories.fromJson(List<dynamic> items) {
    List<Category> cats =
        items != null ? items.map((i) => Category.fromJson(i)).toList() : [];
    return Categories(list: cats);
  }

  List<dynamic> toJson() => objToJson(this);
  List<dynamic> objToJson(Categories cats) =>
      cats.list.map((m) => m.toJson()).toList();
}

class HeaderURL {
  final int id;
  final int tab;
  final String path;
  final String lastUpdated;
  HeaderURL({
    this.id,
    this.tab,
    this.path,
    this.lastUpdated,
  });

  factory HeaderURL.fromJson(Map<String, dynamic> json) {
    return HeaderURL(
      id: json[j_id],
      tab: json[j_tab],
      path: json[j_path],
      lastUpdated: json[j_last_updated],
    );
  }

  Map<String, dynamic> toJson() => menuUrlToJson(this);
  Map<String, dynamic> menuUrlToJson(HeaderURL m) {
    return <String, dynamic>{
      j_id: m.id,
      j_tab: m.tab,
      j_path: m.path,
      j_last_updated: m.lastUpdated
    };
  }
}

class Category {
  final String name;
  final String header;
  final String footer;
  final HeaderURL headerURL;
  final MenuItems menuItems;

  Category({
    this.name,
    this.header,
    this.footer,
    this.headerURL,
    this.menuItems,
  });

  factory Category.fromJson(Map<String, dynamic> data) {
    return Category(
      name: data[j_name],
      header: data[j_header],
      footer: data[j_footer],
      headerURL: data[j_url] != null ? HeaderURL.fromJson(data[j_url]) : null,
      menuItems: MenuItems.fromJson(data[j_menu_items]),
    );
  }

  Map<String, dynamic> toJson() => objToJson(this);
  Map<String, dynamic> objToJson(Category c) {
    return <String, dynamic>{
      j_name: c.name,
      j_header: c.header,
      j_footer: c.footer,
      j_url: c.headerURL != null ? c.headerURL.toJson() : null,
      j_menu_items: c.menuItems.toJson(),
    };
  }
}

class MenuItems {
  final int count;
  final List<MenuItem> list;
  MenuItems({this.count, this.list});

  factory MenuItems.fromJson(List<dynamic> items) {
    List<MenuItem> menus =
        items != null ? items.map((m) => MenuItem.fromJson(m)).toList() : [];
    return MenuItems(count: menus.length, list: menus);
  }

  List<dynamic> toJson() => objToJson(this);
  List<dynamic> objToJson(MenuItems mts) =>
      mts.list.map((m) => m.toJson()).toList();
}

class MenuItem {
  final String name;
  final String image;
  final String description;
  final Prices prices;

  MenuItem({
    this.name,
    this.image,
    this.description,
    this.prices,
  });

  factory MenuItem.fromJson(Map<String, dynamic> data) {
    return MenuItem(
        name: data[j_name],
        image: data[j_image_id],
        description: data[j_description],
        prices: Prices.fromJson(data[j_prices]));
  }

  Map<String, dynamic> toJson() => objToJson(this);
  Map<String, dynamic> objToJson(MenuItem m) {
    return <String, dynamic>{
      j_name: m.name,
      j_image_id: m.image,
      j_description: m.description,
      j_prices: m.prices.toJson(),
    };
  }
}

class Prices {
  final int count;
  final List<Price> list;
  Prices({this.count, this.list});

  factory Prices.fromJson(List<dynamic> items) {
    List<Price> prices =
        items != null ? items.map((p) => Price.fromJson(p)).toList() : [];
    return Prices(count: prices.length, list: prices);
  }

  List<dynamic> toJson() => objToJson(this);
  List<dynamic> objToJson(Prices prices) =>
      prices.list.map((m) => m.toJson()).toList();
}

class Price {
  final String heading;
  final double price;

  Price({
    this.heading,
    this.price,
  });

  factory Price.fromJson(Map<String, dynamic> data) {
    return Price(
      heading: data[j_heading],
      price: data[j_price],
    );
  }

  Map<String, dynamic> toJson() => objToJson(this);
  Map<String, dynamic> objToJson(Price price) {
    return <String, dynamic>{
      j_heading: price.heading,
      j_price: price.price,
    };
  }
}
