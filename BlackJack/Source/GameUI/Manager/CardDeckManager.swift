//
//  CardDeckView.swift
//  BlackJack
//
//  Created by Bingwen Fu on 6/5/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//

import Foundation
import Cocoa

class CardDeckManager {
    
    var cardAnimationInitialPosition: CGPoint
    var cardAnimationEndY: CGFloat
    var hostView: NSView
    var blowView: NSView
    
    var cardGap: CGFloat = 20.0
    var allCardViews = [CardView]()
    
    init(hostView: NSView, _ cardAnimationInitialPosition: CGPoint, _ cardAnimationEndY: CGFloat, _ blowView: NSView) {
        self.blowView = blowView
        self.hostView = hostView
        self.cardAnimationEndY = cardAnimationEndY
        self.cardAnimationInitialPosition = cardAnimationInitialPosition
    }
    
    func addCard(_ card: Card, _ completion:(()->Void)? = nil) {
        
        let cardView = CardView(card)
        let newDeckWidth = CGFloat(allCardViews.count) * cardGap + cardView.w
        let newDeckMidPointX = hostView.w/2.0
    
        if allCardViews.count > 0 {
            let newDeckLeftPoint = newDeckMidPointX - newDeckWidth/2.0
            let leftMostCardView = allCardViews[0]
            let shiftAmount = leftMostCardView.x - newDeckLeftPoint
            animateShiftExsitingCard(shiftAmount)
        }
        
        let deckRightPoint = newDeckMidPointX + newDeckWidth/2.0
        let newCardPosX = deckRightPoint - cardView.w
        animateDealNewCardView(cardView, to: newCardPosX, completion)
    }
    
    func animateShiftExsitingCard(_ shiftAmount: CGFloat) {
        for c in allCardViews {
            let frame = CGRect(x: c.x - shiftAmount, y: c.y, width: c.w, height: c.h)
            c.positionAnimation(frame, duration: 0.28*animationSpeedFactor, easeOut)
        }
    }
    
    func animateDealNewCardView(_ cardView: CardView, to positionX: CGFloat, _ completion:(()->Void)? = nil) {
        AudioManager.sharedInstance.playShortMp3WithName("cardSlide")
        cardView.frame.origin = cardAnimationInitialPosition
        hostView.addSubview(cardView, positioned: .below, relativeTo: blowView)
        allCardViews.append(cardView)
        
        cardView.alphaValue = 0.0
        cardView.alphaAnimation(1.0, duration: 0.16*animationSpeedFactor)
        
        let size = cardView.frame.size
        let frame = CGRect(x: positionX, y: cardAnimationEndY, width: size.width, height: size.height)
        cardView.positionAnimation(frame, duration: 0.28*animationSpeedFactor, easeOut) { (anim, finished) in
            withDelay(0.12*animationSpeedFactor) {
                completion?()
            }
        }
    }
    
    func removeAllCards() {
        for cv in allCardViews {
            cv.alphaAnimation(0.0, duration: 0.25*animationSpeedFactor) { anim, finished in
                cv.removeFromSuperview()
            }
        }
        allCardViews = [CardView]()
    }
}
