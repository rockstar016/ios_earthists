//
//  Model.swift
//  Earthistic
//
//  Created by Sobura on 1/25/17.
//  Copyright © 2017 Sobura. All rights reserved.
//

class MemberModel
{
    var profileImage : String = ""
    var name : String = ""
    var Image: String = ""
    var sequence : Int = 0
    var user_Token : String = ""
    var user_Email : String = ""
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
