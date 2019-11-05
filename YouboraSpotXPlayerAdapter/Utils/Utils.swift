//
//  Utils.swift
//  YouboraSpotXPlayerAdapter
//
//  Created by nice on 04/11/2019.
//  Copyright © 2019 nice. All rights reserved.
//

import Foundation

class Utils {
    static public func getOSName() -> String {
        #if os(iOS)
        return Constants.iOSName
        #elseif os(tvOS)
        return Constants.tvOSName
        #endif
    }
    
    static public func getPlayerVersion(ads: Bool) -> String {
        if ads {
            return "\(Constants.playerName)-Ads"
        }

        return Constants.playerName
    }

    static public func getPlayerName(ads: Bool) -> String {
        return "\(getPlayerVersion(ads: ads))-\(getOSName())"
    }

    static public func getVersion(ads: Bool) -> String {
        guard let path = Bundle(for: self).url(forResource: "Info", withExtension: "plist"),
            let values = NSDictionary(contentsOf: path),
            let version = values["CFBundleShortVersionString"] as? String else {
                return "unknown-\(getPlayerName(ads: ads))"
        }

        return "\(version)-\(getPlayerName(ads: ads))"
    }
}
