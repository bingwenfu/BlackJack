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
    func actionForGame(_ dealerCards: [Card], _ playerCards: [Card]) -> GameAction
    func gameEndedWithResult(_ gameResult: GameResult)
}

typealias GameHistory = (handNumber: Int, oldBalance: Int, oldBet: Int, handResult: GameResult, newBet: Int, newBalance: Int, currentStreak: Int)

class AutoPlayEngine {

    let game = BlackJackGame()
    var gameHisArr = [GameHistory]()
    
    // auto play until bet <= 0 or reach our hand goal
    func autoPlay(_ numberOfHands: Int, player: BlackJackPlayer) -> Int {
        var playerBalance = player.initialBlance
        var handResult = GameResult.playing
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
    
    func playOneHandOfBlackJack(_ player: BlackJackPlayer , _ balance: Int, bet: Int) -> (Int,GameResult) {
        var (dealerCards, playerCards, gameResult) = game.dealNewGame()
        while gameEnded(gameResult) == false {
            let playerAction = player.actionForGame(dealerCards, playerCards)
            (dealerCards, playerCards, gameResult) = game.proceedWithAction(playerAction)
        }
        player.gameEndedWithResult(gameResult)
        return (newPlayerBalanceWithGameResult(balance, bet, gameResult), gameResult)
    }
    
    func gameEnded(_ gameResult: GameResult) -> Bool {
        return gameResult != .playing
    }
    
    func newPlayerBalanceWithGameResult(_ balance: Int, _ bet: Int, _ gameResult: GameResult) -> Int {
        // player lose
        if gameResult == .playerBusted || gameResult == .dealerBlackJack || gameResult == .dealerWin {
            return balance - bet
        }
        
        // player win
        if gameResult == .dealerBusted || gameResult == .playerBlackJack || gameResult == .playerWin {
            // blackjack pay 2 to 3
            if gameResult == .playerBlackJack {
                return balance + Int(Double(bet)*1.5)
            }
            return balance + bet
        }

        // push or not ended yet
        if gameResult == .push || gameResult == .playing {
            return balance
        }
        
        print("Unhandled game result \(gameResult) in \(#function)")
        exit(0)
    }
}


//func runStratege() {
//    //multiThreadTestPlayer(ProgressivePlayer(), numOfThread: 5, iterPerThread: 20, handsLimitPerIter: 100000)
//    
//    func testPlayer(_ p: BlackJackPlayer, _ iteration: Int, _ handsLimitPerIter: Int) {
//        for _ in 0..<iteration {
//            let engine = AutoPlayEngine()
//            let player = ProgressivePlayer()
//            let endBalance = engine.autoPlay(handsLimitPerIter, player: player)
//            
//            let stat = engine.game.gameStatistic()
//            printGameStat(stat, endBalance: endBalance)
//            
//            //DataManager.sharedInstance.writeGameHisToFile(engine.gameHisArr, "/Users/Ben/Desktop/BJ/bjout\(i).txt")
//            //system("cd ~/Desktop/BJ && python polt.py \(i)")
//        }
//    }
//}

//func printGameStat(_ stat: GameStat, endBalance: Int) {
//    let dPlayerWinTimes = Double(stat.playerWinTimes)
//    let dTotalHandsPlayed = Double(stat.totalHandsPlayed)
//    let dDealerWinTimes = Double(stat.dealerWinTimes)
//    
//    let playerWinRate = String(format: "%5.2f", 100*dPlayerWinTimes/dTotalHandsPlayed)
//    let dealerWinRate = String(format: "%5.2f", 100*dDealerWinTimes/dTotalHandsPlayed)
//    let winDelta = String(format: "%7.2f", 100*(dPlayerWinTimes-dDealerWinTimes)/dTotalHandsPlayed)
//    let pushRate = String(format: "%5.2f", 100*Double(stat.pushTimes)/dTotalHandsPlayed)
//    
//    let totalHandsPlayeredStr = String(format: "%4d", stat.totalHandsPlayed)
//    let playerWinTimesStr = String(format: "%5d", stat.playerWinTimes)
//    let playerBJStr = String(format: "%4d", stat.playerBlackJackTimes)
//    
//    print("Hands Played: \(totalHandsPlayeredStr) ∆:\(winDelta)%  --  Player Win: \(playerWinTimesStr) \(playerWinRate)% -- Dealer Win \(dealerWinRate)% -- Push Rate \(pushRate)% --  Player BJ: \(playerBJStr) End Blance \(endBalance)")
//}
//
//
//func multiThreadTestPlayer(_ player: BlackJackPlayer, numOfThread: Int, iterPerThread: Int, handsLimitPerIter: Int) {
//    self.testPlayer(player, iterPerThread, handsLimitPerIter)
//    for _ in 0..<numOfThread {
//        onGlobalThread() {
//            self.testPlayer(player, iterPerThread, handsLimitPerIter)
//        }
//    }
//}
