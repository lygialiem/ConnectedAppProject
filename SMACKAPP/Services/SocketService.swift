//
//  SocketService.swift
//  SMACKAPP
//
//  Created by Lý Gia Liêm on 5/3/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    
    static let instance = SocketService()
    
    override init() {
        super.init()
        
    }
    
    let manager = SocketManager(socketURL: URL(string: BASE_URL)!)
    lazy var socket = manager.defaultSocket
    
    
    func establishConnection(){
        socket.connect()
    }
    
    
    func closeConnection(){
        socket.disconnect()
    }
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler){
        socket.emit("newChannel", channelName, channelDescription )
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler){
        socket.on("channelCreated", callback:  { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else {return}
            guard let channelDesc = dataArray[1] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            
            let newChannel  = Channel(id: channelId, channelTitle: channelName, channelDescription: channelDesc)
            MessageServices.instance.channels.append(newChannel)
            completion(true)
        })
    }
    
    func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler){
        let user = UserDataServices.instance
        socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
    
    func getChatMessage(completion: @escaping CompletionHandler){
        socket.on("messageCreated") { (dataArray, ack) in
            guard let msgBody = dataArray[0] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            guard let userName = dataArray[3] as? String else {return}
            guard let userAvatar = dataArray[4] as? String else {return}
            guard let userAvatarColor = dataArray[5] as? String else {return}
            guard let id = dataArray[6] as? String else {return}
            guard let timeStamp = dataArray[7 ] as? String else {return}
            
            if channelId == MessageServices.instance.selectedChannel?.id && AuthService.instance.isLogginIn {
                let newMessage = Message(message: msgBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                
                MessageServices.instance.messages.append(newMessage)
                completion(true)
            } else {
                completion(false)
            }
            
            
        }
    }
    
    func getTypingUser(_ completionHandler: @escaping (_ typingUser: [String: String]) -> Void){
        socket.on("userTypingUpdate") { (dataArray, ack) in
            guard let typingUsers = dataArray[0] as? [String : String] else { return }
            completionHandler(typingUsers)
   
        }
    }
}

