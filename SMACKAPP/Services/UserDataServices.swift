//
//  UserDataServices.swift
//  SMACKAPP
//
//  Created by Lý Gia Liêm on 4/25/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation


class UserDataServices {
    
    static let instance = UserDataServices()
    
    public private(set) var id = ""
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    
    func setUserData(id: String, color: String, avatarName: String, email: String, name: String) {
        self.id = id
        self.avatarColor = color
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    func setAvatarName(avatarName: String){
        self.avatarName = avatarName
    }
    
    
    func returnUIColor(component: String) -> UIColor {
        
        //    [0.9686274509803922, 0.7647058823529411, 0.5450980392156862, 1]"
        
        let scanner = Scanner(string: component)
        let skipped = CharacterSet(charactersIn: "[], ")
        
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped
        
        var r, g, b, a: NSString?
        
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)
        
        let defaultColor = UIColor.lightGray
        
        guard let rUnwrapped = r else {return defaultColor}
        guard let gUnwrapped = g else {return defaultColor}
        guard let bUnwrapped = b else {return defaultColor}
        guard let aUnwrapped = a else {return defaultColor}
        
        let rFloat = CGFloat(rUnwrapped.doubleValue)
        let gFloat = CGFloat(gUnwrapped.doubleValue)
        let bFloat = CGFloat(bUnwrapped.doubleValue)
        let aFloat = CGFloat(aUnwrapped.doubleValue)
        
        let newUIColor = UIColor(red: rFloat, green: gFloat, blue: bFloat, alpha: aFloat)
        
        return newUIColor
    }
    
    func LoggoutUser (){
        AuthService.instance.isLogginIn = false
        AuthService.instance.authToken = ""
        AuthService.instance.userEmail = ""
        UserDataServices.instance.avatarColor = ""
        UserDataServices.instance.avatarName = ""
        UserDataServices.instance.email = ""
        UserDataServices.instance.id = ""
        UserDataServices.instance.name = ""
        MessageServices.instance.clearMessage()
        
    }
    
    
}
