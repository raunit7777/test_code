import 'chat_init_model.dart';

class ChatInitRoleModel {
  bool? success;
  RoleChatData? data;
  String? message;

  ChatInitRoleModel({this.success, this.data, this.message});

  ChatInitRoleModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? RoleChatData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['success'] = success;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    map['message'] = message;
    return map;
  }
}

class RoleChatData {
  String? conversationId;
  String? sessionId;
  List<RoleChatMessage>? messages;
  int? total;
  bool? isNew;

  RoleChatData({
    this.conversationId,
    this.sessionId,
    this.messages,
    this.total,
    this.isNew,
  });

  RoleChatData.fromJson(Map<String, dynamic> json) {
    conversationId = json['conversationId'];
    sessionId = json['sessionId'];
    if (json['messages'] != null) {
      messages = <RoleChatMessage>[];
      json['messages'].forEach((v) {
        messages!.add(RoleChatMessage.fromJson(v));
      });
    }
    total = json['total'];
    isNew = json['isNew'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['conversationId'] = conversationId;
    map['sessionId'] = sessionId;
    if (messages != null) {
      map['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    map['total'] = total;
    map['isNew'] = isNew;
    return map;
  }
}

class RoleChatMessage {
  String? sId;
  String? conversationId;
  String? userId;
  String? role;
  String? content;
  String? createdAt;
  MessageStatus status;
  String? clientMessageId;

  RoleChatMessage({
    this.sId,
    this.conversationId,
    this.userId,
    this.role,
    this.content,
    this.createdAt,
    this.status = MessageStatus.sent,
    this.clientMessageId,
  });

  RoleChatMessage.fromJson(Map<String, dynamic> json)
      : sId = json['_id'] ?? json['id'],
        conversationId = json['conversationId'],
        userId = json['userId'],
        role = json['role'],
        content = json['content'],
        createdAt = json['createdAt'],
        clientMessageId = json['clientMessageId'],
        status = _parseStatus(json['status']);

  static MessageStatus _parseStatus(dynamic value) {
    if (value == null) return MessageStatus.sent;
    final str = value.toString().toLowerCase();
    if (str == 'sending') return MessageStatus.sending;
    if (str == 'failed') return MessageStatus.failed;
    return MessageStatus.sent;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['_id'] = sId;
    map['conversationId'] = conversationId;
    map['userId'] = userId;
    map['role'] = role;
    map['content'] = content;
    map['createdAt'] = createdAt;
    map['status'] = status.name;
    map['clientMessageId'] = clientMessageId;
    return map;
  }
}
