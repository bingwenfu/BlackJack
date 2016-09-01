//
//  FadeSegue.swift
//  BlackJack
//
//  Created by Bingwen Fu on 4/5/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//


import Cocoa

class FadeSegue: NSStoryboardSegue {
    
    override func perform() {
        let animator = FadeAnimator()
        let sourceVC  = self.sourceController as! NSViewController
        let destVC = self.destinationController as! NSViewController
        sourceVC.presentViewController(destVC, animator: animator)
    }
}


