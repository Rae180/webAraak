
class AllRoomsModel {
    List<Rooms>? rooms;

    AllRoomsModel({this.rooms});

    AllRoomsModel.fromJson(Map<String, dynamic> json) {
        rooms = json["rooms"] == null ? null : (json["rooms"] as List).map((e) => Rooms.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(rooms != null) {
            _data["rooms"] = rooms?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class Rooms {
    int? id;
    String? name;
    String? imageUrl;
    String? description;
    num? price;
    String? time;

    Rooms({this.id, this.name, this.imageUrl, this.description, this.price, this.time});

    Rooms.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        name = json["name"];
        imageUrl = json["image_url"];
        description = json["description"];
        price = json["price"];
        time = json["time"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["name"] = name;
        _data["image_url"] = imageUrl;
        _data["description"] = description;
        _data["price"] = price;
        _data["time"] = time;
        return _data;
    }
}