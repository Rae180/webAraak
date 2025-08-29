
class AllWoodModel {
    List<Wood>? wood;

    AllWoodModel({this.wood});

    AllWoodModel.fromJson(Map<String, dynamic> json) {
        wood = json["wood"] == null ? null : (json["wood"] as List).map((e) => Wood.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(wood != null) {
            _data["wood"] = wood?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class Wood {
    int? id;
    String? type;
    String? color;
    int? woodTypeId;
    int? woodColorId;
    dynamic pricePerMeter;

    Wood({this.id, this.type, this.color, this.woodTypeId, this.woodColorId, this.pricePerMeter});

    Wood.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        type = json["type"];
        color = json["color"];
        woodTypeId = json["wood_type_id"];
        woodColorId = json["wood_color_id"];
        pricePerMeter = json["price_per_meter"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["type"] = type;
        _data["color"] = color;
        _data["wood_type_id"] = woodTypeId;
        _data["wood_color_id"] = woodColorId;
        _data["price_per_meter"] = pricePerMeter;
        return _data;
    }
}