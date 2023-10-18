# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'


target 'Uplift' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'AlamofireImage'
  pod 'Apollo'#, :git => 'https://github.com/apollographql/apollo-ios.git', :commit => 'b28c3dc'
  pod 'AppDevAnnouncements', :git => 'https://github.com/cuappdev/appdev-announcements.git'
  pod 'AppDevHistogram', :git => 'https://github.com/cuappdev/appdev-histogram.git'
  pod 'Bartinter'
  pod 'Crashlytics' 	# TODO: - remove
  pod 'Fabric' 		# TODO: - remove
  pod 'Firebase/Analytics'
  pod 'GoogleSignIn'
  pod 'Kingfisher'
  pod 'Presentation', :git=> 'https://github.com/cuappdev/Presentation.git', :commit => 'b53eb453d2e1520e724cfac5e3e444e730ffe985'
  pod 'SideMenu', '~> 6.0'
  pod 'SkeletonView'
  pod 'SnapKit'
  pod 'SwiftLint'
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11'
      xcconfig_path = config.base_configuration_reference.real_path
      xcconfig = File.read(xcconfig_path)
      xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
      config.build_settings['ARCHS[sdk=iphonesimulator*]'] = 'x86_64'
      File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
    end
  end
end