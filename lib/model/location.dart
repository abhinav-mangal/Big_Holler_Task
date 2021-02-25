import '../imports.dart';

class Location {
  int id;
  String name;
  String address;
  String orderLink;
  String locationImage;

  bool isRatingAvailable;
  double avgRating;
  double totalRating;

  String loyaltyProgramLink;
  Timings hoursOfOperation;
  bool locationOpen;
  String locationCloseTime;

  GalleryImages gallery;
  Links links;
  IMenus menus;
  MenuTabs menuTabs;

  bool isDirectionVisible;
  String gmapLink;
  String ymapLink;
  String wazeLink;
  String website;
  double latitude;
  double longitude;
  double distance;
  String reviewsLink;

  Location({
    this.id,
    this.name,
    this.address,
    this.orderLink,
    this.locationImage,
    this.isRatingAvailable,
    this.avgRating,
    this.totalRating,
    this.loyaltyProgramLink,
    this.hoursOfOperation,
    this.locationOpen,
    this.locationCloseTime,
    this.gallery,
    this.links,
    this.menus,
    this.menuTabs,
    this.isDirectionVisible,
    this.gmapLink,
    this.ymapLink,
    this.wazeLink,
    this.latitude,
    this.longitude,
    this.distance,
    this.reviewsLink,
  });

  Map<String, dynamic> toJson() => locToJson(this);

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json[j_id],
      name: json[j_name],
      address: json[j_address],
      orderLink: json[j_orderLink],
      locationImage: json[j_locationImage],
      isRatingAvailable: json[j_isRatingAvailable],
      avgRating: json[j_avgRating],
      totalRating: json[j_totalRating],
      loyaltyProgramLink: json[j_loyaltyProgramLink],
      hoursOfOperation: Timings.fromJson(json[j_hoursOfOperation] as List),
      locationOpen: json[j_locationOpen],
      locationCloseTime: json[j_locationCloseTime],
      gallery: GalleryImages.fromJson(json[j_gallery] as List),
      links: Links.fromJson(json[j_links] as List),
      menus: IMenus.fromJson(json[j_menu] as List),
      menuTabs: json[j_display_menu] != null
          ? MenuTabs.fromJson(json[j_display_menu])
          : null,
      isDirectionVisible: json[j_isDirectionVisible],
      gmapLink: json[j_gmapLink],
      ymapLink: json[j_ymapLink],
      wazeLink: json[j_wazeLink],
      latitude: json[j_latitude],
      longitude: json[j_longitude],
      reviewsLink: json[j_reviewsLink],
    );
  }

  Map<String, dynamic> locToJson(Location loc) => <String, dynamic>{
        j_id: id,
        j_name: loc.name,
        j_address: loc.address,
        j_orderLink: loc.orderLink,
        j_locationImage: loc.locationImage,
        j_isRatingAvailable: loc.isRatingAvailable,
        j_avgRating: loc.avgRating,
        j_totalRating: loc.totalRating,
        j_loyaltyProgramLink: loc.loyaltyProgramLink,
        j_hoursOfOperation:
            loc.hoursOfOperation.list.map((h) => h.toJson()).toList(),
        j_locationOpen: loc.locationOpen,
        j_locationCloseTime: loc.locationCloseTime,
        j_gallery: loc.gallery.list.map((g) => g.toJson()).toList(),
        j_links: loc.links.list.map((l) => l.toJson()).toList(),
        j_menu: loc.menus.list.map((m) => m.toJson()).toList(),
        j_display_menu: menuTabs != null ? menuTabs.toJson() : null,
        j_isDirectionVisible: loc.isDirectionVisible,
        j_gmapLink: loc.gmapLink,
        j_ymapLink: loc.ymapLink,
        j_wazeLink: loc.wazeLink,
        j_latitude: loc.latitude,
        j_longitude: loc.longitude,
        j_distance: loc.distance,
        j_reviewsLink: loc.reviewsLink,
      };
}

class Locations {
  final List<Location> list;
  Locations(this.list);
  Map<String, dynamic> toJson() => locToJson(this);

  factory Locations.fromJson(List parsedJson) {
    var locList = parsedJson.map((c) => Location.fromJson(c)).toList();
    return Locations(locList);
  }

  Map<String, dynamic> locToJson(Locations htl) =>
      <String, dynamic>{j_locations: htl.list.map((h) => h.toJson()).toList()};
}
