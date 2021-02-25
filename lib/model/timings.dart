class Timing {
  int ordinal;
  String description;

  Timing(this.ordinal, this.description);
  Map<String, dynamic> toJson() => linkToJson(this);

  factory Timing.fromJson(Map<String, dynamic> json) {
    return Timing(
      json['ordinal'],
      json['description'],
    );
  }

  Map<String, dynamic> linkToJson(Timing t) =>
      <String, dynamic>{'ordinal': t.ordinal, 'description': t.description};
}

class Timings {
  List<Timing> list;
  Timings(this.list);

  factory Timings.fromJson(List parsedJson) {
    var linkList = parsedJson.map((c) => Timing.fromJson(c)).toList();
    return Timings(linkList);
  }

  Map<String, dynamic> timeToJson(Timings l) => <String, dynamic>{
        'hoursOfOperation': l.list.map((l) => l.toJson()).toList()
      };
}
