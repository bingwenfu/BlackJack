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

func scaleMake(scale_xy: CGFloat) -> NSValue {
    return NSValue(CGPoint: CGPointMake(scale_xy, scale_xy))
}

func point(x: CGFloat, _ y: CGFloat) -> CGPoint {
    return CGPointMake(x, y)
}


// MARK: GCD Functions
// ----------------------------------------------------------------

func onGlobalThread(function :(() -> Void)) {
    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
    dispatch_async(dispatch_get_global_queue(priority, 0)) {
        function()
    }
}

func onMainThread(function :(() -> Void)) {
    dispatch_async(dispatch_get_main_queue()) {
        function()
    }
}

func withDelay(delayInSecond: Double, function :(() -> Void)) {
    let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSecond * Double(NSEC_PER_SEC)))
    dispatch_after(delay, dispatch_get_main_queue()) {
        function()
    }
}

extension CGRect {
    func shift(x: CGFloat, _ y: CGFloat) -> CGRect {
        return CGRectMake(origin.x + x, origin.y + y, size.width, size.height)
    }
}



