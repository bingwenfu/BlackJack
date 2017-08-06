//
//  AppDelegate.swift
//  BlackJack
//
//  Created by Bingwen Fu on 4/5/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        SimulatorMain().excute()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func downloadSVG() {
        let dir = "~/Downloads/img/"
        for n in ["a","2","3","4","5","6","7","8","9","10","j","q","k"] {
            for s in ["c","h","s","d"] {
                let name = s+n
//                system("/usr/local/bin/wget -P \(dir) http://estopoker.com/images/deck/classic/\(name).svg")
//                system("cd \(dir) && /usr/local/bin/rsvg-convert -f pdf -o \(name).pdf \(name).svg")
//                system("rm \(dir)\(name).svg")
            }
        }
    }

}

