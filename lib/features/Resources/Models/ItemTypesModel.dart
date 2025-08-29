class ItemTypesModel {
  List<ItemTypes>? itemTypes;

  ItemTypesModel({this.itemTypes});

  ItemTypesModel.fromJson(Map<String, dynamic> json) {
    itemTypes = json["item_types"] == null
        ? null
        : (json["item_types"] as List)
            .map((e) => ItemTypes.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (itemTypes != null) {
      _data["item_types"] = itemTypes?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class ItemTypes {
  int? id;
  String? name;
  String? description;

  ItemTypes({
    this.id,
    this.name,
    this.description,
  });

  ItemTypes.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    description = json["description"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["description"] = description;
    return _data;
  }
}
