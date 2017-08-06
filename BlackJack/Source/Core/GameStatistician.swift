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
    var totalHandsPlayed = 0
    var dealerBustedTimes = 0
    var PlayerBustedTimes = 0
    var dealerBlackJackTimes = 0
    var playerBlackJackTimes = 0
    var dealerWinTimes = 0
    var playerWinTimes = 0
    var pushTimes = 0
    var currentStreak = 0
    var longestWinStreak = 0
    var longestLoseStreak = 0
    
    func updateStatisticsWithGameResult(_ gameResult: GameResult) {
        // game ended
        if gameResult != .playing {
            totalHandsPlayed += 1
        }
        
        // player lose
        if gameResult == .playerBusted || gameResult == .dealerBlackJack || gameResult == .dealerWin {
            dealerWinTimes+=1
            currentStreak = currentStreak<=0 ? currentStreak-1 : -1
            if gameResult == .playerBusted { PlayerBustedTimes+=1 }
            if gameResult == .dealerBlackJack { dealerBlackJackTimes+=1 }
        }
        
        // player win
        if gameResult == .dealerBusted || gameResult == .playerBlackJack || gameResult == .playerWin {
            playerWinTimes+=1
            currentStreak = currentStreak>=0 ? currentStreak+1 : 1
            if gameResult == .dealerBusted { dealerBustedTimes+=1 }
            if gameResult == .playerBlackJack { playerBlackJackTimes+=1 }
        }
        
        // push
        if gameResult == .push {
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



