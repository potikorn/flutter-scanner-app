class NutritionModel {
  String? key;
  KeyValueModel? parent;
  List<NutritionModel>? children;

  NutritionModel({this.key, this.parent, this.children});
}

class KeyValueModel {
  String? label;
  String? value;

  KeyValueModel({this.label, this.value});
}
