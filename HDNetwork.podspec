#
# Be sure to run `pod lib lint HDNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HDNetwork'
  s.version          = '0.0.3'
  s.summary          = 'A short description of HDNetwork.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
HDNetwork对AFHTTPSessionManager进行二次封装，包括网络请求，文件上传，文件下载这三个方法。并且支持RESTful API GET，POST，HEAD，PUT，DELETE，PATCH的请求。同时使用YYCache做了强大的缓存策略，请进行了RAC的封装支持。
                       DESC

  s.homepage         = 'https://github.com/hongdong/HDNetwork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = 'MIT'
  s.author           = { 'Abnerh' => 'fjhongdong@126.com' }
  s.source           = { :git => 'https://github.com/hongdong/HDNetwork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'HDNetwork/HDNetwork/*.{h,m}'
  
  # s.resource_bundles = {
  #   'HJNetwork' => ['HJNetwork/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking'
  s.dependency 'ReactiveObjC'
  s.dependency 'YYCache'

  
end
