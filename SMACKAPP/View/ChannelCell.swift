//
//  ChannelCell.swift
//  SMACKAPP
//
//  Created by Lý Gia Liêm on 5/2/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    @IBOutlet var channelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        } else {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func configureCell(channel: Channel){
        let title = channel.channelTitle ?? ""
        channelName.text = title
    }

}
