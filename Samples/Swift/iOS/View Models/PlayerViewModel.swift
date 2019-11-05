//
//  BasicPlayerViewModel.swift
//  iOSSwift
//
//  Created by nice on 04/11/2019.
//  Copyright © 2019 nice. All rights reserved.
//

import Foundation
import SpotX
import YouboraLib
import YouboraConfigUtils
import AVKit
import YouboraAVPlayerAdapter
import YouboraSpotXPlayerAdapter

class PlayerViewModel {
    public let selectedOption: MenuSegue
    private let plugin: YBPlugin
    
    var wrapper: YBAVPlayerAdapterSwiftWrapper?
    
    public var videoUrl: URL? { return URL(string: Constants.normalVideoUrl) }
    
    init(segueIdentifier: String?) {
        if let segueIdentifier = segueIdentifier,
            let segue = MenuSegue(rawValue: segueIdentifier) {
                self.selectedOption = segue
        } else {
            self.selectedOption = .unknown
        }
        
        let options = YouboraConfigManager.getOptions()
        
        options.offline = false
        options.waitForMetadata = false
        
        self.plugin = YBPlugin(options: options)
        
    }
    
    func getAdRequest() -> SpotXAdRequest {
        
            let request = SpotXAdRequest()
            
            request.setChannel(Constants.spotXTestChannel)
        
            return request
        }
    
    func setAdapter(player: AVPlayer?) {
        guard let nonOptionalPlayer = player else {
            return
        }
        
        self.plugin.fireInit()
        self.wrapper = YBAVPlayerAdapterSwiftWrapper(adapter: YBAVPlayerAdapter(player: nonOptionalPlayer), andPlugin: self.plugin)
    }
    
    func setAdsAdapter(player: SpotXInterstitialAdPlayer?, delegate: SpotXAdPlayerDelegate) {
        guard let player = player,
            let adapter = YBSpotXPlayerAdAdapterManager(player: player, delegate: delegate).getAdapter() as? YBPlayerAdapter<AnyObject> else {
            return
        }
        
        self.plugin.adsAdapter = adapter
    }
    
    func viewWillDisappear() {
        self.plugin.removeAdsAdapter()
        self.plugin.removeAdapter()
    }
}
