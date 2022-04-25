#
# Be sure to run `pod lib lint Zoo.UI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Zoo.UI'
  s.version          = '1.0.0'
  s.summary          = 'UI plugin for Zoo'
  s.description      = <<-DESC
  UI plugin for Zoo.
                       DESC
  s.homepage         = 'https://github.com/lzackx/Zoo.UI'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lzackx' => 'lzackx@lzackx.com' }
  s.source           = { :git => 'https://github.com/lzackx/Zoo.UI.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.module_name = 'ZooUI'
  s.source_files = 'Zoo.UI/Classes/**/*'
  s.dependency 'Zoo'
end
