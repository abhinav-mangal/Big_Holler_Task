import '../imports.dart';

class Metadata {
  int id;
  Locations locations;
  String splashImage;
  String primaryColor;
  String description;
  String logo;
  String name;
  int organizationId;
  bool inLoyaltyProgram;
  double loyaltyReward;
  double loyaltyThreshold;
  double distance;

  Metadata({
    this.id,
    this.primaryColor,
    this.splashImage,
    this.description,
    this.locations,
    this.logo,
    this.name,
    this.organizationId,
    this.inLoyaltyProgram,
    this.loyaltyReward,
    this.loyaltyThreshold,
    this.distance = 0,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      id: json[j_id],
      logo: json['logo'],
      name: json[j_name],
      splashImage: json['splashImage'],
      description: json['description'],
      primaryColor: json['primaryColor'],
      locations: Locations.fromJson(json[j_locations] as List),
      organizationId: json['organization_id'],
      inLoyaltyProgram: json['participates_in_loyalty'],
      loyaltyReward: json[j_loyaltyReward],
      loyaltyThreshold: json[j_loyaltyThreshold],
      distance: json[j_distance],
    );
  }

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();
    json[j_id] = id;
    json['logo'] = logo;
    json[j_name] = name;
    json['splashImage'] = splashImage;
    json['description'] = description;
    json['primaryColor'] = primaryColor;
    json[j_locations] = locations.list.map((h) => h.toJson()).toList();
    json['organization_id'] = organizationId;
    json['participates_in_loyalty'] = inLoyaltyProgram;
    json[j_loyaltyReward] = loyaltyReward;
    json[j_loyaltyThreshold] = loyaltyThreshold;
    json[j_distance] = distance;
    return json;
  }
}

class Metadatas {
  final List<Metadata> list;
  Metadatas(this.list);
  Map<String, dynamic> toJson() => locToJson(this);

  factory Metadatas.fromJson(List parsedJson) {
    var metaList = parsedJson.map((c) => Metadata.fromJson(c)).toList();
    return Metadatas(metaList);
  }

  Map<String, dynamic> locToJson(Metadatas meta) =>
      <String, dynamic>{j_metadatas: meta.list.map((h) => h.toJson()).toList()};
}
