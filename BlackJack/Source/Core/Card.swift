//
//  Card.swift
//  BlackJack
//
//  Created by Bingwen Fu on 4/4/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//

// Type of Suit
enum CardSuitType {
    case clubs, diamonds, hearts, spades
}

// Type of Card
enum CardType {
    case ace, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king, hidden
}

// The value each cards correspond in BlackJack
let cardTypeToValueMap : [CardType : [Int]] = [
    .ace   : [1,11],  .two   : [2],  .three : [3],
    .four  : [4]   ,  .five  : [5],  .six   : [6],
    .seven : [7]   ,  .eight : [8],  .nine  : [9],
    .ten   : [10]  ,  .jack  : [10], .queen : [10],
    .king  : [10]  ,  .hidden: [0]
]

// The struct that encapsulate the card
struct Card {
    let suitType: CardSuitType
    let cardType: CardType
    let value: [Int]
    
    init(cardType: CardType, suitType: CardSuitType) {
        self.value = cardTypeToValueMap[cardType]! // design to crash if invalid
        self.cardType = cardType
        self.suitType = suitType
    }
}

// Given a array of cards and shuffle it
func shuffle(_ cards: inout [Card]) {
    let n = cards.count
    for _ in 1...n*20 {
        let n1 = Int(arc4random_uniform(UInt32(n)))
        let n2 = Int(arc4random_uniform(UInt32(n)))
        let tmp = cards[n1]
        cards[n1] = cards[n2]
        cards[n2] = tmp
    }
}

// creates decks of cards, n is the number of decks
func deckOfCards(_ n: Int) -> [Card] {
    let suits: [CardSuitType] = [.clubs, .diamonds, .hearts, .spades]
    let types: [CardType] = [.ace, .two, .three, .four, .five, .six, .seven, .eight, .nine, .ten, .jack, .queen, .king]
    var cards = [Card]()
    for _ in 0..<n {
        for s in suits {
            for t in types {
                let card = Card(cardType: t, suitType: s)
                cards.append(card)
            }
        }
    }
    return cards
}

// deal n cards out of an card array
func deal(_ cards:inout [Card], n: Int) -> [Card] {
    var result = [Card]()
    for _ in 0..<n {
        if cards.count >= 1 {
            result.append(cards[0])
            cards.removeFirst()
        } else {
            print("error cards total \(cards.count) but want to deal \(n) in \(#function) \(#line)")
        }
    }
    return result
}

// calculate all possibility value of cards exp: [Ace, Tree, King] = [14, 24]
func totalValueOfCardsHelper(_ cards: [Card]) -> [Int] {
    var result = [0]
    for ele in (cards.map(){$0.value}) {
        result = ele.flatMap() { e in return result.map() { $0 + e } }
    }
    return result
}

// return all valid cards value of cards [Ace, Tree, King] = [14]
func totalValueOfCards(_ cards: [Card]) -> [Int] {
    let result = totalValueOfCardsHelper(cards)
    let filtered = result.filter() {$0 <= 21}
    let dup = filtered.count > 0 ? filtered : [result[0]]
    let dupRemoved = Array(Set(dup))
    return dupRemoved
}

// given a Card return the correspond card image name
func imageNameForCard(_ c: Card) -> String {
    let smap: [CardSuitType: String] = [.clubs: "c", .diamonds: "d", .hearts: "h", .spades:"s"]
    let cmap: [CardType: String] = [
        .ace: "a",   .two: "2",   .three: "3", .four: "4", .five: "5",
        .six: "6",   .seven: "7", .eight: "8", .nine: "9", .ten: "10",
        .jack: "j",  .queen: "q", .king:  "k"
    ]
    if let s = smap[c.suitType], let c = cmap[c.cardType] {
        return s+c
    } else if c.cardType == .hidden {
        return "h"
    } else {
        print("can not find image name for card \(c) in \(#function)")
        return ""
    }
}

