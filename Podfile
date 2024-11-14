# Uncomment the next line to define a global platform for your project
# platform :ios, '10.0'

target 'Usnap' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
pod 'IQKeyboardManagerSwift'
#pod 'UITextView+Placeholder', '~> 1.2'
pod 'UITextView+Placeholder'
pod 'Alamofire', '~> 4.5'
pod 'Cosmos'
pod 'SVProgressHUD'
pod 'SwiftyJSON'
pod 'CreditCardValidator'
pod 'SDWebImage', '~> 4.0'
pod 'DKImagePickerController'
pod 'ACEDrawingView'
pod 'TUCAssetsHelper'
pod 'Fabric'
pod 'Crashlytics'
pod 'GSImageViewerController'
pod 'ImageScrollView'
pod 'GooglePlaces'
pod 'GooglePlacePicker'
pod 'GoogleMaps'
pod 'GooglePlacesSearchController'
pod 'ImagePicker'
pod 'CTAssetsPickerController',  '~> 3.3.0'
pod 'youtube-ios-player-helper', '~> 0.1.6'
pod 'BSImagePicker', '~> 2.8'
pod 'OpalImagePicker', '~>1.5.0'
pod 'FacebookSDK'
pod 'FBSDKLoginKit'
pod 'FacebookCore'
pod 'FacebookLogin'
pod 'FacebookShare'
pod 'GoogleSignIn'
pod 'Google/SignIn'
pod 'ADCountryPicker', '~> 2.1.0'
pod "DropDown"
 pod 'SideMenuSwift'




# pod 'LiquidFloatingActionButton'

  # Pods for Usnap

  target 'UsnapTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'UsnapUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
                  config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
               end
          end
   end
end
