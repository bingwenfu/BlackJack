//
//  SimulatorMain.swift
//  BlackJack
//
//  Created by Bingwen Fu on 7/12/17.
//  Copyright © 2017 Bingwen Fu. All rights reserved.
//

import Cocoa

class SimulatorMain: NSObject {
    
    func excute() {
        //runMonteCarlo()
        //exit(0)
    }
    
    func runMonteCarlo() {
        let simulator = MonteCarloSimulator()
        simulator.simulate(handsNum: 100000)
        simulator.writeGameRecordToDisk(fileName: "/Users/Bingwen/Desktop/bj-01M.json")
    }
    
    func testStratege() {
        
    }
}

