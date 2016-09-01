//
//  BlackJackGame.swift
//  BlackJack
//
//  Created by Bingwen Fu on 4/6/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//

enum GameResult {
    case PlayerBusted, DealerBusted
    case PlayerBlackJack, DealerBlackJack
    case PlayerWin, DealerWin
    case Push, Playing
}

enum GameAction {
    case Stand, DoubleDown, Split, Hit
}

typealias GameResponse = (dealerCards:[Card], playerCards:[Card], gameResult:GameResult)

func isPlayerWin(gameResult: GameResult) -> Bool {
    return (gameResult == .PlayerBlackJack || gameResult == .DealerBusted || gameResult == .PlayerWin)
}

class BlackJackGame {
    
    private var deckNumber = 4
    private var cards: [Card]
    private var playerCards = [Card]()
    private var dealerCards = [Card]()
    private let statistician = GameStatistician()
    let hiddenCard = Card(cardType: .Hidden, suitType: .Hearts)
    
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
        }
        playerCards = deal(&cards, n: 2)
        dealerCards = deal(&cards, n: 2)
        let gameResult = checkInitialResult(dealerCards, playerCards: playerCards)
        
        var returnedDealerCards = Array(dealerCards)
        if gameResult != .DealerBlackJack {
            returnedDealerCards[1] = hiddenCard
        }
        
        statistician.updateStatisticsWithGameResult(gameResult)
        return (returnedDealerCards, playerCards, gameResult)
    }
    
    
    /// If initial round is dealed, user can choose GameAction to proceed the game
    /// - parameter action: game action, can be hit, slpit, stand and double
    /// - returns: the game result after the action is performed based on the blackjack rule
    
    func proceedWithAction(action: GameAction) -> GameResponse {
        var gameResult: GameResult = .Playing
        switch action {
        case .Stand:
            while dealerCards.busted == false && dealerCards.maxValue < 17 {
                dealerCards = dealerCards + deal(&cards, n: 1)
            }
            gameResult = checkGameResult(dealerCards, playerCards: playerCards)
        case .DoubleDown:
            playerCards = playerCards + deal(&cards, n: 1)
            if playerCards.minValue <= 21 {
                return proceedWithAction(.Stand)
            }
            gameResult = checkGameResult(dealerCards, playerCards: playerCards)
        case .Hit:
            playerCards = playerCards + deal(&cards, n: 1)
            gameResult = playerCards.busted ? .PlayerBusted : .Playing
        case .Split:
            ""
        }
        statistician.updateStatisticsWithGameResult(gameResult)
        return (dealerCards, playerCards, gameResult)
    }
    
    
    /// Given the player and dealer cards, determin the result of the game
    /// this function should only be used for the first round initial result
    /// - parameter dealerCards: current cards of the dealer
    /// - parameter playerCards: current cards of the player
    /// - returns: the game result based on the blackjack rule
    
    private func checkInitialResult(dealerCards: [Card], playerCards: [Card]) -> GameResult {
        if dealerCards.totalIs21 && playerCards.totalIs21 { return .Push }
        if dealerCards.totalIs21 && !playerCards.totalIs21 { return .DealerBlackJack }
        if playerCards.totalIs21 { return .PlayerBlackJack }
        return .Playing
    }
    
    
    /// Given the player and dealer cards, determin the result of the game
    /// note that if both player and dealer have 2 cards on hand you should use
    /// method checkInitialResult for the game result
    /// - parameter dealerCards: current cards of the dealer
    /// - parameter playerCards: current cards of the player
    /// - returns: the game result based on the blackjack rule
    
    private func checkGameResult(dealerCards: [Card], playerCards: [Card]) -> GameResult {
        if dealerCards.minValue > 21 { return .DealerBusted }
        if playerCards.minValue > 21 { return .PlayerBusted }
        
        if dealerCards.maxValue >= 17 {
            if dealerCards.maxValue < playerCards.maxValue { return .PlayerWin }
            if dealerCards.maxValue > playerCards.maxValue { return .DealerWin }
            if dealerCards.maxValue == playerCards.maxValue { return .Push }
        }
        return .Playing
    }
    
    func gameStatistic() -> GameStat {
        return statistician.gameStat()
    }
}


