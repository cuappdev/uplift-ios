# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Uplift' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'AlamofireImage'
  pod 'Apollo', :git => 'https://github.com/apollographql/apollo-ios.git', :commit => 'b28c3dc'
  pod 'AppDevHistogram', :git => 'https://github.com/cuappdev/appdev-histogram.git'
  pod 'Bartinter'
  pod 'Crashlytics'
  pod 'FLEX', '~> 2.0', :configurations => ['Debug']
  pod 'Fabric'
  pod 'Firebase/Analytics'
  pod 'GoogleSignIn'
  pod 'Kingfisher', '~> 4.0'
  pod 'Presentation', :git=> 'https://github.com/cuappdev/Presentation.git', :commit => 'd4aa2d3ad5901f6ebce0727af592824982f88d13'
  pod 'SkeletonView'
  pod 'SnapKit'
  pod 'SwiftLint'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if ['Alamofire', 'Bartinter', 'SnapKit'].include?(target.name)
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.2'
      end
    end
  end
end
