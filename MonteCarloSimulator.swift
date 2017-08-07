//
//  MonteCarloSimulator.swift
//  BlackJack
//
//  Created by Bingwen Fu on 7/11/17.
//  Copyright © 2017 Bingwen Fu. All rights reserved.
//

import Cocoa

class MonteCarloSimulator: NSObject {
    
    typealias GameState = (dealerCard: [Card], playerCard: [Card])
    
    let game = BlackJackGame()
    var gameRecords = [Any]()
    
    func simulate(handsNum: Int) {
        gameRecords = [Any]()
        for i in 0...handsNum {
            playOneHand()
            if i%1000 == 0 {
                print("simulation", i, "of", handsNum)
            }
        }
    }
    
    func playOneHand() {
        var eposode = [Any]()
        var response = game.dealNewGame()
        
        // initial hand, no action taken but game can end
        // for player blackjack or dealer blackjack
        if gameEnded(response.gameResult) == true {
            let state = (response.dealerCards, response.playerCards)
            let record = encoder(state: state, action:nil , response: response)
            eposode.append(record)
        }
        
        // loop until game end
        while gameEnded(response.gameResult) == false {
            let state = (response.dealerCards, response.playerCards)
            let action = policy(state: state)
            response = game.proceedWithAction(action)
            let record = encoder(state: state, action: action, response: response)
            eposode.append(record)
        }
        
        // record this round
        gameRecords.append(eposode)
    }
    
    func gameEnded(_ gameResult: GameResult) -> Bool {
        return gameResult != .playing
    }
    
    func encoder(state: GameState, action: GameAction?, response: GameResponse) -> [Any] {
        return [
            state.dealerCard.totalValue,
            state.playerCard.totalValue,
            (action != nil) ? String(describing:action!) : "nil",
            String(describing:response.gameResult)
        ]
    }
    
    func policy(state: GameState) -> GameAction {
        return randomAction()
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
    
    func writeGameRecordToDisk(fileName: String) {
        do {
            let data = try JSONSerialization.data(withJSONObject: gameRecords)
            try data.write(to: URL(fileURLWithPath: fileName))
        } catch {
            print("fail to write game record to disk")
        }
    }
}
