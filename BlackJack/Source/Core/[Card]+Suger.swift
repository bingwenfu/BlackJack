//
//  [Card]+Suger.swift
//  BlackJack
//
//  Created by Bingwen Fu on 4/7/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//


// Syntax sugar for type [Card]
// this allow use to use cards.totalValue instead of totalValue(cards)

extension _ArrayType where Generator.Element == Card {
    
    var totalValue: [Int] {
        get {
            guard let cards = self as? [Card] else { return [0] }
            return totalValueOfCards(cards)
        }
    }
    
    var totalIs21: Bool {
        get {
            guard let cards = self as? [Card] else { return false }
            for v in totalValueOfCards(cards) {
                if v == 21 { return true }
            }
            return false
        }
    }
    
    var maxValue: Int {
        get {
            guard let cards = self as? [Card] else { return 0 }
            var maxV = 0
            for v in cards.totalValue {
                maxV = max(maxV, v)
            }
            return maxV
        }
    }
    
    var minValue: Int {
        get {
            guard let cards = self as? [Card] else { return 0 }
            var minV = Int.max
            for v in cards.totalValue {
                minV = min(minV, v)
            }
            return minV
        }
    }
    
    var busted: Bool {
        get {
            guard let cards = self as? [Card] else { return false }
            return cards.minValue > 21
        }
    }
}
