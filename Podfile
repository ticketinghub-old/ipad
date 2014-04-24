platform :ios, '7.0'

inhibit_all_warnings!

pod 'iOS-api', :podspec => '.'
pod 'Stripe', '~> 1.0.2'
pod 'SevenSwitch', '~> 1.3.0'
pod 'TapkuLibrary', :git => 'https://github.com/bartekhugo/tapkulibrary.git', :branch => 'ios7'
pod 'PPSSignatureView', '~> 0.1.0'
pod 'UIImage+PDF', '~> 1.1.2'
pod 'UIAlertView-Blocks', '~> 1.0'
pod 'UIView+Shake', '~> 0.2'
pod 'UIViewController+BHTKeyboardAnimationBlocks', '~> 0.0.1'
pod 'RMPickerViewController', '~> 1.1.0'

target :test, :exclusive => true do
    
   link_with 'TicketingHubTests'

   pod 'Expecta', '~> 0.2.3'
   pod 'Specta', '~> 0.2.1'
   pod 'OCMock', '~> 2.2.3'

end


# Remove 64-bit build architecture and 'isa' errors from Pods targets
post_install do |installer|
    installer.project.targets.each do |target|
        target.build_configurations.each do |configuration|
            target.build_settings(configuration.name)['ARCHS'] = '$(ARCHS_STANDARD_32_BIT)'
            target.build_settings(configuration.name)['CLANG_WARN_DIRECT_OBJC_ISA_USAGE'] = 'NO'
        end
    end
end