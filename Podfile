# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

source 'https://github.com/CocoaPods/Specs.git'
source 'https://git.100tal.com/jituan_kaifangpingtai_mofaxiao_zhiboyun-ios/WCRSpecs.git'

inhibit_all_warnings!

target 'WCRCourseWareDemo' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  # Pods for WCRCourseWareDemo
  pod 'Masonry'
  pod 'ReactiveObjC'
  #pod 'AliyunPlayer_iOS/AliyunPlayerSDK'
end

target 'WCRCourseWareSDK' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  # Pods for WCRCourseWareSDK
  pod 'WCRBase/WCRNetWorking'
  pod 'WCRBase/WCRReactiveObjC'
  pod 'WCRBase/WCRYYModel'
  pod 'WCRBase/Log'
  pod 'WCRBase/Error'
  pod 'WCRBase/Utils'
  pod 'WCRPlayerSDK/ALiPlayer'

  target 'WCRCourseWareSDKTests' do
    inherit! :search_paths
    # Pods for testing
    pod "Kiwi"
    #pod 'AliyunPlayer_iOS/AliyunPlayerSDK'
  end

end
