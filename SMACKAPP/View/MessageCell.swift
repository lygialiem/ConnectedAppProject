//
//  MessageCell.swift
//  SMACKAPP
//
//  Created by Lý Gia Liêm on 5/6/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet var userImg: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var timeStampLabel: UILabel!
    @IBOutlet var messageBodyLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
    func configureCell(message: Message){
        messageBodyLabel.text = message.message
        userNameLabel.text = message.userName
        userImg.image = UIImage(named: message.userAvatar)
        userImg.backgroundColor = UserDataServices.instance.returnUIColor(component: message.userAvatarColor)
    }
}
