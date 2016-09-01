//
//  Card.swift
//  BlackJack
//
//  Created by Bingwen Fu on 4/4/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//

// Type of Suit
enum CardSuitType {
    case Clubs, Diamonds, Hearts, Spades
}

// Type of Card
enum CardType {
    case Ace, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King, Hidden
}

// The value each cards correspond in BlackJack
let cardTypeToValueMap : [CardType : [Int]] = [
    .Ace   : [1,11],  .Two   : [2],  .Three : [3],
    .Four  : [4]   ,  .Five  : [5],  .Six   : [6],
    .Seven : [7]   ,  .Eight : [8],  .Nine  : [9],
    .Ten   : [10]  ,  .Jack  : [10], .Queen : [10],
    .King  : [10]  ,  .Hidden: [0]
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
func shuffle(inout cards: [Card]) {
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
func deckOfCards(n: Int) -> [Card] {
    let suits: [CardSuitType] = [.Clubs, .Diamonds, .Hearts, .Spades]
    let types: [CardType] = [.Ace, .Two, .Three, .Four, .Five, .Six, .Seven, .Eight, .Nine, .Ten, .Jack, .Queen, .King]
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
func deal(inout cards:[Card], n: Int) -> [Card] {
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
func totalValueOfCardsHelper(cards: [Card]) -> [Int] {
    var result = [0]
    for ele in (cards.map(){$0.value}) {
        result = ele.flatMap() { e in return result.map() { $0 + e } }
    }
    return result
}

// return all valid cards value of cards [Ace, Tree, King] = [14]
func totalValueOfCards(cards: [Card]) -> [Int] {
    let result = totalValueOfCardsHelper(cards)
    let filtered = result.filter() {$0 <= 21}
    let dup = filtered.count > 0 ? filtered : [result[0]]
    let dupRemoved = Array(Set(dup))
    return dupRemoved
}

// given a Card return the correspond card image name
func imageNameForCard(c: Card) -> String {
    let smap: [CardSuitType: String] = [.Clubs: "c", .Diamonds: "d", .Hearts: "h", .Spades:"s"]
    let cmap: [CardType: String] = [
        .Ace: "a",   .Two: "2",   .Three: "3", .Four: "4", .Five: "5",
        .Six: "6",   .Seven: "7", .Eight: "8", .Nine: "9", .Ten: "10",
        .Jack: "j",  .Queen: "q", .King:  "k"
    ]
    if let s = smap[c.suitType], c = cmap[c.cardType] {
        return s+c
    } else if c.cardType == .Hidden {
        return "h"
    } else {
        print("can not find image name for card \(c) in \(#function)")
        return ""
    }
}

