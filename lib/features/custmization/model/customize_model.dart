class CustomizeModel {
  bool? success;
  Data? data;
  String? message;

  CustomizeModel({this.success, this.data, this.message});

  CustomizeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  Character? character;
  bool? canCustomize;
  int? maxAdditionalTraits;
  List<Sliders>? sliders;
  List<AdditionalTraits>? additionalTraits;

  Data(
      {this.character,
        this.canCustomize,
        this.maxAdditionalTraits,
        this.sliders,
        this.additionalTraits});

  Data.fromJson(Map<String, dynamic> json) {
    character = json['character'] != null
        ? new Character.fromJson(json['character'])
        : null;
    canCustomize = json['canCustomize'];
    maxAdditionalTraits = json['maxAdditionalTraits'];
    if (json['sliders'] != null) {
      sliders = <Sliders>[];
      json['sliders'].forEach((v) {
        sliders!.add(new Sliders.fromJson(v));
      });
    }
    if (json['additionalTraits'] != null) {
      additionalTraits = <AdditionalTraits>[];
      json['additionalTraits'].forEach((v) {
        additionalTraits!.add(new AdditionalTraits.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.character != null) {
      data['character'] = this.character!.toJson();
    }
    data['canCustomize'] = this.canCustomize;
    data['maxAdditionalTraits'] = this.maxAdditionalTraits;
    if (this.sliders != null) {
      data['sliders'] = this.sliders!.map((v) => v.toJson()).toList();
    }
    if (this.additionalTraits != null) {
      data['additionalTraits'] =
          this.additionalTraits!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Character {
  String? sId;
  String? name;
  String? image;

  Character({this.sId, this.name, this.image});

  Character.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}

class Sliders {
  String? traitId;
  Left? left;
  Left? right;
  int? value;

  Sliders({this.traitId, this.left, this.right, this.value});

  Sliders.fromJson(Map<String, dynamic> json) {
    traitId = json['traitId'];
    left = json['left'] != null ? new Left.fromJson(json['left']) : null;
    right = json['right'] != null ? new Left.fromJson(json['right']) : null;
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['traitId'] = this.traitId;
    if (this.left != null) {
      data['left'] = this.left!.toJson();
    }
    if (this.right != null) {
      data['right'] = this.right!.toJson();
    }
    data['value'] = this.value;
    return data;
  }
}

class Left {
  String? label;
  String? emoji;

  Left({this.label, this.emoji});

  Left.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    emoji = json['emoji'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['emoji'] = this.emoji;
    return data;
  }
}

class AdditionalTraits {
  String? traitId;
  String? name;
  bool? selected;

  AdditionalTraits({this.traitId, this.name, this.selected});

  AdditionalTraits.fromJson(Map<String, dynamic> json) {
    traitId = json['traitId'];
    name = json['name'];
    selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['traitId'] = this.traitId;
    data['name'] = this.name;
    data['selected'] = this.selected;
    return data;
  }
}
