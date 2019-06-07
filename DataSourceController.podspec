Pod::Spec.new do |spec|
  spec.name         = 'DataSourceController'
  spec.version      = '0.2.1'
  spec.summary      = 'A controller to handle data sources'
  spec.description  = 'This framework provides a controller to manage table view and collection views datasources'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.authors      = { 'Pedro Daniel Prieto Martínez' => 'math.pedro.daniel.prieto@gmail.com' }
  spec.homepage     = 'https://github.com/peredaniel/DataSourceController'
  spec.source       = { :git => 'git@github.com:peredaniel/DataSourceController.git', :tag => spec.version }

  spec.ios.deployment_target  = '9.0'
  spec.swift_version = '5.0'

  spec.ios.source_files = 'DataSourceController/**/*.{h,m,swift}'
end
