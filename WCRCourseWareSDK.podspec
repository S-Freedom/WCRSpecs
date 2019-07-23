Pod::Spec.new do |s|
  s.name         = "WCRCourseWareSDK"
  s.version      = "1.3.10"
  s.summary      = "WCRCourseWareSDK"
  s.description  = <<-DESC
                  WCRCourseWareSDK 是专门为课件设计的基础架构，具有打开网页课件、音视频课件、图片课件和白板课件的能力。
                   DESC
  s.homepage     = "https://git.100tal.com/jituan_zhiboyun_yidongduan/WCRCourseWareSDK.git"
  s.license      = "MIT"
  s.author             = { "欧阳铨" => "ouyangquan1@100tal.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "git@git.100tal.com:jituan_zhiboyun_yidongduan/WCRCourseWareSDK.git", :tag => "#{s.version}" }
  s.requires_arc = true

  s.default_subspecs = ["CourseWare"]

  s.subspec "CourseWare" do |ss|
    ss.platform     = :ios, "8.0"
    ss.source_files  = ["WCRCourseWareSDK/*.{h,m}",
                        "WCRCourseWareSDK/AVCourseWare/*.{h,m}",
                        "WCRCourseWareSDK/ImageCourseWare/*.{h,m}",
                        "WCRCourseWareSDK/ViewCourseWare/*.{h,m}",
                        "WCRCourseWareSDK/WebCourseWare/*.{h,m}"]

    ss.public_header_files = ["WCRCourseWareSDK/WCRCourseWareSDK.h",
                              "WCRCourseWareSDK/WCRCourseWare.h",
                              "WCRCourseWareSDK/WCRCourseWareLogger.h",
                              "WCRCourseWareSDK/AVCourseWare/WCRAVCourseWare.h",
                              "WCRCourseWareSDK/ImageCourseWare/WCRImageCourseWare.h",
                              "WCRCourseWareSDK/ViewCourseWare/WCRViewCourseWare.h",
                              "WCRCourseWareSDK/WebCourseWare/WCRWebCourseWare.h"]

    ss.dependency "WCRBase/WCRReactiveObjC"
    ss.dependency "WCRBase/WCRNetWorking"
    ss.dependency "WCRBase/WCRYYModel"
    ss.dependency "WCRBase/Error"
    ss.dependency "WCRBase/Utils"
    ss.dependency "WCRBase/Log"
    ss.dependency "WCRPlayerSDK/AVPlayer"
  end


  s.subspec "AVCourseWare" do |ss|
    ss.platform     = :ios, "8.0"
    ss.source_files  = ["WCRCourseWareSDK/*.{h,m}",
                        "WCRCourseWareSDK/AVCourseWare/*.{h,m}"]

    ss.public_header_files = ["WCRCourseWareSDK/WCRCourseWareSDK.h",
                              "WCRCourseWareSDK/WCRCourseWare.h",
                              "WCRCourseWareSDK/WCRCourseWareLogger.h",
                              "WCRCourseWareSDK/AVCourseWare/WCRAVCourseWare.h"]

    ss.dependency "WCRBase/WCRReactiveObjC"
    ss.dependency "WCRBase/Error"
    ss.dependency "WCRBase/Utils"
    ss.dependency "WCRBase/Log"
    ss.dependency "WCRPlayerSDK/AVPlayer"
  end

  s.subspec "ImageCourseWare" do |ss|
    ss.platform     = :ios, "8.0"
    ss.source_files  = ["WCRCourseWareSDK/*.{h,m}",
                        "WCRCourseWareSDK/ImageCourseWare/*.{h,m}"]

    ss.public_header_files = ["WCRCourseWareSDK/WCRCourseWareSDK.h",
                              "WCRCourseWareSDK/WCRCourseWare.h",
                              "WCRCourseWareSDK/WCRCourseWareLogger.h",
                              "WCRCourseWareSDK/ImageCourseWare/WCRImageCourseWare.h"]

    ss.dependency "WCRBase/WCRNetWorking"
    ss.dependency "WCRBase/WCRReactiveObjC"
    ss.dependency "WCRBase/Error"
    ss.dependency "WCRBase/Utils"
    ss.dependency "WCRBase/Log"
  end

  s.subspec "WebCourseWare" do |ss|
    ss.platform     = :ios, "8.0"
    ss.source_files  = ["WCRCourseWareSDK/*.{h,m}",
                        "WebCourseWareSDK/*.{h,m}"]

    ss.public_header_files = ["WCRCourseWareSDK/WCRCourseWareSDK.h",
                              "WCRCourseWareSDK/WCRCourseWare.h",
                              "WCRCourseWareSDK/WCRCourseWareLogger.h",
                              "WebCourseWareSDK/WCRWebCourseWare.h"]

    ss.dependency "WCRBase/WCRReactiveObjC"
    ss.dependency "WCRBase/WCRYYModel"
    ss.dependency "WCRBase/Error"
    ss.dependency "WCRBase/Utils"
    ss.dependency "WCRBase/Log"
  end


  s.subspec "ViewCourseWare" do |ss|
    ss.platform     = :ios, "8.0"
    ss.source_files  = ["WCRCourseWareSDK/*.{h,m}",
                        "WCRCourseWareSDK/ViewCourseWare/*.{h,m}"]

    ss.public_header_files = ["WCRCourseWareSDK/CourseWare.h",
                              "WCRCourseWareSDK/WCRCourseWare.h",
                              "WCRCourseWareSDK/WCRCourseWareLogger.h",
                              "WCRCourseWareSDK/ViewCourseWare/WCRViewCourseWare.h"]
    ss.dependency "WCRBase/Error"
    ss.dependency "WCRBase/Log"
  end
end