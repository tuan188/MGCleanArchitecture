platform :ios, '9.0'

def pods
    # Clean Architecture
    pod 'MGArchitecture', '0.2'
    pod 'MGAPIService', '0.3'
    pod 'MGLoadMore', '0.2.1'
    
    # Core
    pod 'ObjectMapper', '3.3'
    pod 'Reusable', '4.0.4'
    pod 'Then', '2.4'
    pod 'MJRefresh', '3.1'
    pod 'OrderedSet', '3.0'
    pod 'Validator', '3.0.2'
    
    # Rx
    pod 'NSObject+Rx', '4.3'
    pod 'RxDataSources', '3.0'
    
    #
    pod 'MBProgressHUD', '1.1'
    pod 'SDWebImage', '4.4'
    pod 'ActionSheetPicker-3.0', '2.3'
end

def test_pods
    pod 'RxBlocking', '4.3'
end

target 'CleanArchitecture' do
  use_frameworks!
  pods

  target 'CleanArchitectureTests' do
    inherit! :search_paths
    test_pods	
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if ['Validator', 'RxDataSources'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
            end
        end
    end
end
