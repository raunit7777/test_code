class MassageRoleModel {
  bool? success;
  Data? data;
  String? message;

  MassageRoleModel({this.success, this.data, this.message});

  MassageRoleModel.fromJson(Map<String, dynamic> json) {
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
  String? conversationId;
  Message? message;
  CompanionMessage? companionMessage;

  Data({this.conversationId, this.message, this.companionMessage});

  Data.fromJson(Map<String, dynamic> json) {
    conversationId = json['conversationId'];
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
    companionMessage = json['companionMessage'] != null
        ? new CompanionMessage.fromJson(json['companionMessage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['conversationId'] = this.conversationId;
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    if (this.companionMessage != null) {
      data['companionMessage'] = this.companionMessage!.toJson();
    }
    return data;
  }
}

class Message {
  String? id;
  String? content;
  String? role;
  String? createdAt;

  Message({this.id, this.content, this.role, this.createdAt});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    role = json['role'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['role'] = this.role;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class CompanionMessage {
  String? id;
  String? content;
  String? role;
  String? createdAt;
  String? language;
  String? intent;
  Null? action;

  CompanionMessage(
      {this.id,
        this.content,
        this.role,
        this.createdAt,
        this.language,
        this.intent,
        this.action});

  CompanionMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    role = json['role'];
    createdAt = json['createdAt'];
    language = json['language'];
    intent = json['intent'];
    action = json['action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['role'] = this.role;
    data['createdAt'] = this.createdAt;
    data['language'] = this.language;
    data['intent'] = this.intent;
    data['action'] = this.action;
    return data;
  }
}
