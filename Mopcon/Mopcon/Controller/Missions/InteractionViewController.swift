//
//  InteractionViewController.swift
//  Mopcon
//
//  Created by JeremyXue on 2018/9/4.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import UIKit

enum MissionStatus {
    case notPerformed
    case hasBeenExcuted
}

class InteractionViewController: UIViewController {

    var mission: Quiz?
    var missionStatus = MissionStatus.notPerformed
    
    @IBOutlet weak var interactionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        interactionTableView.dataSource = self
        interactionTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - Tableview datasource & delegate

extension InteractionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let companyCell = tableView.dequeueReusableCell(withIdentifier: "companyCell", for: indexPath)
            if let imageView = companyCell.viewWithTag(1) as? UIImageView {
                
            }
            return companyCell
        case 1:
            let contentCell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath)
            if let titleLabel = contentCell.viewWithTag(11) as? UILabel {
                titleLabel.text = mission?.title
            }
            if let contentLabel = contentCell.viewWithTag(12) as? UILabel {
                contentLabel.text = mission?.description
            }
            
            return contentCell
        case 2:
            switch missionStatus {
            case .notPerformed:
                let submitCell = tableView.dequeueReusableCell(withIdentifier: "submitCell", for: indexPath)
                
                if let submitButton = submitCell.viewWithTag(31) as? UIButton {
                    submitButton.addTarget(self, action: #selector(checkMission), for: .touchUpInside)
                }
                
                return submitCell
            case .hasBeenExcuted:
                let successCell = tableView.dequeueReusableCell(withIdentifier: "successCell", for: indexPath)
                
                return successCell
            }
        default:
            fatalError("Can't create Tableview Cell")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 180
        case 1:
            return UITableView.automaticDimension
        case 2:
            if missionStatus == .hasBeenExcuted {
                return 190
            }
            return 150
        default:
            return 0
        }
    }
    
    @objc func checkMission() {
        performSegue(withIdentifier: "showScanner", sender: self)
    }
   
    
}
