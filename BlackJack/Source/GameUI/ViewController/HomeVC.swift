//
//  HomeVC.swift
//  BlackJack
//
//  Created by Bingwen Fu on 4/5/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//

import Cocoa

class HomeVC: NSViewController {

    @IBOutlet weak var startButton: RoundButton!
    @IBOutlet weak var mapButton: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareForButtons()
    }
    
    override func viewDidAppear() {
        AudioManager.sharedInstance.playLongMp3WithName("initialMusic")
    }
    
    func prepareForButtons() {
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        let attri = [
            NSForegroundColorAttributeName : NSColor.white,
            NSParagraphStyleAttributeName : pstyle,
            NSFontAttributeName : NSFont(name: "HelveticaNeue-Light", size: 22)!
        ]
        
        startButton.layer?.cornerRadius = startButton.h/2.0
        startButton.layer?.backgroundColor = NSColor.black.cgColor
        startButton.layer?.opacity = 0.5
        startButton.attributedTitle = NSAttributedString(string: "Start", attributes: attri)
        
        mapButton.layer?.cornerRadius = mapButton.h/2.0
        mapButton.layer?.backgroundColor = NSColor.black.cgColor
        mapButton.layer?.opacity = 0.5
        mapButton.attributedTitle = NSAttributedString(string: "Map", attributes: attri)
    }
}

