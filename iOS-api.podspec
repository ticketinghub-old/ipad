Pod::Spec.new do |s|

  s.name                  = 'iOS-api'
  
  s.version               = '0.0.51'
  s.summary               = 'A library for interacting with the TicketingHub Developer API from an iOS device.'
  s.homepage              = 'https: //github.com/ticketinghub/ios-api'
  s.author                = { 'Bartek Hugo' => 'bartekhugo@me.com' }
  
  s.source                = { :git => 'https://github.com/ticketinghub/ios-api', :tag => s.version }
  
  s.ios.deployment_target = '7.0'
  
  s.source_files          = 'iOS-api/**/*.{h,m}'
  s.resource_bundle       = {'iOS-api-Model' => 'iOS-api-Model/*.xcdatamodeld'}
  s.preserve_paths        = 'iOS-api-Model'
  
  s.requires_arc          = true

  s.dependency 'AFNetworking', '~> 2.2.0'
  s.dependency 'DCTCoreDataStack', '~> 1.1'

end
