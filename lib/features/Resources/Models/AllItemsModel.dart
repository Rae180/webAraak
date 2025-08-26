
class AllItemsModel {
    List<Items>? items;

    AllItemsModel({this.items});

    AllItemsModel.fromJson(Map<String, dynamic> json) {
        items = json["items"] == null ? null : (json["items"] as List).map((e) => Items.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(items != null) {
            _data["items"] = items?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class Items {
    int? id;
    String? name;
    String? description;
    double? price;

    Items({this.id, this.name, this.description, this.price});

    Items.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        name = json["name"];
        description = json["description"];
        price = json["price"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["name"] = name;
        _data["description"] = description;
        _data["price"] = price;
        return _data;
    }
}