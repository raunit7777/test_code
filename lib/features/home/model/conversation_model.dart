class ConversationModel {
  bool? success;
  Data? data;
  String? message;

  ConversationModel({this.success, this.data, this.message});

  ConversationModel.fromJson(Map<String, dynamic> json) {
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
  List<Items>? items;
  Pagination? pagination;

  Data({this.items, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Items {
  String? sId;
  String? userId;
  CompanionId? companionId;
  String? chatType;
  String? title;
  int? unreadCount;
  int? messageCount;
  bool? isActive;
  String? lastMessageAt;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? entityImage;
  String? chatEntityId;
  String? lastMessage;
  String? entityName;
  Null? conversationId;
  bool? isNew;

  Items(
      {this.sId,
        this.userId,
        this.companionId,
        this.chatType,
        this.title,
        this.unreadCount,
        this.messageCount,
        this.isActive,
        this.lastMessageAt,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.entityImage,
        this.chatEntityId,
        this.lastMessage,
        this.entityName,
        this.conversationId,
        this.isNew});

  Items.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    companionId = json['companionId'] != null
        ? new CompanionId.fromJson(json['companionId'])
        : null;
    chatType = json['chatType'];
    title = json['title'];
    unreadCount = json['unreadCount'];
    messageCount = json['messageCount'];
    isActive = json['isActive'];
    lastMessageAt = json['lastMessageAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    entityImage = json['entityImage'];
    chatEntityId = json['chatEntityId'];
    lastMessage = json['lastMessage'];
    entityName = json['entityName'];
    conversationId = json['conversationId'];
    isNew = json['isNew'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    if (this.companionId != null) {
      data['companionId'] = this.companionId!.toJson();
    }
    data['chatType'] = this.chatType;
    data['title'] = this.title;
    data['unreadCount'] = this.unreadCount;
    data['messageCount'] = this.messageCount;
    data['isActive'] = this.isActive;
    data['lastMessageAt'] = this.lastMessageAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['entityImage'] = this.entityImage;
    data['chatEntityId'] = this.chatEntityId;
    data['lastMessage'] = this.lastMessage;
    data['entityName'] = this.entityName;
    data['conversationId'] = this.conversationId;
    data['isNew'] = this.isNew;
    return data;
  }
}

class CompanionId {
  String? sId;
  String? name;
  String? avatar;
  String? image;

  CompanionId({this.sId, this.name, this.avatar, this.image});

  CompanionId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    avatar = json['avatar'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['image'] = this.image;
    return data;
  }
}

class Pagination {
  int? total;
  int? page;
  int? limit;

  Pagination({this.total, this.page, this.limit});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['page'] = this.page;
    data['limit'] = this.limit;
    return data;
  }
}
