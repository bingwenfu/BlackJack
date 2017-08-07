//
//  MCPlayer.swift
//  BlackJack
//
//  Created by Bingwen Fu on 7/18/17.
//  Copyright © 2017 Bingwen Fu. All rights reserved.
//

import Cocoa
import SwiftyJSON
//import BonMot
import SwiftyAttributes

class MCPlayer: NSObject {
    
    var dm = DataManager.sharedInstance
    var mcRecord: JSON
    var counter: CardCounter
    
    override init() {
        mcRecord = dm.readJsonFromFile(fileName: "V-10m")
        counter = CardCounter()
    }
    
    func actionForGameResponse(gr: GameResponse) -> GameAction {
        let (dealerCards, playerCards, _) = gr
        let d = String(describing: dealerCards.totalValue)
        let p = String(describing: playerCards.totalValue)
        let state = d + "-" + p
        let pd = mcRecord[state]["doubleDown"]["1"].floatValue
        let ps = mcRecord[state]["stand"]["1"].floatValue
        let ph = mcRecord[state]["hit"]["1"].floatValue
        let maxp = max(pd, ps, ph)
        
        
        if gr.gameResult != .playing {
            counter.countCard(cards: dealerCards)
            counter.countCard(cards: playerCards)
        }
        updateAutoPlayLabel(pd: pd, ps: ps, ph: ph)
        
        switch maxp {
        case pd: return .doubleDown
        case ps: return .stand
        case ph: return .hit
        default: return randomAction()
        }
    }
    
    func randomAction() -> GameAction {
        let n = Int(arc4random_uniform(UInt32(100)))%3
        if n == 0 { return .stand }
        else if n == 1 { return .hit }
        else if n == 2 { return .doubleDown }
        else {
            print(#function)
            exit(0)
        }
    }
    
    func updateAutoPlayLabel(pd: Float, ps: Float, ph: Float) {
        let SnellRoundhand = NSFont(name: "Snell Roundhand", size: 32)!
        let title = "     MonteCarlo Player\n".withFont(SnellRoundhand).withTextColor(.yellow) + "\n".withFont(.systemFont(ofSize: 18))
        let pdStr = "   p(doubleDown) = " + String(pd) + "\n"
        let psStr = "   p(stand)      = " + String(ps) + "\n"
        let phStr = "   p(hit)        = " + String(ph) + "\n"

        let monaco = NSFont(name: "Monaco", size: 18)!
        var pdA = pdStr.withTextColor(.yellow).withFont(monaco)
        var psA = psStr.withTextColor(.yellow).withFont(monaco)
        var phA = phStr.withTextColor(.yellow).withFont(monaco)

        let maxp = max(pd, ps, ph)
        switch maxp {
        case pd: pdA = pdA.withBackgroundColor(.red)
        case ps: psA = psA.withBackgroundColor(.red)
        case ph: phA = phA.withBackgroundColor(.red)
        default: print("not handled...")
        }

//        let attributedString = title + pdA + psA + phA
//        NotificationCenter.default.post(name: NSNotification.Name("AutoPlayUpdated"), object: attributedString)
        
        let counterSummary = counter.counterSummary().withFont(monaco)
        NotificationCenter.default.post(name: NSNotification.Name("AutoPlayUpdated"), object: counterSummary)
    }
}





class CardCounter: NSObject {
    
    var hiLowValue = 0
    var cardMap = [Int: Int]()
    var numerOfDeck = 4
    
    override init() {
        super.init()
        resetCardMap()
    }
    
    func countCard(cards: [Card]) {
        
        // probability counter
        for c in cards {
            let key = c.value[0]
            if let value = cardMap[key] {
                cardMap[key] = value + 1
            } else {
                print("error:", key, " not found in map")
                exit(0)
            }
        }
        
        // hi-low counter
        for  c in cards {
            switch c.cardType {
            case .two, .three, .four, .five, .six:
                hiLowValue = hiLowValue + 1
            case .seven, .eight, .nine:
                hiLowValue = hiLowValue + 0
            case .ten, .jack, .queen, .king, .ace:
                hiLowValue = hiLowValue - 1
            default:
                print("encounter unknown card type: ", c.cardType)
            }
        }
    }
    
    func cardProbability() -> [Int: Float] {
        var nShown = 0
        for (_, v) in cardMap {
            nShown = nShown + v
        }
        let nLeft = (numerOfDeck * 52) - nShown
        
        var probMap = [Int: Float]()
        for i in 1...10 {
            // .ten, .jack, .queen, .king
            let base = i == 10 ? 4 : 1
            let n = numerOfDeck * 4 * base
            probMap[i] = Float(n - cardMap[i]!)/Float(nLeft)
        }
        return probMap
    }
    
    func counterSummary() -> String {
        let probMap = cardProbability()
        var result = "hi-low: " + String(hiLowValue) + "\n"
        for i in 1...10 {
            result += String(i) + " : " + String(describing: probMap[i]!) + "\n"
        }
        return result
    }
    
    func cardShuffled() {
        hiLowValue = 0
        resetCardMap()
    }
    
    func resetCardMap() {
        for i in 1...10 {
            cardMap[i] = 0
        }
    }
}



