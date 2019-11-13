# YouboraSpotXPlayerAdapter

An adapter to track events and send them to the Youbora to build the analytics

# Installation

#### CocoaPods

Insert into your Podfile

```bash
  pod 'YouboraSpotXPlayerAdapter'
```

and then run

```bash
pod install
```

# How to use

### Swift

###### Import

```swift
import YouboraSpotXPlayerAdapter
```

###### Initialize Adapter and add to plugin

```swift
// Intialize
let adPlayer = SpotXInterstitialAdPlayer()

// Add to plugin
guard let adapter = YBSpotXPlayerAdAdapterManager(player: adPlayer, delegate: delegate).getAdapter() as? YBPlayerAdapter<AnyObject> else {
    return
}

self.plugin.adsAdapter = adapter
```

### Obj-c

###### Import

```objectivec
#import <YouboraSpotXPlayerAdapter/YouboraSpotXPlayerAdapter-Swift.h>
```

###### Initialize Adapter and add to plugin

```objectivec
YBSpotXPlayerAdAdapterManager *adapterManger = [[YBSpotXPlayerAdAdapterManager alloc] initWithPlayer:self.player];
YBOptions *options = [YouboraConfigManager getOptions];

self.plugin = [[YBPlugin alloc] initWithOptions:options andAdapter:[adapterManger getAdapter]];
```

For more information you can check the examples in the folder **./Samples/Swift** for swift and for obj-c **./Samples/Objc**
