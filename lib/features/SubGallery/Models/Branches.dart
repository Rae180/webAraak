
class BranchesModel {
    List<Branches>? branches;

    BranchesModel({this.branches});

    BranchesModel.fromJson(Map<String, dynamic> json) {
        branches = json["branches"] == null ? null : (json["branches"] as List).map((e) => Branches.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(branches != null) {
            _data["branches"] = branches?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class Branches {
    int? id;
    int? subManagerId;
    String? address;
    String? latitude;
    String? longitude;
    dynamic createdAt;
    dynamic updatedAt;

    Branches({this.id, this.subManagerId, this.address, this.latitude, this.longitude, this.createdAt, this.updatedAt});

    Branches.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        subManagerId = json["sub_manager_id"];
        address = json["address"];
        latitude = json["latitude"];
        longitude = json["longitude"];
        createdAt = json["created_at"];
        updatedAt = json["updated_at"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["sub_manager_id"] = subManagerId;
        _data["address"] = address;
        _data["latitude"] = latitude;
        _data["longitude"] = longitude;
        _data["created_at"] = createdAt;
        _data["updated_at"] = updatedAt;
        return _data;
    }
}