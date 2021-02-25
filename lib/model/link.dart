import '../imports.dart';

class Link {
  String name;
  String url;
  int type;

  Link({this.name, this.url, this.type});
  Map<String, dynamic> toJson() => linkToJson(this);

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      name: json[j_name],
      url: json[j_url],
      type: json[j_type],
    );
  }

  Map<String, dynamic> linkToJson(Link l) => <String, dynamic>{
        j_name: l.name,
        j_url: l.url,
        j_type: l.type,
      };
}

class Links {
  List<Link> list;
  Links({this.list});
  Map<String, dynamic> toJson() => linksToJson(this);

  factory Links.fromJson(List parsedJson) {
    var linkList = parsedJson.map((c) => Link.fromJson(c)).toList();
    return Links(list: linkList);
  }

  Map<String, dynamic> linksToJson(Links l) =>
      <String, dynamic>{j_links: l.list.map((l) => l.toJson()).toList()};
}
