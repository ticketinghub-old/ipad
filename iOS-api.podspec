Pod::Spec.new do |s|

  s.name         = "iOS-api"
  s.version      = "0.0.3"
  s.summary      = "A library for interacting with the TicketingHub Developer API from an iOS device."
  s.homepage     = "https://github.com/ticketinghub/ios-api"
  s.author             = { "Bartek Hugo" => "bartekhugo@me.com" }
  s.source       = { :git => "https://github.com/ticketinghub/ios-api", :tag => '0.0.3' }
  s.ios.deployment_target = '7.0'
  s.source_files = 'Classes', 'iOS-api/**/*.{h,m}'
  s.public_header_files = 'iOS-api/**/*.{h}'

  s.dependency 'AFNetworking', '~> 2.1.0'
  s.dependency 'DCTCoreDataStack', '~> 1.1'
  s.requires_arc = true

end
