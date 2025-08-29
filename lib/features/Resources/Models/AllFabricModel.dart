
class AllFabricModel {
    List<Fabric>? fabric;

    AllFabricModel({this.fabric});

    AllFabricModel.fromJson(Map<String, dynamic> json) {
        fabric = json["fabric"] == null ? null : (json["fabric"] as List).map((e) => Fabric.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(fabric != null) {
            _data["fabric"] = fabric?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class Fabric {
    int? id;
    String? type;
    String? color;
    int? fabricColorId;
    int? fabricTypeId;
    dynamic pricePerMeter;

    Fabric({this.id, this.type, this.color, this.fabricColorId, this.fabricTypeId, this.pricePerMeter});

    Fabric.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        type = json["type"];
        color = json["color"];
        fabricColorId = json["fabric_color_id"];
        fabricTypeId = json["fabric_type_id"];
        pricePerMeter = json["price_per_meter"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["type"] = type;
        _data["color"] = color;
        _data["fabric_color_id"] = fabricColorId;
        _data["fabric_type_id"] = fabricTypeId;
        _data["price_per_meter"] = pricePerMeter;
        return _data;
    }
}