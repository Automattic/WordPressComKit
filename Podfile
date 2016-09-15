use_frameworks!

target 'WordPressComKit' do
  pod 'Alamofire', '3.5.0'

  target 'WordPressComKitTests' do
    pod 'OHHTTPStubs'
    pod 'OHHTTPStubs/Swift'
  end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
  end
end

