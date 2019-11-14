//
//  YBSpotXPlayerAdAdapterManager.swift
//  YouboraSpotXPlayerAdapter
//
//  Created by nice on 31/10/2019.
//  Copyright © 2019 nice. All rights reserved.
//

import Foundation
import SpotX

// Wrapper to use support Objc and swift
@objcMembers public class YBSpotXPlayerAdAdapterManager: NSObject, SpotXAdPlayerDelegate {
    var playerAdapter: YBSpotXPlayerAdAdapterBase?

    public override init() {
        self.playerAdapter = YBSpotXPlayerAdAdapterBase()
    }

    public init(player: AnyObject) {
        self.playerAdapter = YBSpotXPlayerAdAdapterBase(player: player)
    }
    
    public init(player: AnyObject, delegate: SpotXAdPlayerDelegate?) {
        guard let delegate = delegate else {
            self.playerAdapter = YBSpotXPlayerAdAdapterBase(player: player)
            return
        }
        
        let playerAdapter = YBSpotXPlayerAdAdapterBase(player: player)
        playerAdapter.delegate = delegate
        
        self.playerAdapter = playerAdapter
    }
    
    public func getAdapter() -> AnyObject? {
        return self.playerAdapter
    }
}
