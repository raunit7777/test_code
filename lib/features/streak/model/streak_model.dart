// class StreakModel {
//   bool? success;
//   Data? data;
//   String? message;
//
//   StreakModel({this.success, this.data, this.message});
//
//   StreakModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//     message = json['message'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     data['message'] = this.message;
//     return data;
//   }
// }
//
// class Data {
//   int? currentStreak;
//   int? bestStreak;
//   bool? streakBreak;
//   String? lastActivityDate;
//   String? lastClaimedAt;
//   String? nextClaimAt;
//   int? remainingTime;
//   bool? canClaim;
//   List<Milestones>? milestones;
//
//   Data(
//       {this.currentStreak,
//         this.bestStreak,
//         this.streakBreak,
//         this.lastActivityDate,
//         this.lastClaimedAt,
//         this.nextClaimAt,
//         this.remainingTime,
//         this.canClaim,
//         this.milestones});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     currentStreak = json['currentStreak'];
//     bestStreak = json['bestStreak'];
//     streakBreak = json['streakBreak'];
//     lastActivityDate = json['lastActivityDate'];
//     lastClaimedAt = json['lastClaimedAt'];
//     nextClaimAt = json['nextClaimAt'];
//     remainingTime = json['remainingTime'];
//     canClaim = json['canClaim'];
//     if (json['milestones'] != null) {
//       milestones = <Milestones>[];
//       json['milestones'].forEach((v) {
//         milestones!.add(new Milestones.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['currentStreak'] = this.currentStreak;
//     data['bestStreak'] = this.bestStreak;
//     data['streakBreak'] = this.streakBreak;
//     data['lastActivityDate'] = this.lastActivityDate;
//     data['lastClaimedAt'] = this.lastClaimedAt;
//     data['nextClaimAt'] = this.nextClaimAt;
//     data['remainingTime'] = this.remainingTime;
//     data['canClaim'] = this.canClaim;
//     if (this.milestones != null) {
//       data['milestones'] = this.milestones!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Milestones {
//   int? day;
//   String? rewardType;
//   int? rewardValue;
//   String? characterId;
//   String? imageUrl;
//   bool? unlocked;
//   bool? claimed;
//
//   Milestones(
//       {this.day,
//         this.rewardType,
//         this.rewardValue,
//         this.characterId,
//         this.imageUrl,
//         this.unlocked,
//         this.claimed});
//
//   Milestones.fromJson(Map<String, dynamic> json) {
//     day = json['day'];
//     rewardType = json['rewardType'];
//     rewardValue = json['rewardValue'];
//     characterId = json['characterId'];
//     imageUrl = json['imageUrl'];
//     unlocked = json['unlocked'];
//     claimed = json['claimed'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['day'] = this.day;
//     data['rewardType'] = this.rewardType;
//     data['rewardValue'] = this.rewardValue;
//     data['characterId'] = this.characterId;
//     data['imageUrl'] = this.imageUrl;
//     data['unlocked'] = this.unlocked;
//     data['claimed'] = this.claimed;
//     return data;
//   }
// }


class StreakModel {
  bool? success;
  Data? data;
  String? message;

  StreakModel({this.success, this.data, this.message});

  StreakModel.fromJson(Map<String, dynamic> json) {
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
  int? currentStreak;
  int? bestStreak;
  bool? streakBreak;
  String? lastActivityDate;
  String? lastClaimedAt;
  String? nextClaimAt;
  String? streakBreaksAt;
  int? remainingTime;
  bool? canClaim;
  List<Milestones>? milestones;

  Data(
      {this.currentStreak,
        this.bestStreak,
        this.streakBreak,
        this.lastActivityDate,
        this.lastClaimedAt,
        this.nextClaimAt,
        this.streakBreaksAt,
        this.remainingTime,
        this.canClaim,
        this.milestones});

  Data.fromJson(Map<String, dynamic> json) {
    currentStreak = json['currentStreak'];
    bestStreak = json['bestStreak'];
    streakBreak = json['streakBreak'];
    lastActivityDate = json['lastActivityDate'];
    lastClaimedAt = json['lastClaimedAt'];
    nextClaimAt = json['nextClaimAt'];
    streakBreaksAt = json['streakBreaksAt'];
    remainingTime = json['remainingTime'];
    canClaim = json['canClaim'];
    if (json['milestones'] != null) {
      milestones = <Milestones>[];
      json['milestones'].forEach((v) {
        milestones!.add(new Milestones.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentStreak'] = this.currentStreak;
    data['bestStreak'] = this.bestStreak;
    data['streakBreak'] = this.streakBreak;
    data['lastActivityDate'] = this.lastActivityDate;
    data['lastClaimedAt'] = this.lastClaimedAt;
    data['nextClaimAt'] = this.nextClaimAt;
    data['streakBreaksAt'] = this.streakBreaksAt;
    data['remainingTime'] = this.remainingTime;
    data['canClaim'] = this.canClaim;
    if (this.milestones != null) {
      data['milestones'] = this.milestones!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Milestones {
  String? sId;
  int? day;
  String? rewardType;
  int? rewardValue;
  String? characterId;
  String? imageUrl;
  bool? unlocked;
  bool? claimed;

  Milestones(
      {this.sId,
        this.day,
        this.rewardType,
        this.rewardValue,
        this.characterId,
        this.imageUrl,
        this.unlocked,
        this.claimed});

  Milestones.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    day = json['day'];
    rewardType = json['rewardType'];
    rewardValue = json['rewardValue'];
    characterId = json['characterId'];
    imageUrl = json['imageUrl'];
    unlocked = json['unlocked'];
    claimed = json['claimed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['day'] = this.day;
    data['rewardType'] = this.rewardType;
    data['rewardValue'] = this.rewardValue;
    data['characterId'] = this.characterId;
    data['imageUrl'] = this.imageUrl;
    data['unlocked'] = this.unlocked;
    data['claimed'] = this.claimed;
    return data;
  }
}
