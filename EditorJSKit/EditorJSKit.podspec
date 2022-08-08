#
# Be sure to run `pod lib lint EditorJSKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  
  s.name             = 'EditorJSKit'
  s.version          = '0.3.0'
  s.summary          = 'iOS Framework for generated clean data from Editor.js.'
  
  s.description      = 'SDK for editor.js. Parse and render natively supported blocks. Put blocks into your UICollectionView or implement your own custom adapter. Design and use custom blocks.'
  s.homepage         = 'https://github.com/Upstarts/editor.js-kit-ios'
  s.screenshots      = 'https://static.upstarts.work/ejkit/editorjs.kit-ios-scr.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Upstarts' => 'dev@upstarts.work' }
  s.source           = { :git => 'https://github.com/Upstarts/editor.js-kit-ios.git', :tag => s.version.to_s }
  s.swift_version    = '5.1'
  s.ios.deployment_target = '10.0'
  s.source_files     = 'EditorJSKit/Classes/**/*'
  
end
