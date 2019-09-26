//
//  SpeakerDetailViewController.swift
//  Mopcon
//
//  Created by EthanLin on 2018/7/3.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit

class SpeakerDetailViewController: MPBaseViewController {
    
    @IBOutlet weak var speakerView: SpeakerView!
    
    @IBOutlet weak var speakerDetailView: SpeakerDetailView!
    
    @IBOutlet weak var talkInfoView: SpeakerTalkInfoView! {
        
        didSet {
        
            talkInfoView.delegate = self
            
            talkInfoView.tagView.dataSource = self
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var speaker: Speaker?

    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let speaker = speaker {
            
            updateUI(speaker: speaker)
        }
        
        setupLayout()
    }
    
    private func setupLayout() {
        
        scrollView.addSubview(speakerView)
        
        speakerView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(speakerDetailView)
        
        speakerDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(talkInfoView)
        
        talkInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            speakerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            speakerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            speakerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            speakerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            speakerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            speakerDetailView.topAnchor.constraint(equalTo: speakerView.bottomAnchor),
            speakerDetailView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            speakerDetailView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            talkInfoView.topAnchor.constraint(equalTo: speakerDetailView.bottomAnchor),
            talkInfoView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            talkInfoView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            talkInfoView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    //MARK: Layout out
    
    func updateUI(speaker: Speaker) {
        
        speakerView.updateUI(
            image: speaker.img.mobile,
            name: speaker.name,
            job: speaker.jobTitle + "@" + speaker.company
        )

        speakerDetailView.updateUI(info: speaker.bio)

        let start = DateFormatter.string(for: speaker.startedAt, formatter: "MM/dd HH:MM") ?? ""
        
        let end = DateFormatter.string(for: speaker.startedAt, formatter: "HH:MM") ?? ""
        
        talkInfoView.updateUI(
            topic: speaker.topic,
            time: start + " - " + end,
            position: speaker.room + " " + speaker.floor,
            isCollected: false
        )
        
        talkInfoView.tagView.reloadData()
    }
    
    @IBAction func openFacebook(_ sender: UIButton) {
        
    }

    @IBAction func openGitHub(_ sender: UIButton) {
        
    }
    
    @IBAction func openTwitter(_ sender: UIButton) {
        
    }
    
    @IBAction func openWebsite(_ sender: UIButton) {
        
    }
}

extension SpeakerDetailViewController: SpeakerTalkInfoViewDelegate {
    
    func didTouchCollectedButton(_ infoView: SpeakerTalkInfoView) {
        
    }
}

extension SpeakerDetailViewController: MPTagViewDataSource {
    
    func numberOfTags(_ tagView: MPTagView) -> Int {
        
        return speaker?.tags.count ?? 0
    }
    
    func titleForTags(_ tagView: MPTagView, index: Int) -> String {
        
        return speaker?.tags[index].name ?? ""
    }
    
    func colorForTags(_ tagView: MPTagView, index: Int) -> UIColor? {
        
        return UIColor(hex: speaker?.tags[index].color ?? "")
    }
}
