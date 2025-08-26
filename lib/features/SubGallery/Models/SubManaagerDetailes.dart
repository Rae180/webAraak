
class SubManagerDetailes {
    int? id;
    String? image;
    String? name;
    String? phone;
    String? email;

    SubManagerDetailes({this.id, this.image, this.name, this.phone, this.email});

    SubManagerDetailes.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        image = json["image"];
        name = json["name"];
        phone = json["phone"];
        email = json["email"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["image"] = image;
        _data["name"] = name;
        _data["phone"] = phone;
        _data["email"] = email;
        return _data;
    }
}