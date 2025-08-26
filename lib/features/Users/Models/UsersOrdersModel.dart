
class UserOrders {
    List<Orders>? orders;

    UserOrders({this.orders});

    UserOrders.fromJson(Map<String, dynamic> json) {
        orders = json["orders"] == null ? null : (json["orders"] as List).map((e) => Orders.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(orders != null) {
            _data["orders"] = orders?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class Orders {
    String? name;
    String? type;
    String? status;
    String? image;

    Orders({this.name, this.type, this.status, this.image});

    Orders.fromJson(Map<String, dynamic> json) {
        name = json["name"];
        type = json["type"];
        status = json["status"];
        image = json["image"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["name"] = name;
        _data["type"] = type;
        _data["status"] = status;
        _data["image"] = image;
        return _data;
    }
}