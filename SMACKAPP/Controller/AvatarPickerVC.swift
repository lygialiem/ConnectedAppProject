//
//  AvatarPickerVC.swift
//  SMACKAPP
//
//  Created by Lý Gia Liêm on 4/26/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class AvatarPickerVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var AvatarCollectionView: UICollectionView!
    
    var avatartype = AvatarType.dark
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AvatarCollectionView.delegate = self
        AvatarCollectionView.dataSource = self
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCellID", for: indexPath) as? AvatarCell {
            cell.TypeAvartar(index: indexPath.item, type: avatartype)
            return cell
        }
        return AvatarCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var numberOfColums: CGFloat = 3
        if UIScreen.main.bounds.width > 320 {
            numberOfColums = 4
        }
        let spaceBetweenCells: CGFloat = 0
        let padding: CGFloat = 20
        let cellDimension = ((collectionView.bounds.width - padding) - (numberOfColums - 1) * spaceBetweenCells) / numberOfColums
        return CGSize(width: cellDimension, height: cellDimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if avatartype == .dark {
            UserDataServices.instance.setAvatarName(avatarName: "dark\(indexPath.item)")
        } else {
            UserDataServices.instance.setAvatarName(avatarName: "light\(indexPath.item)")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            avatartype = AvatarType.dark
        } else if segmentControl.selectedSegmentIndex == 1{
            avatartype = AvatarType.light
        }
        
        AvatarCollectionView.reloadData()
        
    }
    
    
    
}
