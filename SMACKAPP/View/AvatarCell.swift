//
//  AvatarCell.swift
//  SMACKAPP
//
//  Created by Lý Gia Liêm on 4/26/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

enum AvatarType {
    case dark
    case light
}

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet var avatarimg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpView()
    }
    
    func setUpView(){
        self.layer.cornerRadius = 10
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.clipsToBounds = true
    }
    
    func TypeAvartar(index: Int, type: AvatarType){
        if type == .dark {
            avatarimg.image = UIImage.init(named: "dark\(index)")
            self.layer.backgroundColor = UIColor.lightGray.cgColor
            
        } else if type == .light {
            avatarimg.image = UIImage.init(named: "light\(index)")
            self.layer.backgroundColor = UIColor.darkGray.cgColor
            
            
        }
    }
    
}


