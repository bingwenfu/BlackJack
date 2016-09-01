//
//  GameStatVC.swift
//  BlackJack
//
//  Created by Bingwen Fu on 4/21/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//

import Foundation
import Cocoa

class GameStatVC: NSViewController {
    
    @IBOutlet weak var totalHandsPlayedLabel : NSTextField!
    @IBOutlet weak var dealerBustedTimesLabel : NSTextField!
    @IBOutlet weak var PlayerBustedTimesLabel : NSTextField!
    @IBOutlet weak var dealerBlackJackTimesLabel : NSTextField!
    @IBOutlet weak var playerBlackJackTimesLabel : NSTextField!
    @IBOutlet weak var dealerWinTimesLabel : NSTextField!
    @IBOutlet weak var playerWinTimesLabel : NSTextField!
    @IBOutlet weak var pushTimesLabel : NSTextField!
    @IBOutlet weak var longestWinStrikeLabel : NSTextField!
    @IBOutlet weak var longestLoseStrikeLabel : NSTextField!
    @IBOutlet weak var backgroundImageView: NSImageView!
    
    override func viewDidLoad() {
        // nothing
    }
    
    func updateLabel(gameStatClass: GameStatClass) {
        let stat = gameStatClass.gameStat
        dealerBlackJackTimesLabel.stringValue = "\(stat.dealerBlackJackTimes)"
        playerBlackJackTimesLabel.stringValue = "\(stat.playerBlackJackTimes)"
        dealerBustedTimesLabel.stringValue = "\(stat.dealerBustedTimes)"
        totalHandsPlayedLabel.stringValue  = "\(stat.totalHandsPlayed)"
        PlayerBustedTimesLabel.stringValue = "\(stat.PlayerBustedTimes)"
        longestLoseStrikeLabel.stringValue = "\(stat.longestLoseStreak)"
        longestWinStrikeLabel.stringValue = "\(stat.longestWinStreak)"
        pushTimesLabel.stringValue = "\(stat.pushTimes)"
        
        guard stat.totalHandsPlayed != 0 else { return }
        dealerWinTimesLabel.stringValue = "\(stat.dealerWinTimes)  / \(100*stat.dealerWinTimes/stat.totalHandsPlayed)%"
        playerWinTimesLabel.stringValue = "\(stat.playerWinTimes)  / \(100*stat.playerWinTimes/stat.totalHandsPlayed)%"
    }

}