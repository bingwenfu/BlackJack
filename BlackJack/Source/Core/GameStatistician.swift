//
//  GameStatistician.swift
//  BlackJack
//
//  Created by Bingwen Fu on 4/21/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//

typealias GameStat = (totalHandsPlayed: Int, dealerBustedTimes: Int, PlayerBustedTimes: Int, dealerBlackJackTimes: Int, playerBlackJackTimes: Int, dealerWinTimes: Int, playerWinTimes: Int, pushTimes: Int, currentWinStreak: Int, longestWinStreak: Int, longestLoseStreak: Int)

// class wraper to wrap GameStat tuple
class GameStatClass {
    let gameStat: GameStat
    init(gameStat: GameStat) {
        self.gameStat = gameStat
    }
}

class GameStatistician {
    
    // private var to store all stat
    private var totalHandsPlayed = 0
    private var dealerBustedTimes = 0
    private var PlayerBustedTimes = 0
    private var dealerBlackJackTimes = 0
    private var playerBlackJackTimes = 0
    private var dealerWinTimes = 0
    private var playerWinTimes = 0
    private var pushTimes = 0
    private var currentStreak = 0
    private var longestWinStreak = 0
    private var longestLoseStreak = 0
    
    func updateStatisticsWithGameResult(gameResult: GameResult) {
        // game ended
        if gameResult != .Playing {
            totalHandsPlayed += 1
        }
        
        // player lose
        if gameResult == .PlayerBusted || gameResult == .DealerBlackJack || gameResult == .DealerWin {
            dealerWinTimes+=1
            currentStreak = currentStreak<=0 ? currentStreak-1 : -1
            if gameResult == .PlayerBusted { PlayerBustedTimes+=1 }
            if gameResult == .DealerBlackJack { dealerBlackJackTimes+=1 }
        }
        
        // player win
        if gameResult == .DealerBusted || gameResult == .PlayerBlackJack || gameResult == .PlayerWin {
            playerWinTimes+=1
            currentStreak = currentStreak>=0 ? currentStreak+1 : 1
            if gameResult == .DealerBusted { dealerBustedTimes+=1 }
            if gameResult == .PlayerBlackJack { playerBlackJackTimes+=1 }
        }
        
        // push
        if gameResult == .Push {
            pushTimes+=1
        }
        
        // update longest in the history
        longestWinStreak = max(longestWinStreak, currentStreak)
        longestLoseStreak = -min(-longestLoseStreak, currentStreak)
    }
    
    // public getter for the stat
    func gameStat() -> GameStat {
        return (totalHandsPlayed, dealerBustedTimes, PlayerBustedTimes, dealerBlackJackTimes, playerBlackJackTimes, dealerWinTimes, playerWinTimes, pushTimes, currentStreak, longestWinStreak, longestLoseStreak)
    }
}



