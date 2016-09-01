//
//  AppDelegate.swift
//  BlackJack
//
//  Created by Bingwen Fu on 4/5/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        //multiThreadTestPlayer(ProgressivePlayer(), numOfThread: 5, iterPerThread: 20, handsLimitPerIter: 100000)
    }
    
    func multiThreadTestPlayer(player: BlackJackPlayer, numOfThread: Int, iterPerThread: Int, handsLimitPerIter: Int) {
        self.testPlayer(player, iterPerThread, handsLimitPerIter)
        for _ in 0..<numOfThread {
            onGlobalThread() {
                self.testPlayer(player, iterPerThread, handsLimitPerIter)
            }
        }
    }
    
    func testPlayer(p: BlackJackPlayer, _ iteration: Int, _ handsLimitPerIter: Int) {
        for _ in 0..<iteration {
            let engine = AutoPlayEngine()
            let player = ProgressivePlayer()
            let endBalance = engine.autoPlay(handsLimitPerIter, player: player)
            
            let stat = engine.game.gameStatistic()
            printGameStat(stat, endBalance: endBalance)
            
            //DataManager.sharedInstance.writeGameHisToFile(engine.gameHisArr, "/Users/Ben/Desktop/BJ/bjout\(i).txt")
            //system("cd ~/Desktop/BJ && python polt.py \(i)")
        }
    }
    
    func printGameStat(stat: GameStat, endBalance: Int) {
        let dPlayerWinTimes = Double(stat.playerWinTimes)
        let dTotalHandsPlayed = Double(stat.totalHandsPlayed)
        let dDealerWinTimes = Double(stat.dealerWinTimes)
        
        let playerWinRate = String(format: "%5.2f", 100*dPlayerWinTimes/dTotalHandsPlayed)
        let dealerWinRate = String(format: "%5.2f", 100*dDealerWinTimes/dTotalHandsPlayed)
        let winDelta = String(format: "%7.2f", 100*(dPlayerWinTimes-dDealerWinTimes)/dTotalHandsPlayed)
        let pushRate = String(format: "%5.2f", 100*Double(stat.pushTimes)/dTotalHandsPlayed)
        
        let totalHandsPlayeredStr = String(format: "%4d", stat.totalHandsPlayed)
        let playerWinTimesStr = String(format: "%5d", stat.playerWinTimes)
        let playerBJStr = String(format: "%4d", stat.playerBlackJackTimes)
        
        print("Hands Played: \(totalHandsPlayeredStr) ∆:\(winDelta)%  --  Player Win: \(playerWinTimesStr) \(playerWinRate)% -- Dealer Win \(dealerWinRate)% -- Push Rate \(pushRate)% --  Player BJ: \(playerBJStr) End Blance \(endBalance)")
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func downloadSVG() {
        let dir = "~/Downloads/img/"
        for n in ["a","2","3","4","5","6","7","8","9","10","j","q","k"] {
            for s in ["c","h","s","d"] {
                let name = s+n
                system("/usr/local/bin/wget -P \(dir) http://estopoker.com/images/deck/classic/\(name).svg")
                system("cd \(dir) && /usr/local/bin/rsvg-convert -f pdf -o \(name).pdf \(name).svg")
                system("rm \(dir)\(name).svg")
            }
        }
    }

}

