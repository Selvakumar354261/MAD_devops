 
import 'dart:convert';
 
// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);
 
class SprintPlan {
  final String? projectId;
  final int? userId;
  final int? sprintId;
  final String? ticketNo;
  final String? estimationTime;
  final String? estimationTimeStatus;
  final String? status;
  final String? companyOutcomeStatus;
  final String? spentTime;
  final int? createdBy;
  final int? backlogId;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? isCarryForward;
  final User? user;
 
  SprintPlan({
    this.projectId,
    this.userId,
    this.sprintId,
    this.ticketNo,
    this.estimationTime,
    this.estimationTimeStatus,
    this.status,
    this.companyOutcomeStatus,
    this.spentTime,
    this.createdBy,
    this.backlogId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isCarryForward,
    this.user,
  });
 
  factory SprintPlan.fromJson(Map<String, dynamic> json) {
    return SprintPlan(
      projectId: json['project_id']?.toString(),
      userId: json['user_id'] as int?,
      sprintId: json['sprint_id'] as int?,
      ticketNo: json['ticket_no'] as String?,
      estimationTime: json['estimation_time'] as String?,
      estimationTimeStatus: json['estimationTime_status'] as String?,
      status: json['status'] as String?,
      companyOutcomeStatus: json['company_outcome_status'] as String?,
      spentTime: json['spent_time'] as String?,
      createdBy: json['created_by'] as int?,
      backlogId: json['backlog_id'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      isCarryForward: json['is_carry_forward'] as String?,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
 
  Map<String, dynamic> toJson() {
    return {
      'project_id': projectId,
      'user_id': userId,
      'sprint_id': sprintId,
      'ticket_no': ticketNo,
      'estimation_time': estimationTime,
      'estimationTime_status': estimationTimeStatus,
      'status': status,
      'company_outcome_status': companyOutcomeStatus,
      'spent_time': spentTime,
      'created_by': createdBy,
      'backlog_id': backlogId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'is_carry_forward': isCarryForward,
      'user': user?.toJson(),
    };
  }
}
 
class User {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? email;
  final String? emailVerifiedAt;
  final String? redmineUserId;
  final String? giteaUserId;
  final String? giteaApiKey;
  final String? redmineApiKey;
  final int? prohibitionPeriod;
  final String? profilePicture;
  final String? createdBy;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? passwordEnforcement;
  final String? fullName;
 
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.gender,
    this.email,
    this.emailVerifiedAt,
    this.redmineUserId,
    this.giteaUserId,
    this.giteaApiKey,
    this.redmineApiKey,
    this.prohibitionPeriod,
    this.profilePicture,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.passwordEnforcement,
    this.fullName,
  });
 
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      gender: json['gender'] as String?,
      email: json['email'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      redmineUserId: json['redmine_user_id'] as String?,
      giteaUserId: json['gitea_user_id'] as String?,
      giteaApiKey: json['Gitea_api_key'] as String?,
      redmineApiKey: json['Redmine_api_key'] as String?,
      prohibitionPeriod: json['prohibition_period'] as int?,
      profilePicture: json['profile_picture'] as String?,
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      passwordEnforcement: json['password_enforcement'] as String?,
      fullName: json['full_name'] as String?,
    );
  }
 
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'redmine_user_id': redmineUserId,
      'gitea_user_id': giteaUserId,
      'Gitea_api_key': giteaApiKey,
      'Redmine_api_key': redmineApiKey,
      'prohibition_period': prohibitionPeriod,
      'profile_picture': profilePicture,
      'created_by': createdBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'password_enforcement': passwordEnforcement,
      'full_name': fullName,
    };
  }
}
 
class Welcome {
  final List<SprintPlan> sprintPlans;
 
  Welcome({
    required this.sprintPlans,
  });
 
  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        sprintPlans: List<SprintPlan>.from(
            json["sprint_plans"].map((x) => SprintPlan.fromJson(x))),
      );
 
  Map<String, dynamic> toJson() => {
        "sprint_plans": List<dynamic>.from(sprintPlans.map((x) => x.toJson())),
      };
 
  /// Method to get sprint plans by user ID
  List<SprintPlan> getSprintPlansByUser(int userId) {
    return sprintPlans.where((plan) => plan.userId == userId).toList();
  }
}
 
//projectList
 
Welcome1 welcomeFromJson(String str) => Welcome1.fromJson(json.decode(str));
 
String welcomeToJson(Welcome1 data) => json.encode(data.toJson());
 
class Welcome1 {
  List<Project>? projects;
 
  Welcome1({
    this.projects,
  });
 
  factory Welcome1.fromJson(Map<String, dynamic> json) => Welcome1(
        projects: json["projects"] == null
            ? []
            : List<Project>.from(
                json["projects"]!.map((x) => Project.fromJson(x))),
      );
 
  Map<String, dynamic> toJson() => {
        "projects": projects == null
            ? []
            : List<dynamic>.from(projects!.map((x) => x.toJson())),
      };
}
 
class Project {
  int? id;
  String? projectName;
 
  Project({
    this.id,
    this.projectName,
  });
 
  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json["id"],
        projectName: json["project_name"],
      );
 
  Map<String, dynamic> toJson() => {
        "id": id,
        "project_name": projectName,
      };
}
 
 