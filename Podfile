platform :ios, '9.0'

def pods
    # Core
    pod 'ObjectMapper'
    pod 'Reusable'
    pod 'Then'
    pod 'MJRefresh'
    pod 'OrderedSet'
    pod 'Validator'
    
    # Rx
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'NSObject+Rx'
    pod 'RxDataSources'
    pod 'RxAlamofire'
    
    #
    pod 'MBProgressHUD'
    pod 'SDWebImage'
    pod 'ActionSheetPicker-3.0'
end

def test_pods
    pod 'RxBlocking', '~> 4.1'
end

target 'CleanArchitecture' do
  use_frameworks!
  pods

  target 'CleanArchitectureTests' do
    inherit! :search_paths
    test_pods	
  end

end
