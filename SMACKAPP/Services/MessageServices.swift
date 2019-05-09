//
//  File.swift
//  SMACKAPP
//
//  Created by Lý Gia Liêm on 5/2/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageServices {
    static let instance = MessageServices()
    
    var channels = [Channel]()
    var selectedChannel: Channel?
    var messages = [Message]()
    
    var profileUser: Message?
    
    func findAllChannel(completion: @escaping CompletionHandler){
        
        Alamofire.request("http://smacksmackchatapp.herokuapp.com/v1/channel", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header_header).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else {return}
                do {
                    let json = try JSON(data: data).array
                    for item in json! {
                        let name = item["name"].stringValue
                        let id = item["_id"].stringValue
                        let description = item["description"].stringValue
                        let channel = Channel(id: id, channelTitle: name, channelDescription: description)
                        self.channels.append(channel)
                    }
                    completion(true)
                    
                } catch {
                    return
                }
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
                print("findAllChannel lỗi")
            }
        }
    }
    
    func findAllMessageForChannel(channelId: String, completion: @escaping CompletionHandler){
        Alamofire.request("\(URL_GET_MESSAGE)\(channelId)", method: .get
            ,parameters: nil, encoding: JSONEncoding.default, headers: header_header).responseJSON { (response) in
                
                if response.result.error == nil {
                    
                    guard let data = response.data else {
                        print("Không nhận được data từ FindAllMesageForChannel")
                        return
                    }
                    
                    do{
                        if let json = try JSON(data: data).array {
                            for item in json {
                                let messageBody = item["messageBody"].stringValue
                                let id = item["_id"].stringValue
                                let userAvatarColor = item["userAvatarColor"].stringValue
                                let channelId = item["channelId"].stringValue
                                let userName = item["userName"].stringValue
                                let userAvatar = item["userAvatar"].stringValue
                                let timeStamp = item["timeStamp"].stringValue
                                let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp:  timeStamp)
                                self.messages.append(message)
                            }
                            
                        }
                    } catch {return }

                    completion(true)
                    
                } else {
                    completion(false)
                    debugPrint(response.result.error as Any)
                    print("Lỗi MessageServices/finAllMessageForChannel")
                    
                }
        }
    }
    
    func removeChannel() {
        channels.removeAll()
    }
    
    func clearMessage(){
        messages.removeAll()
    }
    
    func messageRevert(messagearray: [Message]) -> [Message]{
        return messagearray.reversed()
    }
}
