enum MessageStatus {
  sending,
  sent,
  failed,
}

class ChatInitModel {
  bool? success;
  Data? data;
  String? message;

  ChatInitModel({this.success, this.data, this.message});

  ChatInitModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
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
        messages!.add(Messages.fromJson(v));
      });
    }
    total = json['total'];
    isNew = json['isNew'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['conversationId'] = conversationId;
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['isNew'] = isNew;
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
  MessageStatus status;
  String? clientMessageId;

  Messages({
    this.sId,
    this.conversationId,
    this.userId,
    this.role,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.metadata,
    this.status = MessageStatus.sent,
    this.clientMessageId,
  });

  Messages.fromJson(Map<String, dynamic> json)
      : sId = json['_id'] ?? json['id'],
        conversationId = json['conversationId'],
        userId = json['userId'],
        role = json['role'],
        content = json['content'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'],
        iV = json['__v'],
        clientMessageId = json['clientMessageId'],
        status = _parseStatus(json['status']),
        metadata = json['metadata'] != null
            ? Metadata.fromJson(json['metadata'])
            : null;

  static MessageStatus _parseStatus(dynamic value) {
    if (value == null) return MessageStatus.sent;
    final str = value.toString().toLowerCase();
    if (str == 'sending') return MessageStatus.sending;
    if (str == 'failed') return MessageStatus.failed;
    return MessageStatus.sent;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['conversationId'] = conversationId;
    data['userId'] = userId;
    data['role'] = role;
    data['content'] = content;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['status'] = status.name;
    data['clientMessageId'] = clientMessageId;
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tokens'] = tokens;
    data['provider'] = provider;
    data['model'] = model;
    data['responseTime'] = responseTime;
    return data;
  }
}
