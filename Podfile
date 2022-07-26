# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Social-Music' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Social-Music
  pod 'Parse'
  pod 'Parse/UI'
  pod 'ParseLiveQuery'

  target 'Social-MusicTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Social-MusicUITests' do
    # Pods for testing
  end
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end
  end

end
