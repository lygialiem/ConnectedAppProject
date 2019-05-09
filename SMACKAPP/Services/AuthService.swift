//
//  AuthService.swift
//  SMACKAPP
//
//  Created by Lý Gia Liêm on 4/24/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

class AuthService {
    static let instance = AuthService()
    
    var defaults = UserDefaults.standard
    
    var isLogginIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    var authToken: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String         //value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.string(forKey: USER_EMAIL)!
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    
 
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler){
        
        let lowerCaseEmail = email.lowercased()
        
        let header = [
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]

        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseString { (response) in
            if response.result.error == nil {
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
             
            }
        }
    }
    
    
  
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler){
        let lowerCaseEmail = email.lowercased()
        let header = [
                "Content-Type": "application/json; charset=utf-8"
            ]
        let body: [String: Any] = [
                "email": lowerCaseEmail,
                "password": password
            ]
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default , headers: header).responseJSON { (response) in
                
            if response.result.error == nil {
                guard let data = response.data else {return}
                do {
                    let json = try JSON(data: data)
                    self.userEmail = json["user"].stringValue
                    self.authToken = json["token"].stringValue
                    self.isLogginIn = true
                    completion(true)}
                    catch {return}
            } else {
                completion(false)
                debugPrint("Lỗi LoginVC/loginUser:  \(response.result.error as Any)")
                
               
                }
            }
        }
    
    func AddUser(name: String, email: String, avatarName: String, avatarColor: String, completion:  @escaping CompletionHandler){
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "name": name,
            "email": lowerCaseEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]
 
        Alamofire.request("http://smacksmackchatapp.herokuapp.com/v1/user/add", method: .post, parameters: body, encoding: JSONEncoding.default, headers: header_header).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                self.setUserData(data: data)
                completion(true)
            }else {
                completion(false)
                debugPrint(response.result.error as Any)
                
            }
        }
    }
    
    // hàm findUserByEmail để dùng cho LoginVC, khi User đăng nhập, nó sẽ lấy data từ API về gồm các đặc tính của user.
    func findUserByEmail(completion: @escaping CompletionHandler){
        Alamofire.request("\(URL_USER_BY_EMAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header_header).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                self.setUserData(data: data)
                completion(true)
            } else {
                completion(false)
                debugPrint("Lỗi hàm FindUserEmail: \(response.result.error as Any)")
            }
        }
    }
    
    func setUserData(data: Data){
        do {
            let json = try JSON(data: data)
            let id = json["_id"].stringValue
            let color = json["avatarColor"].stringValue
            let avatarName = json["avatarName"].stringValue
            let name = json["name"].stringValue
            let email = json["email"].stringValue
            
            UserDataServices.instance.setUserData(id: id, color: color, avatarName: avatarName, email: email, name: name)
        }
        catch {
            print("LỖI HÀM")
        }
    }
    
    
}



