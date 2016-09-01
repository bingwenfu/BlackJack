//
//  CardView.swift
//  BlackJack
//
//  Created by Bingwen Fu on 4/6/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//

import Foundation
import Cocoa

class CardView: NSImageView {
    
    static var cardHeight: CGFloat = 165
    static var cardWidth: CGFloat = 118
    var card: Card?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(_ card: Card) {
        super.init(frame: CGRectMake(0, 0, CardView.cardWidth, CardView.cardHeight))
        self.card = card
        self.wantsLayer = true
        
        let shadow = NSShadow()
        shadow.shadowColor = NSColor(white: 0.1, alpha: 0.9)
        shadow.shadowBlurRadius = 3.0
        self.shadow = shadow
        
        if let image = NSImage(named: imageNameForCard(card)) {
            self.image = image
        } else {
            Swift.print("CardView :: cannot load image named: \(imageNameForCard(card))")
        }
    }
    
    func flip(from: Card, to: Card) {
        let containerView = NSView(frame: self.bounds)
        containerView.wantsLayer = true
        self.addSubview(containerView)
        
        let containerLayer = CATransformLayer()
        containerLayer.frame = containerView.bounds;
        containerView.layer?.addSublayer(containerLayer)
        
        let backLayer = CALayer()
        backLayer.frame = containerView.bounds
        backLayer.contents = NSImage(named: imageNameForCard(to))
        backLayer.doubleSided = false
        containerLayer.addSublayer(backLayer)
        backLayer.transform = CATransform3DMakeRotation(3.14, 0, 1, 0)
        
        let frontLayer = CALayer()
        frontLayer.frame = containerView.bounds
        frontLayer.contents = NSImage(named: imageNameForCard(from))
        frontLayer.doubleSided = false
        containerLayer.addSublayer(frontLayer)
        
        // make background transparent
        self.image = nil
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.y")
        animation.fromValue = 0
        animation.toValue = M_PI
        animation.duration = 0.3*animationSpeedFactor
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        containerLayer.addAnimation(animation, forKey: animation.keyPath)
    }
}

class RoundButton: NSButton {
    
    var overlayView = NSView(frame: CGRectZero)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.wantsLayer = true
        self.layer?.cornerRadius = self.frame.size.width/2.0
        self.layer?.backgroundColor = NSColor.yellowColor().CGColor
        setUpOverlayView()
        
        let shadow = NSShadow()
        shadow.shadowColor = NSColor(white: 0.1, alpha: 0.8)
        shadow.shadowBlurRadius = 7.0
        self.shadow = shadow
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpOverlayView()
    }
    
    override func mouseDown(theEvent: NSEvent) {
        overlayView.alphaValue = 0.45
        super.mouseDown(theEvent)
        overlayView.alphaValue = 0.0
    }
    
    func setUpOverlayView() {
        overlayView.frame = self.bounds
        overlayView.wantsLayer = true
        overlayView.layer?.backgroundColor = NSColor.blackColor().CGColor
        overlayView.layer?.cornerRadius = self.bounds.width/2.0
        overlayView.alphaValue = 0.0
        if overlayView.superview == nil {
            self.addSubview(overlayView)
        }
    }
}

class GrayTransparentRoundButton: RoundButton {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer?.backgroundColor = NSColor.blackColor().CGColor
        self.layer?.opacity = 0.5
        self.setButtonType(.MomentaryChangeButton)
    }
    
    init() {
        super.init(frame: CGRectZero)
        self.layer?.backgroundColor = NSColor.blackColor().CGColor
        self.layer?.opacity = 0.5
        self.setButtonType(.MomentaryChangeButton)
    }
    
    var imgView: NSImageView?
    func setCenterImageWithName(name: String) {
        let size = self.frame.size
        let insetXY: CGFloat = 5.0
        if imgView == nil {
            imgView = NSImageView(frame: CGRectMake(insetXY, insetXY, size.height-2*insetXY, size.width-2*insetXY))
            self.addSubview(imgView!, positioned: .Below, relativeTo: overlayView)
        }
        let image = NSImage(named: name)
        imgView!.image = image
    }
}

class RoundLabel: NSTextField {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.wantsLayer = true
        self.layer?.cornerRadius = self.frame.size.height/2.0
        self.layer?.backgroundColor = NSColor.yellowColor().CGColor
        self.layer?.anchorPoint = point(0.5,0.5)
        
        let shadow = NSShadow()
        shadow.shadowColor = NSColor(white: 0.1, alpha: 0.8)
        shadow.shadowBlurRadius = 7.0
        self.shadow = shadow
    }
    
    func setCards(c: [Card]) {
        let strArr = c.totalValue.map() {String($0)}
        self.stringValue = strArr.joinWithSeparator("/")
        self.layer?.backgroundColor = (c.maxValue > 21 ? NSColor.redColor() : NSColor.yellowColor()).CGColor
        self.layer?.opacity = (c.count == 0 || c.maxValue == 0) ? 0.0 : 1.0
        setAnchorPoint(point(0.5,0.5), forView: self)
        if c.maxValue != 0 {
            self.scaleAnimation(1.2, duration: 0.1*animationSpeedFactor, timmingFunction: easeIn) { anim, finished in
                self.scaleAnimation(1.0, duration: 0.1*animationSpeedFactor, timmingFunction: easeOut)
            }
        }
    }
    
    func setAnchorPoint(anchorPoint: CGPoint, forView view: NSView) {
        var newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPointMake(view.bounds.size.width * view.layer!.anchorPoint.x, view.bounds.size.height * view.layer!.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.layer!.affineTransform())
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.layer!.affineTransform())
        
        var position = view.layer!.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer!.position = position
        view.layer!.anchorPoint = anchorPoint
    }
    
    override var stringValue: String {
        set {
            super.stringValue =  "      \(newValue)      "
            self.layer?.opacity = newValue == "" ? 0.0 : 1.0
        }
        get {
            return self.stringValue
        }
    }
}

class AnnotationButton: NSView {
    var annotationWebUrlString: String?
    var responseFunc : ((String?)->Void)?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer?.cornerRadius = self.frame.size.height/2.0
        self.layer?.backgroundColor = NSColor.yellowColor().CGColor
    }
    
    init() {
        super.init(frame: CGRectMake(0, 0, 45,45))
        self.layer?.backgroundColor = NSColor.blackColor().CGColor
        self.layer?.opacity = 1.0
        
        let imageVie = NSImageView(frame: self.bounds)
        imageVie.image = NSImage(named: "100")
        self.addSubview(imageVie)
    }
    
    override func mouseUp(theEvent: NSEvent) {
        super.mouseUp(theEvent)
        responseFunc?(annotationWebUrlString)
    }
}

