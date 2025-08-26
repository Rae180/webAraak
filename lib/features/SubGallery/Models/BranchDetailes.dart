
class BrancheDetiles {
    int? id;
    String? address;
    String? latitude;
    String? longitude;
    Manager? manager;

    BrancheDetiles({this.id, this.address, this.latitude, this.longitude, this.manager});

    BrancheDetiles.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        address = json["address"];
        latitude = json["latitude"];
        longitude = json["longitude"];
        manager = json["manager"] == null ? null : Manager.fromJson(json["manager"]);
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["address"] = address;
        _data["latitude"] = latitude;
        _data["longitude"] = longitude;
        if(manager != null) {
            _data["manager"] = manager?.toJson();
        }
        return _data;
    }
}

class Manager {
    String? name;
    String? email;
    String? phone;

    Manager({this.name, this.email, this.phone});

    Manager.fromJson(Map<String, dynamic> json) {
        name = json["name"];
        email = json["email"];
        phone = json["phone"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["name"] = name;
        _data["email"] = email;
        _data["phone"] = phone;
        return _data;
    }
}