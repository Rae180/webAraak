
class CategoryModel {
    List<Categories>? categories;

    CategoryModel({this.categories});

    CategoryModel.fromJson(Map<String, dynamic> json) {
        categories = json["categories"] == null ? null : (json["categories"] as List).map((e) => Categories.fromJson(e)).toList();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        if(categories != null) {
            _data["categories"] = categories?.map((e) => e.toJson()).toList();
        }
        return _data;
    }
}

class Categories {
    int? id;
    String? name;

    Categories({this.id, this.name});

    Categories.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        name = json["name"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["name"] = name;
        return _data;
    }
}