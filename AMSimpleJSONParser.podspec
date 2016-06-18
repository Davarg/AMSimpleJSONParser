#
# Be sure to run `pod lib lint AMSimpleJSONParser.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AMSimpleJSONParser'
  s.version          = '0.0.1'
  s.summary          = 'Lightweight approach for parsing JSON'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Parsing of JSON is never was so simple like now. All you need for successful parsing are class of model and JSON data. Thats all, no more mapping or subclassing.
                       DESC

  s.homepage         = 'https://github.com/Davarg/AMSimpleJSONParser'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alex Makushkin' => 'maka-dava@yandex.ru' }
  s.source           = { :git => 'https://github.com/Davarg/AMSimpleJSONParser.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/Underbridgins'

  s.ios.deployment_target = '8.0'

  s.source_files = 'AMSimpleJSONParser/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AMSimpleJSONParser' => ['AMSimpleJSONParser/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
