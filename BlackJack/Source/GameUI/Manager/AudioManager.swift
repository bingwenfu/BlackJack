//
//  AudioManager.swift
//  BlackJack
//
//  Created by Bingwen Fu on 4/5/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//

import Foundation
import AVFoundation

class AudioManager : NSObject, AVAudioPlayerDelegate {
    
    // MARK: Singleton
    class var sharedInstance : AudioManager {
        struct Static {
            static let instance : AudioManager = AudioManager()
        }
        return Static.instance
    }
    
    var longPlayer = AVAudioPlayer()
    var shortPlayer = AVAudioPlayer()
    var shouldMute = false
    
    func setMuted(muted: Bool) {
        shouldMute = muted
        if muted {
            longPlayer.stop()
        } else {
            longPlayer.play()
        }
    }
    
    func playLongMp3WithName(name: String) {
        playMp3(name, withPlayer: &longPlayer)
    }
    
    func playShortMp3WithName(name: String) {
        playMp3(name, withPlayer: &shortPlayer)
    }
    
    func playMp3(name: String, inout withPlayer player: AVAudioPlayer) {
        guard shouldMute == false else { return }
        guard let url2 = NSBundle.mainBundle().URLForResource(name, withExtension:"mp3") else {
            return print("cannot find resource in \(#function)")
        }
        do {
            player = try AVAudioPlayer(contentsOfURL: url2)
            player.play()
            player.delegate = self
        } catch {
            print("cannot load resource in \(#function)")
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if player == self.longPlayer {
            player.play()
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        print("audioPlayerDecodeErrorDidOccur \(player) \(error)")
    }
}

