//
//  RoundedImage.swift
//  SMACKAPP
//
//  Created by Lý Gia Liêm on 4/26/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedImage: UIImageView {
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        
    }

}

