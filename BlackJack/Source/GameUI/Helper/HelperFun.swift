//
//  HelperFun.swift
//  BlackJack
//
//  Created by Bingwen Fu on 4/5/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//

import Cocoa
import Foundation

let easeOut = kCAMediaTimingFunctionEaseOut
let easeIn  = kCAMediaTimingFunctionEaseIn
let linear  = kCAMediaTimingFunctionLinear

func scaleMake(_ scale_xy: CGFloat) -> NSValue {
    return NSValue(cgPoint: CGPoint(x: scale_xy, y: scale_xy))
}

func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
    return CGPoint(x: x, y: y)
}


// MARK: GCD Functions
// ----------------------------------------------------------------

func onGlobalThread(_ function :@escaping (() -> Void)) {
    let priority = DispatchQueue.GlobalQueuePriority.default
    DispatchQueue.global(priority: priority).async {
        function()
    }
}

func onMainThread(_ function :@escaping (() -> Void)) {
    DispatchQueue.main.async {
        function()
    }
}

func withDelay(_ delayInSecond: Double, function :@escaping (() -> Void)) {
    let delay = DispatchTime.now() + Double(Int64(delayInSecond * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delay) {
        function()
    }
}

extension CGRect {
    func shift(_ x: CGFloat, _ y: CGFloat) -> CGRect {
        return CGRect(x: origin.x + x, y: origin.y + y, width: size.width, height: size.height)
    }
}



