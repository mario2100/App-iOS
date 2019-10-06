//
//  ConferenceDetailViewController.swift
//  Mopcon
//
//  Created by EthanLin on 2018/7/7.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit

enum ConferenceType {
    
    case unconf(Int)
    
    case session(Int)
}

class ConferenceDetailViewController: MPBaseViewController {
    
    var conferenceType: ConferenceType? {
        
        didSet {
            
            switch conferenceType {
            
            case .session(let id): fetchSessionInfo(id: id)
                
            case .unconf(let id): fetchUnconfInfo(id: id)
                
            default: scrollView.isHidden = true
        
            }
        }
    }
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var topicLabel: UILabel!
    
    @IBOutlet weak var speakerImageView: UIImageView!
    
    @IBOutlet weak var speakerName: UILabel!
    
    @IBOutlet weak var speakerJob: UILabel!
    
    @IBOutlet weak var scheduleInfoLabel: UILabel!
    
    @IBOutlet weak var addToMyScheduleButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var sponsorTitleLabel: UILabel!
    
    @IBOutlet weak var sponsorImageView: UIImageView!
    
    @IBOutlet weak var sponsorLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var tags: [Tag] = [] {
        
        didSet {
        
            tagView.reloadData()
        }
    }
    
    @IBOutlet weak var tagView: MPTagView! {
        
        didSet {
        
            tagView.dataSource = self
        }
    }
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        speakerImageView.makeCircle()

        sponsorImageView.makeCircle()
    }
    
    @IBAction func didTouchedLikedBtn(_ sender: UIBarButtonItem) {
        
        if sender.image == UIImage.asset(.like_24) {
            
            switch conferenceType {
                
            case .session(let id): FavoriteManager.shared.removeSessionId(id: id)
                
            case .unconf(let id): FavoriteManager.shared.removeUnconfId(id: id)
            
            default: break
                
            }
            
            sender.image = UIImage.asset(.dislike_24)
            
        } else {
            
            switch conferenceType {
                
            case .session(let id): FavoriteManager.shared.addSessionId(id: id)
                
            case .unconf(let id): FavoriteManager.shared.addUnconfId(id: id)
            
            default: break
                
            }
            
            sender.image = UIImage.asset(.like_24)
        }
    }
    
    //MARK: - API
    private func fetchUnconfInfo(id: Int) {
        
        UnconfProvider.fetchUnConfInfo(id: id, completion: { [weak self] result in
            
            switch result {
                
            case .success(let info):
                
                self?.throwToMainThreadAsync {
                    
                    self?.updateUI(room: info)
                    
                    self?.scrollView.isHidden = false
                    
                    if FavoriteManager.shared.fetchUnconfIds().contains(id) {
                        
                        self?.addToMyScheduleButtonItem.image = UIImage.asset(.like_24)
                        
                    } else {
                        
                        self?.addToMyScheduleButtonItem.image = UIImage.asset(.dislike_24)
                    }
                }
                
            case .failure(let error):
                
                print(error)
            }
        })
    }
    
    private func fetchSessionInfo(id: Int) {
        
        SessionProvider.fetchSession(id: id, completion: { [weak self] result in
            
            switch result {
                
            case .success(let room):
                
                self?.throwToMainThreadAsync {
                    
                    self?.updateUI(room: room)
                    
                    self?.scrollView.isHidden = false
                    
                    if FavoriteManager.shared.fetchSessionIds().contains(id) {
                        
                        self?.addToMyScheduleButtonItem.image = UIImage.asset(.like_24)
                        
                    } else {
                        
                        self?.addToMyScheduleButtonItem.image = UIImage.asset(.dislike_24)
                    }
                }
                
            case .failure(let error):
                
                print(error)
            }
        })
    }
    
    // MARK: - Layout View
    func updateUI(room: Room) {
        
        if let sponsor = room.sponsorInfo {
        
            sponsorImageView.isHidden = false
            
            sponsorTitleLabel.isHidden = false
            
            sponsorLabel.isHidden = false
            
            sponsorImageView.kf.setImage(with: URL(string: sponsor.logo))
            
            switch CurrentLanguage.getLanguage() {
                
            case Language.chinese.rawValue:
            
                sponsorLabel.text = sponsor.name
                
            case Language.english.rawValue:
            
                sponsorLabel.text = sponsor.nameEn
                
            default: break
                
            }
            
        } else {
            
            sponsorImageView.isHidden = true
            
            sponsorTitleLabel.isHidden = true
            
            sponsorLabel.isHidden = true
        }

        speakerImageView.kf.setImage(
            with: URL(string: room.speakers.first!.img.mobile),
            placeholder: UIImage.asset(.fieldGameProfile)
        )
        
        tags = room.tags

        let language = CurrentLanguage.getLanguage()

        switch language {

        case Language.chinese.rawValue:

            scheduleInfoLabel.text = room.summary

            typeLabel.text = room.tags.map({ $0.name }).joined(separator: " & ")
            
            topicLabel.text = room.topic

            speakerName.text = room.speakers.first?.name

            let job = "\(room.speakers.first?.jobTitle ?? "")@\(room.speakers.first?.company ?? "")"

            speakerJob.text = (job == "@") ? "" : job

        case Language.english.rawValue:

            scheduleInfoLabel.text = room.summaryEn

            typeLabel.text = room.tags.reduce("", { $0 + $1.name + " "})

            topicLabel.text = room.topicEn

            speakerName.text = room.speakers.first?.name

            let job = "\(room.speakers.first?.jobTitleEn ?? "")@\(room.speakers.first?.companyEn ?? "")"

            speakerJob.text = (job == "@") ? "" : job

        default:

            break
        }
    }
}

extension ConferenceDetailViewController: MPTagViewDataSource {
    
    func numberOfTags(_ tagView: MPTagView) -> Int {
        
        return tags.count
    }
    
    func titleForTags(_ tagView: MPTagView, index: Int) -> String {
        
        return tags[index].name
    }
    
    func colorForTags(_ tagView: MPTagView, index: Int) -> UIColor? {
        
        return UIColor(hex: tags[index].color)
    }
}
