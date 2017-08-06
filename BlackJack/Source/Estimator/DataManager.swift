//
//  DataManager.swift
//  BlackJack
//
//  Created by Bingwen Fu on 4/23/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataManager {
    
    // MARK: Singleton
    class var sharedInstance : DataManager {
        struct Static {
            static let instance : DataManager = DataManager()
        }
        return Static.instance
    }
    
    func readJsonFromFile(fileName: String) -> JSON {
        do {
            guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
                print("fail to read json:", fileName)
                exit(0)
            }
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            let json = JSON(data: data)
            return json
        } catch {
            print("fail to write game record to disk")
            exit(0)
        }
    }
    
    func writeGameHisToFile(_ arr: [GameHistory], _ filePath: String) {
        let content = NSMutableString()
        for his in arr {
            content.append(gameHistoryToString(his))
        }
        do {
            try content.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8.rawValue)
        } catch {
            print("Exception: cannot write to file \(filePath) in \(#function)")
        }
    }
    
    func gameHistoryToString(_ his: GameHistory) -> String {
        return "\(his.handNumber) \(his.oldBalance) \(his.oldBet) \(his.handResult) \(his.newBet) \(his.newBalance) \(his.currentStreak)\n"
    }
}
