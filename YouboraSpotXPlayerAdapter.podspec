Pod::Spec.new do |s|

    s.name         = "YouboraSpotXPlayerAdapter"
    s.version = '0.0.1'
  
    # Metadata
    s.summary      = "Adapter to use YouboraLib on SpotX"
  
    s.description  = "<<-DESC
                        YouboraAVPlayerAdapter is an adapter used 
                        for SpotX.
                       DESC"
  
    s.homepage     = "http://developer.nicepeopleatwork.com/"
  
    s.license      = { :type => "MIT", :file => "LICENSE.md" }
  
    s.author             = { "Nice People at Work" => "support@nicepeopleatwork.com" }
  
    # Platforms
    s.ios.deployment_target = "9.0"
  
    # Swift version
    s.swift_version = "4.0", "4.1", "4.2", "4.3", "5.0", "5.1"
  
    # Source Location
    s.source       = { :git => 'https://bitbucket.org/npaw/spotx-adapter-ios.git', :tag => s.version}
  
    # Source files
    s.source_files  = 'YouboraSpotXPlayerAdapter/**/*.{swift,h}'
    s.public_header_files = "YouboraSpotXPlayerAdapter/**/*.h"
  
    # Dependency
    s.dependency 'YouboraLib', '6.5.8'
    s.dependency 'SpotX-SDK', '4.5.0'
  end