
class ComplaintsModel {
    List<Complaints>? complaints;

    ComplaintsModel({this.complaints});

    ComplaintsModel.fromJson(Map<String, dynamic> json) {
        complaints = json["complaints"] == null ? null : (json["complaints"] as List).map((e) => Complaints.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(complaints != null) {
            _data["complaints"] = complaints?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class Complaints {
    int? id;
    String? customerName;
    String? message;
    String? status;
    String? date;

    Complaints({this.id, this.customerName, this.message, this.status, this.date});

    Complaints.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        customerName = json["customer_name"];
        message = json["message"];
        status = json["status"];
        date = json["date"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["customer_name"] = customerName;
        _data["message"] = message;
        _data["status"] = status;
        _data["date"] = date;
        return _data;
    }
}