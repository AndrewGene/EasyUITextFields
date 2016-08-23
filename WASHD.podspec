#
# Be sure to run `pod lib lint WASHD.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WASHD'
  s.version          = '0.1.4'
  s.summary          = 'What Apple Shoud Have Done'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
WASHD (What Apple Should Have Done) adds some very basic, oft-used enhancements to (mainly) UITextFields. Usign Interface Builder, you can add Validation, a max length, a format, and something we call 'jump order' (when hitting "Return", the next UITextField by jump order will become the firstResponder).  Lastly, you can jump to the next UITextField when formatting has been fulfilled or when a max length has been reached.  All of this will make your form making much better for your users, and easier on you.
                       DESC

  s.homepage         = 'https://github.com/AndrewGene/WASHD'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Andrew Goodwin' => 'andrewggoodwin@gmail.com' }
  s.source           = { :git => 'https://github.com/AndrewGene/WASHD.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/AndrewGene'

  s.ios.deployment_target = '8.0'

  s.source_files = 'WASHD/Classes/**/*'
  
  # s.resource_bundles = {
  #   'WASHD' => ['WASHD/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
