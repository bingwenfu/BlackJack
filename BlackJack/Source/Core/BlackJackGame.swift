//
//  BlackJackGame.swift
//  BlackJack
//
//  Created by Bingwen Fu on 4/6/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//

enum GameResult {
    case playerBusted, dealerBusted
    case playerBlackJack, dealerBlackJack
    case playerWin, dealerWin
    case push, playing
}

enum GameAction {
    case stand, doubleDown, split, hit
}

typealias GameResponse = (dealerCards:[Card], playerCards:[Card], gameResult:GameResult)

func isPlayerWin(_ gameResult: GameResult) -> Bool {
    return (gameResult == .playerBlackJack || gameResult == .dealerBusted || gameResult == .playerWin)
}

func isDealerWin(_ gameResult: GameResult) -> Bool {
    return (gameResult == .dealerBlackJack || gameResult == .playerBusted || gameResult == .dealerWin)
}

class BlackJackGame {
    
    var deckNumber = 4
    var cards: [Card]
    var playerCards = [Card]()
    var dealerCards = [Card]()
    let statistician = GameStatistician()
    let hiddenCard = Card(cardType: .hidden, suitType: .hearts)
    
    init() {
        cards = deckOfCards(deckNumber)
        shuffle(&cards)
    }
    
    /// Start of a new round, deal the initial two cards of dealer and player
    /// - returns: the initial game result
    
    func dealNewGame() -> GameResponse {
        // reshuffule
        if cards.count < (deckNumber/4)*52 {
            cards = deckOfCards(deckNumber)
            shuffle(&cards)
            // send notification of shuffle
            NotificationCenter.default.post(name: "shuffle", object: nil)
        }
        playerCards = deal(&cards, n: 2)
        dealerCards = deal(&cards, n: 2)
        let gameResult = checkInitialResult(dealerCards, playerCards: playerCards)
        
        var returnedDealerCards = Array(dealerCards)
        if gameResult != .dealerBlackJack {
            returnedDealerCards[1] = hiddenCard
        }
        // for card counter
        if gameResult == .playerBlackJack {
            returnedDealerCards = dealerCards
        }
        
        statistician.updateStatisticsWithGameResult(gameResult)
        return (returnedDealerCards, playerCards, gameResult)
    }
    
    
    /// If initial round is dealed, user can choose GameAction to proceed the game
    /// - parameter action: game action, can be hit, slpit, stand and double
    /// - returns: the game result after the action is performed based on the blackjack rule
    
    func proceedWithAction(_ action: GameAction) -> GameResponse {
        var gameResult: GameResult = .playing
        switch action {
        case .stand:
            while dealerCards.busted == false && dealerCards.maxValue < 17 {
                dealerCards = dealerCards + deal(&cards, n: 1)
            }
            gameResult = checkGameResult(dealerCards, playerCards: playerCards)
        case .doubleDown:
            playerCards = playerCards + deal(&cards, n: 1)
            if playerCards.minValue <= 21 {
                return proceedWithAction(.stand)
            }
            gameResult = checkGameResult(dealerCards, playerCards: playerCards)
        case .hit:
            playerCards = playerCards + deal(&cards, n: 1)
            gameResult = playerCards.busted ? .playerBusted : .playing
        case .split:
            print("split not implemented")
        }
        statistician.updateStatisticsWithGameResult(gameResult)
        return (dealerCards, playerCards, gameResult)
    }
    
    
    /// Given the player and dealer cards, determin the result of the game
    /// this function should only be used for the first round initial result
    /// - parameter dealerCards: current cards of the dealer
    /// - parameter playerCards: current cards of the player
    /// - returns: the game result based on the blackjack rule
    
    func checkInitialResult(_ dealerCards: [Card], playerCards: [Card]) -> GameResult {
        if dealerCards.totalIs21 && playerCards.totalIs21 { return .push }
        if dealerCards.totalIs21 && !playerCards.totalIs21 { return .dealerBlackJack }
        if playerCards.totalIs21 { return .playerBlackJack }
        return .playing
    }
    
    
    /// Given the player and dealer cards, determin the result of the game
    /// note that if both player and dealer have 2 cards on hand you should use
    /// method checkInitialResult for the game result
    /// - parameter dealerCards: current cards of the dealer
    /// - parameter playerCards: current cards of the player
    /// - returns: the game result based on the blackjack rule
    
    func checkGameResult(_ dealerCards: [Card], playerCards: [Card]) -> GameResult {
        if dealerCards.minValue > 21 { return .dealerBusted }
        if playerCards.minValue > 21 { return .playerBusted }
        
        if dealerCards.maxValue >= 17 {
            if dealerCards.maxValue < playerCards.maxValue { return .playerWin }
            if dealerCards.maxValue > playerCards.maxValue { return .dealerWin }
            if dealerCards.maxValue == playerCards.maxValue { return .push }
        }
        return .playing
    }
    
    func gameStatistic() -> GameStat {
        return statistician.gameStat()
    }
}


