//
//  DataManager.swift
//  BlackJack
//
//  Created by Bingwen Fu on 4/23/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//

import Foundation

class DataManager {
    
    // MARK: Singleton
    class var sharedInstance : DataManager {
        struct Static {
            static let instance : DataManager = DataManager()
        }
        return Static.instance
    }
    
    func writeGameHisToFile(arr: [GameHistory], _ filePath: String) {
        let content = NSMutableString()
        for his in arr {
            content.appendString(gameHistoryToString(his))
        }
        do {
            try content.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
        } catch {
            print("Exception: cannot write to file \(filePath) in \(#function)")
        }
    }
    
    func gameHistoryToString(his: GameHistory) -> String {
        return "\(his.handNumber) \(his.oldBalance) \(his.oldBet) \(his.handResult) \(his.newBet) \(his.newBalance) \(his.currentStreak)\n"
    }
}
