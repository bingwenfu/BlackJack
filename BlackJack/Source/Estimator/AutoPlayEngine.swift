//
//  AutoPlayEngine.swift
//  BlackJack
//
//  Created by Bingwen Fu on 4/23/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//

protocol BlackJackPlayer {
    var initialBlance: Int {get}
    var bet: Int {get}
    func actionForGame(dealerCards: [Card], _ playerCards: [Card]) -> GameAction
    func gameEndedWithResult(gameResult: GameResult)
}

typealias GameHistory = (handNumber: Int, oldBalance: Int, oldBet: Int, handResult: GameResult, newBet: Int, newBalance: Int, currentStreak: Int)

class AutoPlayEngine {

    let game = BlackJackGame()
    var gameHisArr = [GameHistory]()
    
    // auto play until bet <= 0 or reach our hand goal
    func autoPlay(numberOfHands: Int, player: BlackJackPlayer) -> Int {
        var playerBalance = player.initialBlance
        var handResult = GameResult.Playing
        // play until player has no balance or reaches total hand goal
        while game.gameStatistic().totalHandsPlayed < numberOfHands && playerBalance-player.bet >= 0 {
            let (oldBalance, oldBet) = (playerBalance, player.bet)
            // play the game, the most important tihng of the while loop
            (playerBalance, handResult) = playOneHandOfBlackJack(player, playerBalance, bet: player.bet)
            // record the history
            let gameHis = (game.gameStatistic().totalHandsPlayed, oldBalance, oldBet, handResult, player.bet, playerBalance, game.gameStatistic().currentWinStreak)
            gameHisArr.append(gameHis)
        }
        return playerBalance
    }
    
    func playOneHandOfBlackJack(player: BlackJackPlayer , _ balance: Int, bet: Int) -> (Int,GameResult) {
        var (dealerCards, playerCards, gameResult) = game.dealNewGame()
        while gameEnded(gameResult) == false {
            let playerAction = player.actionForGame(dealerCards, playerCards)
            (dealerCards, playerCards, gameResult) = game.proceedWithAction(playerAction)
        }
        player.gameEndedWithResult(gameResult)
        return (newPlayerBalanceWithGameResult(balance, bet, gameResult), gameResult)
    }
    
    func gameEnded(gameResult: GameResult) -> Bool {
        return gameResult != .Playing
    }
    
    func newPlayerBalanceWithGameResult(balance: Int, _ bet: Int, _ gameResult: GameResult) -> Int {
        // player lose
        if gameResult == .PlayerBusted || gameResult == .DealerBlackJack || gameResult == .DealerWin {
            return balance - bet
        }
        
        // player win
        if gameResult == .DealerBusted || gameResult == .PlayerBlackJack || gameResult == .PlayerWin {
            // blackjack pay 2 to 3
            if gameResult == .PlayerBlackJack {
                return balance + Int(Double(bet)*1.5)
            }
            return balance + bet
        }

        // push or not ended yet
        if gameResult == .Push || gameResult == .Playing {
            return balance
        }
        
        print("Unhandled game result \(gameResult) in \(#function)")
        exit(0)
    }
}