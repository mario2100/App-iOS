//
//  CustomCornerButton.swift
//  Mopcon
//
//  Created by EthanLin on 2018/7/2.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit
class CustomCornerButton: UIButton{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.secondThemeColor?.cgColor
        self.titleLabel?.textColor = UIColor.secondThemeColor
    }
}
