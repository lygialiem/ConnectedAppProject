//
//  Constants.swift
//  SMACKAPP
//
//  Created by Lý Gia Liêm on 4/24/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

let BASE_URL: String = "https://smacksmackchatapp.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_USER_BY_EMAIL = "\(BASE_URL)user/byEmail/"
let URL_GET_MESSAGE = "\(BASE_URL)message/byChannel/"


let TOKEN_KEY: String = "token"
let LOGGED_IN_KEY: String = "loggedIn"
let USER_EMAIL: String = "userEmail"

let purpleColorForTextfield: UIColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChangedfromCreateAccountVC")
let NOTIF_CHANNEL_SELECTED = Notification.Name("Did Select Channel and Notify to ChatVC")
let NOTIF_PROFILE_USER = Notification.Name("Profile User Selected")

let header_header = [
    "Authorization": "Bearer \(AuthService.instance.authToken)",
    "Content-Type": "application/json; charset=utf-8"
]
