# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/brightcove/BrightcoveSpecs.git'

workspace 'YouboraSpotXPlayerAdapter.xcworkspace'

def common_pods
  pod 'YouboraLib'
  pod 'SpotX-SDK'
end


target 'YouboraSpotXPlayerAdapter' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for YouboraSpotXPlayerAdapter
  common_pods
end

target 'iOSSwift' do 
  project 'Samples/Swift/Swift.xcodeproj'
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for iOS

  platform :ios, '9.0'
  common_pods
  pod 'YouboraConfigUtils'
  pod 'YouboraAVPlayerAdapter'
end

target 'iOSObjc' do 
  project 'Samples/Objc/Objc.xcodeproj'
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for iOS

  platform :ios, '9.0'
  common_pods
  pod 'YouboraConfigUtils'
  pod 'YouboraAVPlayerAdapter'
end