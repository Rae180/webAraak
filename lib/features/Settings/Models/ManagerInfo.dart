class ManagerInfo {
  String? fullName;
  String? phone;
  String? email;

  ManagerInfo({
    this.fullName,
    this.phone,
    this.email,
  });

  ManagerInfo.fromJson(Map<String, dynamic> json) {
    fullName = json["full_name"];
    phone = json["phone"];
    email = json["email"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["full_name"] = fullName;
    _data["phone"] = phone;
    _data["email"] = email;
    return _data;
  }
}
