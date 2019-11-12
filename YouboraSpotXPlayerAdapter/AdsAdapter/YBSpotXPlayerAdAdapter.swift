//
//  YBSpotXPlayerAdAdapter.swift
//  YouboraSpotXPlayerAdapter
//
//  Created by nice on 31/10/2019.
//  Copyright © 2019 nice. All rights reserved.
//

import Foundation
import YouboraLib
import SpotX

internal protocol AuxiliarMethods {
    func resetAdInfo()
    func calculateAdQuartile(currentTime: Double)
    func incrementAndSendQuartile()
}

internal class YBSpotXPlayerAdAdapterBase: YBPlayerAdapter<AnyObject> {
    
    weak var delegate: SpotXAdPlayerDelegate?
    
    var isCurrentAdSkippable = false
    var currentAd: SpotXAd?
    var currentAdBreak: SpotXAdGroup?
    var playhead: Double?
    var lastQuartile = 0
    
    // MARK: Adapter methods
    
    public override init() {
        super.init()
    }
    
    public override init(player: AnyObject) {
        super.init(player: player)
    }
    
    public override func registerListeners() {
        guard let player = self.player as? SpotXInterstitialAdPlayer else {
            return
        }
        
        player.delegate = self
    }
    
    public override func unregisterListeners() {
        guard let player = self.player as? SpotXInterstitialAdPlayer else {
            return
        }
        
        player.delegate = nil
    }
    
    // MARK: Get methods
    
    override func getDuration() -> NSNumber? {
        guard let ad = self.currentAd else {
            return super.getDuration()
        }
        
        return ad.duration
    }
    
    override func getTitle() -> String? {
        guard let ad = self.currentAd else {
            return super.getTitle()
        }
        
        return ad.title
    }
    
    override func getPlayhead() -> NSNumber? {
        guard let playhead = self.playhead else {
            return super.getPlayhead()
        }
        
        return NSNumber(value: playhead)
    }
    
    override func getPosition() -> YBAdPosition {
        guard let adapter = self.plugin?.adapter else {
            return .pre
        }
        
        if !adapter.flags.joined { return .pre }
        
        return .mid
    }
    
    override func getGivenAds() -> NSNumber? {
        guard let adBreak = self.currentAdBreak else {
            return super.getGivenAds()
        }
        
        return NSNumber(value: adBreak.ads.count)
    }

    override open func getPlayerName() -> String? {
        return Utils.getPlayerName(ads: true)
    }

    override open func getPlayerVersion() -> String? {
        return Utils.getPlayerVersion(ads: true)
    }
    
    override open func getVersion() -> String {
        return Utils.getVersion(ads: true)
    }
    
    override func getAdProvider() -> String? { return nil }
    
    override func getResource() -> String? { return nil }
    
    override func isSkippable() -> NSValue? {
        return  NSNumber(value: self.isCurrentAdSkippable)
    }
}

// MARK: SpotXAdPlayerDelegate methods
extension YBSpotXPlayerAdAdapterBase: SpotXAdPlayerDelegate {
    func request(for player: SpotXAdPlayer) -> SpotXAdRequest? {
        return self.delegate?.request?(for: player)
    }
    
    func vastRequest(for player: SpotXAdPlayer) -> SpotXVastRequest? {
        return self.delegate?.vastRequest?(for: player)
    }
    
    func spotx(_ player: SpotXAdPlayer, didLoadAds group: SpotXAdGroup?, error: Error?) {
        self.delegate?.spotx?(player, didLoadAds: group, error: error)
        if let adsError = error {
            fireFatalError(withMessage: (adsError as NSError).localizedDescription, code: (adsError as NSError).domain, andMetadata: nil)
            return
        }
    }
    
    func spotx(_ player: SpotXAdPlayer, adGroupStart group: SpotXAdGroup) {
        self.delegate?.spotx?(player, adGroupStart: group)
        self.currentAdBreak = group
        fireAdBreakStart()
        
    }
    
    func spotx(_ player: SpotXAdPlayer, adGroupComplete group: SpotXAdGroup) {
        self.delegate?.spotx?(player, adGroupComplete: group)
        self.currentAdBreak = nil
        fireAdBreakStop()
    }
    
    func spotx(_ player: SpotXAdPlayer, adStart ad: SpotXAd) {
        self.delegate?.spotx?(player, adStart: ad)
        self.resetAdInfo()
        self.currentAd = ad
        fireStart()
        fireJoin()
    }
    
    func spotx(_ player: SpotXAdPlayer, adPlaying ad: SpotXAd) {
        self.delegate?.spotx?(player, adPlaying: ad)
    }
    
    func spotx(_ player: SpotXAdPlayer, adPaused ad: SpotXAd) {
        self.delegate?.spotx?(player, adPaused: ad)
        firePause()
    }
    
    func spotx(_ player: SpotXAdPlayer, adTimeUpdate ad: SpotXAd, timeElapsed seconds: Double) {
        self.delegate?.spotx?(player, adTimeUpdate: ad, timeElapsed: seconds)
        self.playhead = seconds
        fireResume()
        calculateAdQuartile(currentTime: seconds)
    }
    
    func spotx(_ player: SpotXAdPlayer, adClicked ad: SpotXAd) {
        self.delegate?.spotx?(player, adClicked: ad)
        fireClick(withAdUrl: ad.clickthru)
    }
    
    func spotx(_ player: SpotXAdPlayer, adComplete ad: SpotXAd) {
        self.delegate?.spotx?(player, adComplete: ad)
        fireStop()
        self.playhead = nil
        self.currentAd = nil
    }
    
    func spotx(_ player: SpotXAdPlayer, adSkipped ad: SpotXAd) {
        self.delegate?.spotx?(player, adSkipped: ad)
        fireSkip()
    }
    
    func spotx(_ player: SpotXAdPlayer, adUserClose ad: SpotXAd) {
        self.delegate?.spotx?(player, adUserClose: ad)
        
        fireStop()
        fireAdBreakStop()
    }
    
    func spotx(_ player: SpotXAdPlayer, adError ad: SpotXAd?, error: Error?) {
        self.delegate?.spotx?(player, adError: ad, error: error)
        if let error = error as NSError? {
            fireFatalError(withMessage: error.localizedDescription, code: "\(error.code)", andMetadata: nil)
            return
        }
        
        fireFatalError(withMessage: "Unknown", code: "Unknown", andMetadata: nil)
    }
    
    func spotx(_ player: SpotXAdPlayer, ad: SpotXAd, didChangeSkippableState skippable: Bool) {
        self.delegate?.spotx?(player, ad: ad, didChangeSkippableState: skippable)
        self.isCurrentAdSkippable = skippable
    }
}

// MARK: Auxliar methods
extension YBSpotXPlayerAdAdapterBase: AuxiliarMethods {
    func resetAdInfo() {
        self.lastQuartile = 0
        self.isCurrentAdSkippable = false
    }
    
    func calculateAdQuartile(currentTime: Double) {
        guard let ad = self.currentAd else {
            return
        }
        
        let progress = (currentTime*100)/ad.duration.doubleValue
        
        if progress >= 25 && lastQuartile < 1 {
            incrementAndSendQuartile()
            return
        }
        
        if progress >= 50 && lastQuartile < 2 {
            incrementAndSendQuartile()
            return
        }
        
        if progress >= 75 && lastQuartile < 3 {
            incrementAndSendQuartile()
            return
        }
    }
    
    func incrementAndSendQuartile() {
        lastQuartile += 1
        fireQuartile(Int32(lastQuartile))
    }
}
