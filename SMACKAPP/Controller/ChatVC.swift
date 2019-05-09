//
//  ChatVC.swift
//  SMACKAPP
//
//  Created by Lý Gia Liêm on 4/22/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import SocketIO

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var menuBtn: UIButton!
    @IBOutlet var textfieldTextBox: UITextField!
    @IBOutlet var channelNameLabel: UILabel!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var tableViewChatVC: UITableView!
    @IBOutlet var typingUserLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.typingUserLabel.isHidden = true
        sendButton.isHidden = true
        
        tableViewChatVC.delegate = self
        tableViewChatVC.dataSource = self
        self.tableViewChatVC.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        view.bindToKeyboard()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        if AuthService.instance.isLogginIn {
            AuthService.instance.findUserByEmail { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            }
        } else {
            self.channelNameLabel.text = "Please Log In"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.UserDataDidChange), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        
        
        SocketService.instance.getChatMessage { (success) in
            if success {
                self.tableViewChatVC.reloadData()
                
            }
        }
        
        SocketService.instance.getTypingUser { (typingUsers) in
            guard let channelId = MessageServices.instance.selectedChannel?.id else { return }
            var names = ""
            var numberOfTyper = 0
            
            for (userName, channel) in typingUsers {
                if userName != UserDataServices.instance.name && channel == channelId {
                    if names == "" {
                        names = userName
                    } else {
                        names = "\(names), \(userName)"
                    }
                    numberOfTyper += 1
                }
            }
            
            if numberOfTyper > 0 && AuthService.instance.isLogginIn == true {
                var verb  = "is"
                if numberOfTyper > 1 {
                    verb = "are"
                }
                self.typingUserLabel.isHidden = false
                self.typingUserLabel.text = "\(names) \(verb) typing messages"
            } else {
                self.typingUserLabel.text = ""
                self.typingUserLabel.isHidden = true
            }
        }
    }
    
    @objc func UserDataDidChange(){
        if AuthService.instance.isLogginIn {
            channelNameLabel.text = MessageServices.instance.selectedChannel?.channelTitle
            onLoginGetMessage()
        } else {
            channelNameLabel.text = "Please LogIn"
            self.tableViewChatVC.reloadData()
        }
        
    }
    
    @objc func channelSelected(){
        self.channelNameLabel.text = MessageServices.instance.selectedChannel!.channelTitle
        getMessage()
    }
    
    func onLoginGetMessage(){
        MessageServices.instance.findAllChannel { (success) in
            if success {
                if MessageServices.instance.channels.count > 0 {
                    MessageServices.instance.selectedChannel = MessageServices.instance.channels[0]
                    self.channelNameLabel.text = MessageServices.instance.selectedChannel?.channelTitle
                    self.getMessage()
                } else {
                    self.channelNameLabel.text = "No Channel"
                }
            }
        }
    }
    
    func getMessage (){
        MessageServices.instance.messages = []
        guard let channelId = MessageServices.instance.selectedChannel?.id else {return}
        MessageServices.instance.findAllMessageForChannel(channelId: channelId) { (success) in
            if success {
                self.tableViewChatVC.reloadData()
            }
        }
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if AuthService.instance.isLogginIn {
            guard let channelId = MessageServices.instance.selectedChannel?.id else {return}
            guard let message = textfieldTextBox.text else {return}
            SocketService.instance.addMessage(messageBody: message, userId: UserDataServices.instance.id, channelId: channelId) { (success) in
                if success {
                    self.textfieldTextBox.text = ""
                    self.textfieldTextBox.resignFirstResponder()
                    self.sendButton.isHidden = true
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageServices.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableViewChatVC.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageCell {
            var messageRevert = MessageServices.instance.messageRevert(messagearray: MessageServices.instance.messages)
            let message = messageRevert[indexPath.row]
            cell.configureCell(message: message)
            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    @IBAction func sideMenuPressed(_ sender: Any) {
    }
    
    
    @IBAction func messageBoxEditing(_ sender: Any) {
        guard let channelId = MessageServices.instance.selectedChannel?.id else { return }
        if textfieldTextBox.text == "" {
            sendButton.isHidden = true
            SocketService.instance.socket.emit("stopType", UserDataServices.instance.name, channelId)
        } else {
            sendButton.isHidden = false
            SocketService.instance.socket.emit("startType", UserDataServices.instance.name, channelId)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messagerevert = MessageServices.instance.messageRevert(messagearray: MessageServices.instance.messages)
        let profile = messagerevert[indexPath.row]
        MessageServices.instance.profileUser = profile
        performSegue(withIdentifier: "profileselected", sender: nil )
        
    }
    
    
    @IBAction func button(_ sender: Any) {
        performSegue(withIdentifier: "profileselected", sender: nil)
    }
    
}
