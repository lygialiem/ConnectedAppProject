//
//  ChannelVC.swift
//  SMACKAPP
//
//  Created by Lý Gia Liêm on 4/22/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    @IBOutlet var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 60
    }
    
    
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "loginVC", sender: nil)
        
        
    }
    
    
    //Back Button From...
    @IBAction func BackfromLoginVC(unwind: UIStoryboardSegue){}
}
