
class UserModel {
    List<Customers>? customers;

    UserModel({this.customers});

    UserModel.fromJson(Map<String, dynamic> json) {
        customers = json["customers"] == null ? null : (json["customers"] as List).map((e) => Customers.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(customers != null) {
            _data["customers"] = customers?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class Customers {
    int? id;
    String? name;
    String? email;
    String? profileImage;

    Customers({this.id, this.name, this.email, this.profileImage});

    Customers.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        name = json["name"];
        email = json["email"];
        profileImage = json["profile_image"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["name"] = name;
        _data["email"] = email;
        _data["profile_image"] = profileImage;
        return _data;
    }
}