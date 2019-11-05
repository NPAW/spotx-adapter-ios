//
//  BasicPlayerViewController.swift
//  iOSSwift
//
//  Created by nice on 04/11/2019.
//  Copyright © 2019 nice. All rights reserved.
//

import UIKit
import AVKit
import SpotX

class PlayerViewController: UIViewController {
    var playerViewController: AVPlayerViewController?
    var adPlayer: SpotXInterstitialAdPlayer?
    
    var duration: Double {
        guard let currentItem = self.playerViewController?.player?.currentItem else {
            return 0
        }
        
        return TimeInterval(CMTimeGetSeconds(currentItem.duration))
    }
    
    var currentProgress: Double {
        guard let player = self.playerViewController?.player else {
            return 0
        }
        
        let currentTime = TimeInterval(CMTimeGetSeconds(player.currentTime()))
        
        return (currentTime*100) / self.duration
    }
    
    private var playerItemContext = 0
    var viewModel: PlayerViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAdPlayer()
        initializePlayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !self.isMovingFromParent { return }
        
        guard let viewModel = self.viewModel else { return }
        
        viewModel.viewWillDisappear()
        
    }
    
    private func initializeAdPlayer() {
        guard let viewModel = self.viewModel else {
            return
        }
        
        self.adPlayer = SpotXInterstitialAdPlayer()
        
        viewModel.setAdsAdapter(player: self.adPlayer, delegate: self)
    }
    
    private func initializePlayer() {
        guard let viewModel = self.viewModel else {
            return
        }
        // Video player controller
        self.playerViewController = AVPlayerViewController()

        // Add view to the current screen
        self.addChild(playerViewController!)
        self.view.addSubview((self.playerViewController?.view)!)

        // We use the playerView view as a guide for the video
        self.playerViewController?.view.frame = self.view.frame

        guard let url = viewModel.videoUrl else {
            return
        }

        self.playerViewController?.player = AVPlayer(url: url)
        
        viewModel.setAdapter(player: self.playerViewController?.player)

        observePlayer()
    }
    
}

// MARK: - AVPlayer observer methods
extension PlayerViewController {
    func observePlayer() {
        guard let avPlayer = self.playerViewController?.player else {
            return
        }

        avPlayer.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            // Switch over status value
            switch status {
            case .readyToPlay:
                adPlayer?.load()
                return
            default: return
            }
        }
    }
}

// MARK: - SpotXAdPlayerDelegate methods
extension PlayerViewController: SpotXAdPlayerDelegate {
    func request(for player: SpotXAdPlayer) -> SpotXAdRequest? {
        guard let viewModel = self.viewModel else {
            return nil
        }
        
        return viewModel.getAdRequest()
    }
    
    func spotx(_ player: SpotXAdPlayer, didLoadAds group: SpotXAdGroup?, error: Error?) {
        guard let group = group else { return }
        
        if group.ads.count == 0 { return }
        
        player.start()
    }
    
    func spotx(_ player: SpotXAdPlayer, adGroupStart group: SpotXAdGroup) {
        self.playerViewController?.player?.pause()
    }
    
    func spotx(_ player: SpotXAdPlayer, adGroupComplete group: SpotXAdGroup) {
        self.playerViewController?.player?.play()
    }
}
