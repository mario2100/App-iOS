//
//  BannerCollectionViewCell.swift
//  Mopcon
//
//  Created by EthanLin on 2018/7/1.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var bannerImageCollectionView: UICollectionView!
    
     let bannerData = ["s6","s2"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellKeyManager.bannerImageCell, for: indexPath) as! BannerImageCell
        cell.updateUI()
        cell.bannerImageView.image = UIImage(named: bannerData[indexPath.item])
        return cell
    }
   
    
}

