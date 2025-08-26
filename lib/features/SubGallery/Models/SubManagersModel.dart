
class SubManagersModel {
    List<Managers>? managers;

    SubManagersModel({this.managers});

    SubManagersModel.fromJson(Map<String, dynamic> json) {
        managers = json["managers"] == null ? null : (json["managers"] as List).map((e) => Managers.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(managers != null) {
            _data["managers"] = managers?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class Managers {
    int? id;
    String? name;
    dynamic image;
    String? email;
    String? phone;

    Managers({this.id, this.name, this.image, this.email, this.phone});

    Managers.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        name = json["name"];
        image = json["image"];
        email = json["email"];
        phone = json["phone"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["name"] = name;
        _data["image"] = image;
        _data["email"] = email;
        _data["phone"] = phone;
        return _data;
    }
}