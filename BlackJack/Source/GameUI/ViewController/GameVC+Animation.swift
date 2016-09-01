//
//  GameVC+Animation.swift
//  BlackJack
//
//  Created by Bingwen Fu on 4/8/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//

import Foundation
import Cocoa

extension GameVC {
    
    func fullScreenChipsFallAnimation() {
        let n = 120
        for _ in 0..<n {
            let time = Double(arc4random_uniform(UInt32(22)))/10.0
            withDelay(time) {
                self.dropSingleChip()
            }
        }
    }
    
    func dropSingleChip () {
        let names = ["1p", "20p", "50p", "100p"]
        let idx = Int(arc4random_uniform(UInt32(names.count)))
        let image = NSImage(named: names[idx])
        
        let w: CGFloat = 58
        let x = CGFloat(arc4random_uniform(UInt32(view.frame.size.width)))
        let y = CGFloat(arc4random_uniform(UInt32(view.frame.size.height)))
        let rect = CGRectMake(x,view.frame.size.height+w+y*0.2,w,w)
        let duration = Double(arc4random_uniform(UInt32((10*animationSpeedFactor))))/10 + 0.8
        
        let containerView = NSView(frame: rect)
        containerView.wantsLayer = true
        view.addSubview(containerView)
        
        let containerLayer = CATransformLayer()
        containerLayer.frame = containerView.bounds;
        containerView.layer?.addSublayer(containerLayer)
        
        let backLayer = CALayer()
        backLayer.frame = containerView.bounds
        backLayer.contents = image
        backLayer.doubleSided = false
        backLayer.transform = CATransform3DMakeRotation(3.14, 0, 1, 0)
        containerLayer.addSublayer(backLayer)
        
        let frontLayer = CALayer()
        frontLayer.frame = containerView.bounds
        frontLayer.contents = image
        frontLayer.doubleSided = false
        containerLayer.addSublayer(frontLayer)
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.y")
        animation.fromValue = 0
        animation.toValue = 2*M_PI
        animation.duration = duration
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.repeatCount = Float.infinity
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        containerLayer.addAnimation(animation, forKey: animation.keyPath)
        
        containerView.positionAnimation(CGRectMake(x, -w-0.1*y, w, w), duration: 1.6, easeIn) { anim, finished in
            containerView.removeFromSuperview()
        }
    }
    
    func showWinChipAnimation(winAmount: Int) {
        
        // animation start point, end point and circle center
        let sx: CGFloat = 570
        let s = point(sx, 680)
        let e = point(sx, betChipImageView.y)
        let c = point(200, (s.y+e.y)/2.0)
        
        // calculate radius and angle
        let dx = c.x-s.x
        let dy = c.y-s.y
        let r = sqrt(dx*dx + dy*dy)
        let sa = asin(abs(s.y-c.y)/r)
        
        // create image
        let imgV = NSImageView(frame: CGRectMake(s.x, s.y, 80, 80))
        imgV.image = NSImage(named:"100")
        self.view.addSubview(imgV)
        
        // create animation path
        let arcPath = CGPathCreateMutable();
        CGPathMoveToPoint(arcPath, nil, s.x, s.y);
        CGPathAddArc(arcPath, nil, c.x, c.y, r, sa, -sa, true);
        
        // play sound
        withDelay(0.15) {
            self.audioManager.playShortMp3WithName("chipStack")
        }
        
        // arc path animation first
        CATransaction.begin()
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = arcPath
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        animation.duration = 0.9*animationSpeedFactor
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        CATransaction.setCompletionBlock() {
            withDelay(0.4) {
                // then opacity and position animation
                imgV.alphaAnimation(0.0, duration: 0.7*animationSpeedFactor)
                let ani = CABasicAnimation(keyPath: "position")
                ani.duration = 0.5*animationSpeedFactor
                // print(point((self.view.x/2.0)-(imgV.w/2.0), 18))
                ani.toValue = NSValue(CGPoint: point((self.view.w/2.0)-(imgV.w/2.0), 18))
                ani.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
                ani.removedOnCompletion = false
                ani.fillMode = kCAFillModeForwards
                imgV.layer?.addAnimation(ani, forKey: "dc")
            }
            // update balance label after arc animation
            self.updateBalanceLabelWithAmount(winAmount)
        }
        imgV.layer?.addAnimation(animation, forKey:"showWinChipAnimation")
        CATransaction.commit()
    }
    
    func showLoseLoseChipAnimation(amount: Int) {
        // animation start point, end point and circle center
        print(betChipImageView)
        let betChipFrame = betChipImageView.frame
        let s = betChipFrame.origin
        let e = point(461, 680)
        let c = point(300, (s.y+e.y)/2.0)
        
        // calculate radius and angle
        let dx = c.x-s.x
        let dy = c.y-s.y
        let r = sqrt(dx*dx + dy*dy)
        let sa = asin(abs(s.y-c.y)/r)
        
        // create animation path
        let arcPath = CGPathCreateMutable();
        CGPathMoveToPoint(arcPath, nil, s.x, s.y);
        CGPathAddArc(arcPath, nil, c.x, c.y, r, -sa, sa, false);
        
        // play sound
        withDelay(0.15) {
            self.audioManager.playShortMp3WithName("chipStack")
        }
        
        // arc path animation first
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.calculationMode = kCAAnimationPaced
        animation.path = arcPath
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        animation.duration = 0.7*animationSpeedFactor
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        betChipImageView.layer?.addAnimation(animation, forKey:"showWinChipAnimation")
        betChipImageView.alphaAnimation(0.2, duration: 1.5*animationSpeedFactor)
        
        withDelay(0.5) {
            if self.playerBalance + amount < 0 {
                self.playerBet = self.playerBalance
                self.playerBalance = 0
                self.updateBetAndBalanceLabel()
            } else {
                self.updateBalanceLabelWithAmount(amount)
                self.pushOneChipToBetPositionFromBottom("100")
            }
        }
    }
    
    func pushOneChipToBetPositionFromBottom(imageName: String) {
        let newBet = NSImageView(frame: CGRectMake(461, 0, 80, 80))
        newBet.image = NSImage(named: imageName)
        newBet.alphaValue = 0.0
        view.addSubview(newBet)
        
        newBet.positionAnimation(betChipImageView.frame, duration: 0.25*animationSpeedFactor)
        newBet.alphaAnimation(1.0, duration: 0.25*animationSpeedFactor) { anim, finished in
            self.betChipImageView.removeFromSuperview()
            self.betChipImageView = newBet
        }
    }
    
    func flipShowDealerHiddenCard(dealerCards: [Card]) {
        audioManager.playShortMp3WithName("cardSlide")
        for cv in dealerCardDeckManager!.allCardViews {
            if cv.card?.cardType == .Hidden {
                cv.flip(cv.card!, to: dealerCards[1])
            }
        }
    }
    
    func updateBetAndBalanceLabel() {
        betLabel.stringValue = "\(playerBet)"
        balanceLabel.stringValue = "Balance  $\(playerBalance)"
    }
    
    func updateBalanceLabelWithAmount(amount: Int) {
        graduallyUpdateBalanceLabelFrom(playerBalance, to: playerBalance+amount)
        playerBalance+=amount
    }
    
    func graduallyUpdateBalanceLabelFrom(old: Int, to new: Int) {
        let n = 9
        let speed = 0.08
        let s = (new - old)/n
        
        for i in 0..<n {
            withDelay(Double(i)*speed) {
                self.balanceLabel.stringValue = "Balance  $\(old+i*s)"
            }
        }
        withDelay(Double(n)*speed) {
            self.balanceLabel.stringValue = "Balance  $\(new)"
        }
    }
}
