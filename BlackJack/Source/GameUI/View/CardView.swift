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
        super.init(frame: CGRect(x: 0, y: 0, width: CardView.cardWidth, height: CardView.cardHeight))
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
    
    func flip(_ from: Card, to: Card) {
        let containerView = NSView(frame: self.bounds)
        containerView.wantsLayer = true
        self.addSubview(containerView)
        
        let containerLayer = CATransformLayer()
        containerLayer.frame = containerView.bounds;
        containerView.layer?.addSublayer(containerLayer)
        
        let backLayer = CALayer()
        backLayer.frame = containerView.bounds
        backLayer.contents = NSImage(named: imageNameForCard(to))
        backLayer.isDoubleSided = false
        containerLayer.addSublayer(backLayer)
        backLayer.transform = CATransform3DMakeRotation(3.14, 0, 1, 0)
        
        let frontLayer = CALayer()
        frontLayer.frame = containerView.bounds
        frontLayer.contents = NSImage(named: imageNameForCard(from))
        frontLayer.isDoubleSided = false
        containerLayer.addSublayer(frontLayer)
        
        // make background transparent
        self.image = nil
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.y")
        animation.fromValue = 0
        animation.toValue = M_PI
        animation.duration = 0.3*animationSpeedFactor
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        containerLayer.add(animation, forKey: animation.keyPath)
    }
}

class RoundButton: NSButton {
    
    var overlayView = NSView(frame: CGRect.zero)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.wantsLayer = true
        self.layer?.cornerRadius = self.frame.size.width/2.0
        self.layer?.backgroundColor = NSColor.yellow.cgColor
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
    
    override func mouseDown(with theEvent: NSEvent) {
        overlayView.alphaValue = 0.45
        super.mouseDown(with: theEvent)
        overlayView.alphaValue = 0.0
    }
    
    func setUpOverlayView() {
        overlayView.frame = self.bounds
        overlayView.wantsLayer = true
        overlayView.layer?.backgroundColor = NSColor.black.cgColor
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
        self.layer?.backgroundColor = NSColor.black.cgColor
        self.layer?.opacity = 0.5
        self.setButtonType(.momentaryChange)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.layer?.backgroundColor = NSColor.black.cgColor
        self.layer?.opacity = 0.5
        self.setButtonType(.momentaryChange)
    }
    
    var imgView: NSImageView?
    func setCenterImageWithName(_ name: String) {
        let size = self.frame.size
        let insetXY: CGFloat = 5.0
        if imgView == nil {
            imgView = NSImageView(frame: CGRect(x: insetXY, y: insetXY, width: size.height-2*insetXY, height: size.width-2*insetXY))
            self.addSubview(imgView!, positioned: .below, relativeTo: overlayView)
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
        self.layer?.backgroundColor = NSColor.yellow.cgColor
        self.layer?.anchorPoint = point(0.5,0.5)
        
        let shadow = NSShadow()
        shadow.shadowColor = NSColor(white: 0.1, alpha: 0.8)
        shadow.shadowBlurRadius = 7.0
        self.shadow = shadow
    }
    
    func setCards(_ c: [Card]) {
        let strArr = c.totalValue.map() {String($0)}
        self.stringValue = strArr.joined(separator: "/")
        self.layer?.backgroundColor = (c.maxValue > 21 ? NSColor.red : NSColor.yellow).cgColor
        self.layer?.opacity = (c.count == 0 || c.maxValue == 0) ? 0.0 : 1.0
        setAnchorPoint(point(0.5,0.5), forView: self)
        if c.maxValue != 0 {
            self.scaleAnimation(1.2, duration: 0.1*animationSpeedFactor, timmingFunction: easeIn) { anim, finished in
                self.scaleAnimation(1.0, duration: 0.1*animationSpeedFactor, timmingFunction: easeOut)
            }
        }
    }
    
    func setAnchorPoint(_ anchorPoint: CGPoint, forView view: NSView) {
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer!.anchorPoint.x, y: view.bounds.size.height * view.layer!.anchorPoint.y)
        
        newPoint = newPoint.applying(view.layer!.affineTransform())
        oldPoint = oldPoint.applying(view.layer!.affineTransform())
        
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
        self.layer?.backgroundColor = NSColor.yellow.cgColor
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 45,height: 45))
        self.layer?.backgroundColor = NSColor.black.cgColor
        self.layer?.opacity = 1.0
        
        let imageVie = NSImageView(frame: self.bounds)
        imageVie.image = NSImage(named: "100")
        self.addSubview(imageVie)
    }
    
    override func mouseUp(with theEvent: NSEvent) {
        super.mouseUp(with: theEvent)
        responseFunc?(annotationWebUrlString)
    }
}

