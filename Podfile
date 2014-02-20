platform :ios, '7.0'

inhibit_all_warnings!

link_with 'TicketingHub', 'TicketingHubTests'


pod 'iOS-api', :podspec => '.'
pod 'TimesSquare', '~> 1.0.1'
pod 'Stripe', '~> 1.0.2'
pod 'TapkuLibrary', :git => 'https://github.com/Hubbub/tapkulibrary.git', :branch => 'ios7'


target :test, :exclusive => true do
    
   link_with 'TicketingHubTests'

   pod 'Expecta', '~> 0.2.3'
   pod 'Specta', '~> 0.2.1'
   pod 'OCMock', '~> 2.2.3'

end
