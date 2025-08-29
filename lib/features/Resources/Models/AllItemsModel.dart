
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
    num? price;
    num? time;
    String? imageUrl;

    Items({this.id, this.name, this.description, this.price, this.time, this.imageUrl});

    Items.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        name = json["name"];
        description = json["description"];
        price = json["price"];
        time = json["time"];
        imageUrl = json["image_url"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["name"] = name;
        _data["description"] = description;
        _data["price"] = price;
        _data["time"] = time;
        _data["image_url"] = imageUrl;
        return _data;
    }
}