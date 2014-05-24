platform :ios, '7.0'

inhibit_all_warnings!

pod 'iOS-api', :podspec => '.'

pod 'TapkuLibrary',     :git => 'https://github.com/bartekhugo/tapkulibrary.git',       :branch => 'ios7'
pod 'PPSSignatureView', :git => 'https://github.com/bartekhugo/PPSSignatureView.git',   :branch => 'svg'

pod 'AKPickerView',                                 '~> 0.0.2'
pod 'Block-KVO',                                    '~> 2.2.1'
pod 'PPiFlatSegmentedControl',                      '~> 1.3.8'
pod 'RMPickerViewController',                       '~> 1.1.0'
pod 'SevenSwitch',                                  '~> 1.3.0'
pod 'Stripe',                                       '~> 1.1.2'
pod 'TSCurrencyTextField',                          '~> 0.1.0'
pod 'UIAlertView-Blocks',                           '~> 1.0'
pod 'UIImage+PDF',                                  '~> 1.1.2'
pod 'UIView+Shake',                                 '~> 0.2'
pod 'UIView-Autolayout',                            '~> 0.2.0'
pod 'UIViewController+BHTKeyboardAnimationBlocks',  '~> 0.0.2'

target :test, :exclusive => true do
    
   link_with 'TicketingHubTests'

   pod 'Expecta', '~> 0.2.3'
   pod 'Specta', '~> 0.2.1'
   pod 'OCMock', '~> 2.2.3'

end

