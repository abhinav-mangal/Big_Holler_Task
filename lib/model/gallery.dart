import '../imports.dart';

class Gallery {
  String name;
  String path;
  String lastUpdated;
  Gallery({this.name, this.path, this.lastUpdated});
  Map<String, dynamic> toJson() => menuToJson(this);

  factory Gallery.fromJson(Map<String, dynamic> json) {
    return Gallery(
      name: json[j_name],
      path: (json[j_url]),
      lastUpdated: (json[j_last_updated]),
    );
  }

  Map<String, dynamic> menuToJson(Gallery m) => <String, dynamic>{
        j_name: m.name,
        j_url: m.path,
        j_last_updated: m.lastUpdated
      };
}

class GalleryImages {
  List<Gallery> list;
  GalleryImages(this.list);
  Map<String, dynamic> toJson() => menusToJson(this);

  factory GalleryImages.fromJson(List parsedJson) {
    var menuList = parsedJson.map((c) => Gallery.fromJson(c)).toList();
    return GalleryImages(menuList);
  }
  Map<String, dynamic> menusToJson(GalleryImages mn) =>
      <String, dynamic>{j_gallery: mn.list.map((m) => m.toJson())};
}
