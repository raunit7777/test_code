class ChatInitModel {
  bool? success;
  Data? data;
  String? message;

  ChatInitModel({this.success, this.data, this.message});

  ChatInitModel.fromJson(Map<String, dynamic> json) {
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
  List<Messages>? messages;
  int? total;
  bool? isNew;

  Data({this.conversationId, this.messages, this.total, this.isNew});

  Data.fromJson(Map<String, dynamic> json) {
    conversationId = json['conversationId'];
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
    total = json['total'];
    isNew = json['isNew'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['conversationId'] = this.conversationId;
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['isNew'] = this.isNew;
    return data;
  }
}

class Messages {
  String? sId;
  String? conversationId;
  String? userId;
  String? role;
  String? content;
  String? createdAt;
  String? updatedAt;
  int? iV;
  Metadata? metadata;

  Messages(
      {this.sId,
        this.conversationId,
        this.userId,
        this.role,
        this.content,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.metadata});

  Messages.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    conversationId = json['conversationId'];
    userId = json['userId'];
    role = json['role'];
    content = json['content'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['conversationId'] = this.conversationId;
    data['userId'] = this.userId;
    data['role'] = this.role;
    data['content'] = this.content;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    return data;
  }
}

class Metadata {
  int? tokens;
  String? provider;
  String? model;
  int? responseTime;

  Metadata({this.tokens, this.provider, this.model, this.responseTime});

  Metadata.fromJson(Map<String, dynamic> json) {
    tokens = json['tokens'];
    provider = json['provider'];
    model = json['model'];
    responseTime = json['responseTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tokens'] = this.tokens;
    data['provider'] = this.provider;
    data['model'] = this.model;
    data['responseTime'] = this.responseTime;
    return data;
  }
}
