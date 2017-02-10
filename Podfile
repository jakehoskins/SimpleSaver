# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'SimpleSaver' do
  # Uncomment this line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!

  # Pods for SimpleSaver
  pod 'OpinionzAlertView'
  pod 'YLProgressBar', '~> 3.10.0'
  pod 'Colours'
  pod "NZCircularImageView"
  pod "MBCircularProgressBar"
  pod 'Charts'
  pod 'JKSteppedProgressBar'
  pod 'iRate'
  pod 'SKSplashView'
  pod 'AvePurchaseButton', '~> 1.0'

  target 'SimpleSaverTests' do
    inherit! :search_paths
    # Pods for testing
  end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end

end
