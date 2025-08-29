class OptionsModel {
  List<Options>? options;

  OptionsModel({this.options});

  OptionsModel.fromJson(Map<String, dynamic> json) {
    options = json["options"] == null
        ? null
        : (json["options"] as List).map((e) => Options.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (options != null) {
      _data["options"] = options?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Options {
  int? woodId;
  int? fabricId;

  Options({this.woodId, this.fabricId});

  Options.fromJson(Map<String, dynamic> json) {
    woodId = json["wood_id"];
    fabricId = json["fabric_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["wood_id"] = woodId;
    _data["fabric_id"] = fabricId;
    return _data;
  }
}
