# Uncomment the next line to define a global platform for your project
platform :ios, '18.0'

target 'Shopizilla' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Shopizilla
  pod 'SDWebImage'
  
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'Firebase/Messaging'
  pod 'Firebase/DynamicLinks'
  
  pod 'FBSDKLoginKit'
  pod 'GoogleSignIn'
  
  pod 'Stripe'

end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '18.0'
        config.build_settings['DYLIB_COMPATIBILITY_VERSION'] = ''
        if config.name == 'Debug'
          config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-Onone']
          config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
        end
      end
    end
end


