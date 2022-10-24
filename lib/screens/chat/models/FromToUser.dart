class FromToUser {
    FromToUser({
        this.id,
        this.fullName,
        this.username,
        this.email,
        this.usertype,
        this.activeStatus,
        this.randomCode,
        this.notificationToken,
        this.createdAt,
        this.updatedAt,
        this.language,
        this.styleId,
        this.rtlLtl,
        this.selectedSession,
        this.createdBy,
        this.updatedBy,
        this.accessStatus,
        this.schoolId,
        this.roleId,
        this.isAdministrator,
        this.isRegistered,
        this.deviceToken,
        this.stripeId,
        this.cardBrand,
        this.cardLastFour,
        this.verified,
        this.trialEndsAt,
        this.zoomApiKeyOfUser,
        this.zoomApiSerectOfUser,
        this.walletBalance,
        this.firstName,
        this.avatarUrl,
        this.blockedByMe,
    });

    dynamic id;
    String fullName;
    String username;
    String email;
    dynamic usertype;
    dynamic activeStatus;
    dynamic randomCode;
    dynamic notificationToken;
    DateTime createdAt;
    DateTime updatedAt;
    String language;
    dynamic styleId;
    dynamic rtlLtl;
    dynamic selectedSession;
    dynamic createdBy;
    dynamic updatedBy;
    dynamic accessStatus;
    dynamic schoolId;
    dynamic roleId;
    String isAdministrator;
    dynamic isRegistered;
    String deviceToken;
    dynamic stripeId;
    dynamic cardBrand;
    dynamic cardLastFour;
    dynamic verified;
    dynamic trialEndsAt;
    dynamic zoomApiKeyOfUser;
    dynamic zoomApiSerectOfUser;
    dynamic walletBalance;
    String firstName;
    String avatarUrl;
    bool blockedByMe;

    factory FromToUser.fromJson(Map<String, dynamic> json) => FromToUser(
        id: json["id"],
        fullName: json["full_name"],
        username: json["username"],
        email: json["email"],
        usertype: json["usertype"],
        activeStatus: json["active_status"],
        randomCode: json["random_code"],
        notificationToken: json["notificationToken"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        language: json["language"],
        styleId: json["style_id"],
        rtlLtl: json["rtl_ltl"],
        selectedSession: json["selected_session"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        accessStatus: json["access_status"],
        schoolId: json["school_id"],
        roleId: json["role_id"],
        isAdministrator: json["is_administrator"],
        isRegistered: json["is_registered"],
        deviceToken: json["device_token"],
        stripeId: json["stripe_id"],
        cardBrand: json["card_brand"],
        cardLastFour: json["card_last_four"],
        verified: json["verified"],
        trialEndsAt: json["trial_ends_at"],
        zoomApiKeyOfUser: json["zoom_api_key_of_user"],
        zoomApiSerectOfUser: json["zoom_api_serect_of_user"],
        walletBalance: json["wallet_balance"],
        firstName: json["first_name"],
        avatarUrl: json["avatar_url"],
        blockedByMe: json["blocked_by_me"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "username": username,
        "email": email,
        "usertype": usertype,
        "active_status": activeStatus,
        "random_code": randomCode,
        "notificationToken": notificationToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "language": language,
        "style_id": styleId,
        "rtl_ltl": rtlLtl,
        "selected_session": selectedSession,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "access_status": accessStatus,
        "school_id": schoolId,
        "role_id": roleId,
        "is_administrator": isAdministrator,
        "is_registered": isRegistered,
        "device_token": deviceToken,
        "stripe_id": stripeId,
        "card_brand": cardBrand,
        "card_last_four": cardLastFour,
        "verified": verified,
        "trial_ends_at": trialEndsAt,
        "zoom_api_key_of_user": zoomApiKeyOfUser,
        "zoom_api_serect_of_user": zoomApiSerectOfUser,
        "wallet_balance": walletBalance,
        "first_name": firstName,
        "avatar_url": avatarUrl,
        "blocked_by_me": blockedByMe,
    };
}

