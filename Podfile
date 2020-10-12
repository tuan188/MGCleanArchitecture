platform :ios, '10.0'

def pods
    # Clean Architecture
    pod 'MGArchitecture', '~> 2.0.1'
    pod 'MGAPIService', '~> 3.0.0'
    pod 'MGLoadMore', '~> 3.0.0'
    pod 'Dto'
    
    # Rx
    pod 'RxViewController'
    
    # Core
    pod 'Reusable', '~> 4.1'
    pod 'Then', '~> 2.7'
    
    # Others
    pod 'MagicalRecord', '2.3.0'
    pod 'MBProgressHUD', '~> 1.2'
    pod 'SDWebImage', '~> 5.8.3'
end

def test_pods
    pod 'RxTest', '~> 5.1'
    pod 'Mockingjay', :git => 'https://github.com/anhnc55/Mockingjay.git', :branch => 'swift_5'
end

target 'CleanArchitecture' do
  use_frameworks!
  inhibit_all_warnings!
  pods

  target 'CleanArchitectureTests' do
    inherit! :search_paths
    test_pods	
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 10.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
      end
    end
  end
end
