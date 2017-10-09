//
//  Model.swift
//  Earthistic
//
//  Created by Sobura on 1/25/17.
//  Copyright © 2017 Sobura. All rights reserved.
//

class MemberModel
{
    var profileImage = ""
    var name = ""
    var Image = ""
    var sequence = 0
    var user_Token = ""
    var user_Email = ""
    static let sharedInstance = MemberModel()
}

enum UserDialogs: String {
    case SigninIncorrect        = "Your login information is incorrect."
    case EmailIsTaken           = "That email address is already taken."
    case CompleteRequireFields  = "Please complete all required fields."
    case RequireEmailAddress    = "Email address should be required."
    case PasswordRecoveryFailed = "Recovery is failed. Try again."
    case PasswordNotMatch       = "Passwords do not match"
}
