//
//  NSView+Pop.swift
//  WeRead
//
//  Created by Bingwen Fu on 8/17/14.
//  Copyright (c) 2014 Bingwen. All rights reserved.
//

import Cocoa

typealias animCompletion = ((POPAnimation!, Bool)->Void)?

extension NSView {

    func springPositionTo(toValue: CGRect, bounciness: CGFloat, speed: CGFloat) {
        let anim = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        anim.toValue = NSValue(CGRect:toValue)
        anim.springBounciness = bounciness
        anim.springSpeed = speed
        self.pop_addAnimation(anim, forKey: "scale_animation")
    }
    
    func alphaAnimation(toValue: CGFloat, duration: CFTimeInterval, completion: animCompletion = nil) {
        let anim = POPBasicAnimation(propertyNamed: kPOPViewAlphaValue)
        anim.toValue = toValue
        anim.duration = duration
        anim.completionBlock = completion
        self.pop_addAnimation(anim, forKey: "alpha_animation")
    }
    
    func positionAnimation(toValue: CGRect, duration: CFTimeInterval, _ timmingFunction: String = linear, completion: animCompletion = nil) {
        let anim = POPBasicAnimation(propertyNamed: kPOPViewFrame)
        anim.timingFunction = CAMediaTimingFunction(name: timmingFunction)
        anim.fromValue = NSValue(CGRect:self.frame)
        anim.toValue = NSValue(CGRect:toValue)
        anim.duration = duration
        anim.completionBlock = completion
        self.pop_addAnimation(anim, forKey: "frame_animation")
    }
    
    func scaleAnimation(toValue: CGFloat, duration: CFTimeInterval, timmingFunction: String = linear, completion: animCompletion = nil) {
        let anim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        anim.timingFunction = CAMediaTimingFunction(name: timmingFunction)
        anim.toValue = NSValue(CGPoint:point(toValue,toValue))
        anim.duration = duration
        anim.completionBlock = completion
        self.layer!.pop_addAnimation(anim, forKey: "scaleXY_animation")
    }
    
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
    }
    
    var w: CGFloat {
        get {
            return self.frame.size.width
        }
    }
    
    var h: CGFloat {
        get {
            return self.frame.size.height
        }
    }
}


extension CALayer {
    func alphaAnimation(toValue: CGFloat, duration: CFTimeInterval, completion: animCompletion = nil) {
        let anim = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
        anim.toValue = toValue
        anim.duration = duration
        anim.completionBlock = completion
        self.pop_addAnimation(anim, forKey: "alpha_animation")
    }
}