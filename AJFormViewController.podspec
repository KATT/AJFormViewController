#
# Be sure to run `pod spec lint AJFormViewController.podspec' to ensure this is a
# valid spec.
#
# Remove all comments before submitting the spec. Optional attributes are commented.
#
# For details see: https://github.com/CocoaPods/CocoaPods/wiki/The-podspec-format
#
Pod::Spec.new do |s|
  s.name         = "AJFormViewController"
  s.version      = "0.1"
  s.summary      = ""

  s.homepage     = "http://github.com/KATT/AJFormViewController"


  s.license      = 'MIT'


  s.author       = { "Alexander Johansson" => "alexander@n1s.se" }
  s.source       = { :git => "https://github.com/KATT/AJFormViewController.git" }

  s.platform     = :ios

  s.ios.deployment_target = '4.0'

  s.source_files = 'Classes', '*.{h,m}'

end
