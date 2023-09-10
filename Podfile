# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'eosLund' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for eosLund
  pod 'Firebase/Core'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
  pod 'Firebase/Messaging'
  pod 'RealmSwift'
  pod 'Firebase/Storage'
  pod 'SwiftSoup'
  pod 'Alamofire', '~> 5.0.0-rc.3'
  pod 'AlamofireImage', '~> 4.0.0-beta.6'
  pod 'SwiftyJSON'
  pod 'YoutubePlayer-in-WKWebView'

end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end