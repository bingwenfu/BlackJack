//
//  FadeAnimator.swift
//  BlackJack
//
//  Created by Bingwen Fu on 4/5/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//

import Cocoa

class FadeAnimator: NSObject, NSViewControllerPresentationAnimator {
    
    func animatePresentation(of viewController: NSViewController, from fromViewController: NSViewController) {
        let (bottomVC,topVC) = (fromViewController,viewController)
        topVC.view.wantsLayer = true
        topVC.view.layerContentsRedrawPolicy = .onSetNeedsDisplay
        topVC.view.alphaValue = 0
        
        bottomVC.view.addSubview(topVC.view)
        var frame : CGRect = NSRectToCGRect(bottomVC.view.frame)
        frame = frame.insetBy(dx: 0, dy: 0)
        topVC.view.frame = NSRectFromCGRect(frame)
        topVC.view.layer?.backgroundColor = NSColor.white.cgColor
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.5
            topVC.view.animator().alphaValue = 1
        }) {}
    }
    
    func animateDismissal(of viewController: NSViewController, from fromViewController: NSViewController) {
        let (bottomVC, topVC) = (fromViewController, viewController)
        topVC.view.wantsLayer = true
        topVC.view.layerContentsRedrawPolicy = .onSetNeedsDisplay
        bottomVC.viewDidAppear()
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.5
            topVC.view.animator().alphaValue = 0
        }) {
            topVC.view.removeFromSuperview()
        }
    }

}
