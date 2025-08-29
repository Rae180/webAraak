
class AllOrdersModel {
    List<Orders>? orders;

    AllOrdersModel({this.orders});

    AllOrdersModel.fromJson(Map<String, dynamic> json) {
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
    int? id;
    String? status;
    int? remainingTime;
    double? remainingBill;
    String? isPaid;

    Orders({this.id, this.status, this.remainingTime, this.remainingBill, this.isPaid});

    Orders.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        status = json["status"];
        remainingTime = json["remaining_time"];
        remainingBill = json["remaining_bill"];
        isPaid = json["is_paid"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["status"] = status;
        _data["remaining_time"] = remainingTime;
        _data["remaining_bill"] = remainingBill;
        _data["is_paid"] = isPaid;
        return _data;
    }
}