//
//  GameVC.swift
//  BlackJack
//
//  Created by Bingwen Fu on 4/5/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//

import Cocoa
import AVFoundation

var animationSpeedFactor = 0.9

class GameVC: NSViewController {
    
    let game = BlackJackGame()
    let audioManager = AudioManager.sharedInstance
    var playerBet = 100
    var playerBalance = 5000
    var soundMuted = false
    var isInAllin = false
    
    let cardStatrPosition = point(800, 600)
    var playerCardDeckManager: CardDeckManager?
    var dealerCardDeckManager: CardDeckManager?
    var gameStatViewController: GameStatVC?
    
    @IBOutlet weak var dealerLabel: RoundLabel!
    @IBOutlet weak var playerLabel: RoundLabel!
    @IBOutlet weak var resultLabel: RoundLabel!
    @IBOutlet weak var betLabel: NSTextField!
    @IBOutlet weak var balanceLabel: NSTextField!
    @IBOutlet weak var gameStrikeLabel: NSTextField!
    @IBOutlet weak var blackJackLabel: NSTextField!
    @IBOutlet weak var pay2To3Label: NSTextField!
    @IBOutlet weak var dealerMustStandLabel: NSTextField!
    
    @IBOutlet weak var dealButton: NSButton!
    @IBOutlet weak var bet2xButton: NSButton!
    @IBOutlet weak var doubleButton: NSButton!
    @IBOutlet weak var standButton: NSButton!
    @IBOutlet weak var hitButton: NSButton!
    @IBOutlet weak var clearBetButton: RoundButton!
    @IBOutlet weak var allInButton: RoundButton!
    
    @IBOutlet weak var chipButton1: NSButton!
    @IBOutlet weak var chipButton2: NSButton!
    @IBOutlet weak var chipButton3: NSButton!
    @IBOutlet weak var chipButton4: NSButton!
    @IBOutlet weak var chipButton5: NSButton!
    
    @IBOutlet weak var homeButton: GrayTransparentRoundButton!
    @IBOutlet weak var soundButton: GrayTransparentRoundButton!
    
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        homeButton.setCenterImageWithName("home")
        soundButton.setCenterImageWithName("sound")
    }
    
    override func viewDidAppear() {
        audioManager.playLongMp3WithName("casinoBackground")
        setHitButtonSetEnable(false)
        updateBetAndBalanceLabel()
        updateWinLoseStreakLabel()
        resultLabel.stringValue = ""
        dealerLabel.stringValue = ""
        playerLabel.stringValue = ""
        blackJackLabel.alphaValue = 0.4
        pay2To3Label.alphaValue = 0.4
        dealerMustStandLabel.alphaValue = 0.4
        addBetChipImageView()
        
        playerCardDeckManager = CardDeckManager(hostView: view, cardStatrPosition, 258, resultLabel)
        dealerCardDeckManager = CardDeckManager(hostView: view, cardStatrPosition, 443, resultLabel)
    }
    
    // MARK: IBAction Method
    // ----------------------------------------------------------------
    
    @IBAction func homeButtonClicked(sender: NSButton) {
        self.dismissController(nil)
    }
    
    @IBAction func bet2xButtonClicked(sender: AnyObject) {
        if playerBalance - playerBet >= 0 {
            playerBalance-=playerBet
            playerBet*=2
            audioManager.playShortMp3WithName("chipStack")
            updateBetAndBalanceLabel()
        }
    }
    
    @IBAction func clearBetButtonClicked(sender: AnyObject) {
        playerBalance+=playerBet
        playerBet = 0
        audioManager.playShortMp3WithName("chipStack")
        updateBetAndBalanceLabel()
        betChipImageView.image = nil
    }
    
    @IBAction func dealButtonClicked(sender: NSButton) {
        guard playerBet > 0 && playerBalance >= 0 else { return }
        setDealButtonSetEnable(false)
        self.removeAllCardsFromTable()
        resultLabel.stringValue = ""
        playerLabel.setCards([])
        dealerLabel.setCards([])
        
        let (dealerCards, playerCards, gameResult) = game.dealNewGame()
        var dealerHiddenCards = Array(dealerCards)
        dealerHiddenCards[1] = game.hiddenCard
        
        
        initialDealCards(playerCards, playerCardDeckManager, associatedLabel: playerLabel) {
            self.initialDealCards(dealerHiddenCards, self.dealerCardDeckManager, associatedLabel: self.dealerLabel) {
                self.handelGameResult(gameResult)
                if gameResult == .DealerBlackJack {
                    self.flipShowDealerHiddenCard(dealerCards)
                    self.dealerLabel.setCards(dealerCards)
                }
            }
        }
    }
    
    @IBAction func standButtonClicked(sender: AnyObject) {
        setHitButtonSetEnable(false)
        let (dealerCards, _, gameResult) = game.proceedWithAction(.Stand)
        flipShowDealerHiddenCard(dealerCards)
        dealerLabel.setCards(Array(dealerCards[0...1]))
        
        withDelay(0.7*animationSpeedFactor) {
            self.dealerCardsToEnd(self.dealerCardDeckManager, dealerCards, from: 2) {
                self.handelGameResult(gameResult)
            }
        }
    }
    
    @IBAction func chipButtonClicked(sender: NSButton) {
        let map = [chipButton1:1, chipButton2:10, chipButton3:20, chipButton4:50, chipButton5:100]
        if let n = map[sender] {
            guard playerBalance-n >= 0 else { return }
            graduallyUpdateBalanceLabelFrom(playerBalance, to: playerBalance-n)
            playerBalance -= n
            playerBet += n
            audioManager.playShortMp3WithName("chipStack")
            updateBetAndBalanceLabel()
            pushOneChipToBetPositionFromBottom("\(n)")
        }
    }
    
    @IBAction func hitButtonClicked(sender: AnyObject) {
        let (_, playerCards, gameResult) = game.proceedWithAction(.Hit)
        playerLabel.setCards(playerCards)
        playerCardDeckManager?.addCard(playerCards.last!) {
            self.handelGameResult(gameResult)
        }
    }
    
    @IBAction func muteButtonClicked(sender: AnyObject) {
        let imageName = soundMuted ? "sound" : "mute"
        soundButton.setCenterImageWithName(imageName)
        soundMuted = !soundMuted
        audioManager.setMuted(soundMuted)
    }
    
    @IBAction func statisticButtonClicked(sender: AnyObject) {
        // init statVC from storyboard if not initialized
        if gameStatViewController == nil {
            let sb = NSStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            if let vc = sb.instantiateControllerWithIdentifier("GameStatVC") as? GameStatVC {
                gameStatViewController = vc
                vc.view.alphaValue = 0.0
                vc.backgroundImageView.removeFromSuperview()
            }
        }

        // decide whether add or remove the view
        if let v = gameStatViewController?.view {
            if v.superview != nil {
                v.alphaAnimation(0, duration: 0.4) { anim, finished in
                    v.removeFromSuperview()
                }
            } else {
                v.alphaValue = 0.0
                v.frame.origin = CGPointMake(15, 175)
                self.view.addSubview(v)
                v.positionAnimation(CGRectMake(v.x, 155, v.w, v.h), duration: 0.2)
                v.alphaAnimation(0.85, duration: 0.4)
            }
        }
    }
    
    @IBAction func doubleDoneButtonClicked(sender: NSButton) {
        guard playerBalance >= playerBet else { return }
        playerBalance -= playerBet
        playerBet*=2
        updateBetAndBalanceLabel()
        let (dealerCards, playerCards, gameResult) = game.proceedWithAction(.DoubleDown)
        
        func handelGameResultAndResetBet() {
            playerBet = Int(Double(playerBet)/2.0)
            playerBalance+=playerBet
            updateBetAndBalanceLabel()
            self.handelGameResult(gameResult)
        }
        
        self.playerLabel.setCards(playerCards)
        playerCardDeckManager?.addCard(playerCards[2]) {
            // busted
            if playerCards.minValue > 21 {
                handelGameResultAndResetBet()
                return
            }
            // show hidden card and deal more if needed
            self.flipShowDealerHiddenCard(dealerCards)
            self.dealerLabel.setCards(Array(dealerCards[0...1]))
            withDelay(0.6) {
                self.dealerCardsToEnd(self.dealerCardDeckManager, dealerCards, from: 2) {
                    handelGameResultAndResetBet()
                }
            }
        }
    }
    
    @IBAction func allInButtonClicked(sender: NSButton) {
        guard playerBalance > 0 else { return }
        
        setDealButtonSetEnable(false)
        isInAllin = true
        playerBet += playerBalance
        updateBetAndBalanceLabel()
        updateBalanceLabelWithAmount(-playerBalance)
        
        audioManager.playLongMp3WithName("all_in_1")
        //playerVideo()
        
        withDelay(2.0) {
            self.dealButtonClicked(sender)
        }
    }
    
    // MARK: Stat VC Related Method
    // ----------------------------------------------------------------
    
    func updateGameStatVCContent() {
        let stat = GameStatClass(gameStat: game.gameStatistic())
        gameStatViewController?.updateLabel(stat)
    }
    
    // MARK: Video Related Method
    // ----------------------------------------------------------------
    
    func playerVideo() {
        guard let url = NSBundle.mainBundle().URLForResource("gambleGod", withExtension:"mp4") else { return }
        player = AVPlayer(URL: url)
        playerLayer = AVPlayerLayer(player: player)
        player.actionAtItemEnd = AVPlayerActionAtItemEnd.None
        playerLayer.frame = self.view.bounds
        playerLayer.backgroundColor = NSColor.blackColor().CGColor
        playerLayer.opacity = 0.0
        player.volume = 0.0
        view.layer?.addSublayer(playerLayer)
        player.play()
        
        playerLayer.alphaAnimation(1.0, duration: 2.0)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(videoEned), name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
    }
    
    func videoEned(noti: NSNotification) {
        playerLayer.alphaAnimation(0.0, duration: 0.1) { (anim, finished) in
            self.playerLayer.removeFromSuperlayer()
        }
    }
    
    // MARK: Handel Game Results
    // ----------------------------------------------------------------
    
    func handelGameResult(gameResult: GameResult) {
        switch gameResult {
        case .PlayerBlackJack:
            handlePlayerBlackJack()
        case .DealerBlackJack :
            handleDealerBlackJack()
        case .DealerBusted:
            handleDealerBusted()
        case .PlayerBusted:
            handlePlayerBusted()
        case .PlayerWin:
            handelPlayerWin()
        case .DealerWin:
            handelDealerWin()
        case .Push:
            handelPush()
        case .Playing:
            self.setHitButtonSetEnable(true)
        }
        
        if isInAllin && isPlayerWin(gameResult) {
            fullScreenChipsFallAnimation()
        }
        if isInAllin && (gameResult != .Playing) {
            isInAllin = false
            let delay = isPlayerWin(gameResult) ? 4.0 : 0.0
            withDelay(delay) {
                self.audioManager.playLongMp3WithName("casinoBackground")
            }
        }
        
        updateWinLoseStreakLabel()
        updateGameStatVCContent()
    }
    
    func handelPush() {
        resultLabel.stringValue = "Push"
        setHitButtonSetEnable(false)
        withDelay(0.1) {
            self.setDealButtonSetEnable(true)
        }
    }
    
    func handleDealerBlackJack() {
        showLoseLoseChipAnimation(-Int(Double(playerBet)*1.5))
        resultLabel.stringValue = "Dealer BlackJack"
        withDelay(0.1) {
            self.setDealButtonSetEnable(true)
        }
    }
    
    func handlePlayerBlackJack() {
        showWinChipAnimation(Int(Double(playerBet)*1.5))
        resultLabel.stringValue = "You BlackJack"
        withDelay(0.1) {
            self.setDealButtonSetEnable(true)
        }
    }
    
    func handlePlayerBusted() {
        showLoseLoseChipAnimation(-playerBet)
        setHitButtonSetEnable(false)
        resultLabel.stringValue = "Dealer Won"
        withDelay(0.1) {
            self.setDealButtonSetEnable(true)
        }
    }
    
    func handleDealerBusted() {
        showWinChipAnimation(playerBet)
        setHitButtonSetEnable(false)
        resultLabel.stringValue = "You Won"
        withDelay(0.1) {
            self.setDealButtonSetEnable(true)
        }
    }
    
    func handelPlayerWin() {
        showWinChipAnimation(playerBet)
        setHitButtonSetEnable(false)
        resultLabel.stringValue = "You Won"
        withDelay(0.1) {
            self.setDealButtonSetEnable(true)
        }
    }
    
    func handelDealerWin() {
        showLoseLoseChipAnimation(-playerBet)
        resultLabel.stringValue = "Dealer Won"
        withDelay(0.1) {
            self.setDealButtonSetEnable(true)
        }
    }
    
    // MARK: UIHelper Functions
    // ----------------------------------------------------------------
    
    var dealButtonSetEnabled = true
    func setDealButtonSetEnable(enable: Bool) {
        if dealButtonSetEnabled == enable { return }
        let views = [dealButton, bet2xButton, clearBetButton, allInButton]
        if enable { enableDealButtonSet(views) }
        else { disableDealButtonSet(views) }
        dealButtonSetEnabled = enable
    }
    
    var hitButtonSetEnabled = true
    func setHitButtonSetEnable(enable: Bool) {
        if hitButtonSetEnabled == enable { return }
        let views = [doubleButton, standButton, hitButton]
        if enable { enableDealButtonSet(views) }
        else { disableDealButtonSet(views) }
        hitButtonSetEnabled = enable
    }
    
    func enableDealButtonSet(views: [NSButton!]) {
        for v in views {
            v.alphaValue = 0.0
            v.hidden = false
            v.enabled = true
            v.alphaAnimation(1.0, duration: 0.2*animationSpeedFactor)
        }
    }
    
    func disableDealButtonSet(views: [NSButton!]) {
        for v in views {
            v.enabled = false
            v.alphaAnimation(0.0, duration: 0.2*animationSpeedFactor) { anim, finished in
                v.hidden = true
            }
        }
    }
    
    func removeAllCardsFromTable() {
        playerCardDeckManager?.removeAllCards()
        dealerCardDeckManager?.removeAllCards()
    }
    
    func updateWinLoseStreakLabel() {
        let Streak = game.gameStatistic().currentWinStreak
        if Streak > 0 {
            gameStrikeLabel.stringValue = "Current Win Streak: \(Streak)"
        } else if Streak < 0 {
            gameStrikeLabel.stringValue = "Current Lose Streak: \(-Streak)"
        } else {
            gameStrikeLabel.stringValue = ""
        }
    }
    
    // MARK: Animation Method
    // ----------------------------------------------------------------
    
    func dealerCardsToEnd(m: CardDeckManager?, _ cards: [Card], from i: Int, _ completion:(()->Void)?) {
        guard i < cards.count else { completion?(); return; }
        self.dealerLabel.setCards(Array(cards[0...i]))
        
        m?.addCard(cards[i]) {
            if i == cards.count - 1 {
                completion?()
            } else {
                self.dealerCardsToEnd(m, cards, from: i+1, completion)
            }
        }
    }
    
    func initialDealCards(c:[Card], _ m: CardDeckManager? , associatedLabel label: RoundLabel, completion:(()->Void)?) {
        label.setCards([c[0]])
        m?.addCard(c[0]) {
            label.setCards(c)
            m?.addCard(c[1]) {
                completion?()
            }
        }
    }
    
    var betChipImageView = NSImageView()
    func addBetChipImageView() {
        betChipImageView = NSImageView(frame: CGRectMake(461,120,80,80))
        betChipImageView.image = NSImage(named: "100")
        view.addSubview(betChipImageView)
    }
}


