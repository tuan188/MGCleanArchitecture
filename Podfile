platform :ios, '9.0'

def pods
    # Clean Architecture
    pod 'MGArchitecture', '~> 1.3.1'
    pod 'MGAPIService', '~> 2.2.1'
    pod 'MGLoadMore', '~> 1.3.1'
    
    # Rx
    pod 'NSObject+Rx', '~> 5.1'
    pod 'RxDataSources', '~> 4.0'
    
    # Core
    pod 'ObjectMapper', '~> 3.5'
    pod 'Reusable', '~> 4.1'
    pod 'Then', '~> 2.7'
    pod 'MJRefresh', '~> 3.4.3'
    pod 'Validator', '~> 3.2.1'
    pod 'ValidatedPropertyKit'
    
    # Others
    pod 'MagicalRecord', '2.3.0'
    pod 'MBProgressHUD', '~> 1.2'
    pod 'ActionSheetPicker-3.0', '2.3'
    pod 'SDWebImage', '~> 5.8.3'
end

def test_pods
    pod 'RxBlocking', '~> 5.1'
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
