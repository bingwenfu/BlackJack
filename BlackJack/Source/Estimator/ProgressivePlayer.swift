//
//  ProgressivePlayer.swift
//  BlackJack
//
//  Created by Bingwen Fu on 4/4/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//


class ProgressivePlayer: BlackJackPlayer {
    
    var initialBlance = 10000
    var baseBet = 100
    var bet = 100
    
    func actionForGame(dealerCards: [Card], _ playerCards: [Card]) -> GameAction {
        if playerCards.maxValue < 15 {
            return .Hit
        }
        return .Stand
    }
    
    func gameEndedWithResult(gameResult: GameResult) {
        if gameResult == .PlayerBusted || gameResult == .DealerBlackJack || gameResult == .DealerWin || gameResult == .Push {
            // bet = bet * 2
        } else {
            // bet = baseBet
        }
    }
}


