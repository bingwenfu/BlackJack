//
//  FadeAnimator.swift
//  BlackJack
//
//  Created by Bingwen Fu on 4/5/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//

import Cocoa

class FadeAnimator: NSObject, NSViewControllerPresentationAnimator {
    
    func animatePresentationOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
        let (bottomVC,topVC) = (fromViewController,viewController)
        topVC.view.wantsLayer = true
        topVC.view.layerContentsRedrawPolicy = .OnSetNeedsDisplay
        topVC.view.alphaValue = 0
        
        bottomVC.view.addSubview(topVC.view)
        var frame : CGRect = NSRectToCGRect(bottomVC.view.frame)
        frame = CGRectInset(frame, 0, 0)
        topVC.view.frame = NSRectFromCGRect(frame)
        topVC.view.layer?.backgroundColor = NSColor.whiteColor().CGColor
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.5
            topVC.view.animator().alphaValue = 1
        }) {}
    }
    
    func animateDismissalOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
        let (bottomVC, topVC) = (fromViewController, viewController)
        topVC.view.wantsLayer = true
        topVC.view.layerContentsRedrawPolicy = .OnSetNeedsDisplay
        bottomVC.viewDidAppear()
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.5
            topVC.view.animator().alphaValue = 0
        }) {
            topVC.view.removeFromSuperview()
        }
    }

}
