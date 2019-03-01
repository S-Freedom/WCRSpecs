Pod::Spec.new do |s|
  s.name         = "WCRCourseWare"
  s.version      = "1.1.2"
  s.summary      = "WCRCourseWare SDK"
  s.description  = <<-DESC
                  WCRCourseWare SDK 是专门为课件设计的基础架构，具有打开网页课件、音视频课件、图片课件和白板课件的能力。
                   DESC
  s.homepage     = "http://10.2.250.21/wcr_client/WCRCourseWare"
  s.license      = "MIT"
  s.author             = { "欧阳铨" => "ouyangquan1@100tal.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "http://10.2.250.21/wcr_client/WCRCourseWare.git", :tag => "#{s.version}" }
  s.requires_arc = true

  s.default_subspecs = ["CourseWare"]

  s.subspec "CourseWare" do |ss|
    ss.platform     = :ios, "8.0"
    ss.source_files  = ["WCRCourseWare/WCRCourseWare/*.{h,m}",
                        "WCRCourseWare/WCRCourseWare/AVCourseWare/*.{h,m}",
                        "WCRCourseWare/WCRCourseWare/ImageCourseWare/*.{h,m}",
                        "WCRCourseWare/WCRCourseWare/ViewCourseWare/*.{h,m}",
                        "WCRCourseWare/WCRCourseWare/WebCourseWare/*.{h,m}"]

    ss.public_header_files = ["WCRCourseWare/WCRCourseWare/CourseWare.h",
                              "WCRCourseWare/WCRCourseWare/WCRCourseWare.h",
                              "WCRCourseWare/WCRCourseWare/AVCourseWare/WCRAVCourseWare.h",
                              "WCRCourseWare/WCRCourseWare/ImageCourseWare/WCRImageCourseWare.h",
                              "WCRCourseWare/WCRCourseWare/ViewCourseWare/WCRViewCourseWare.h",
                              "WCRCourseWare/WCRCourseWare/WebCourseWare/WCRWebCourseWare.h"]

    ss.dependency "ReactiveObjC"
    ss.dependency "AFNetworking"
    ss.dependency "YYModel"
    ss.dependency "WCRBase/Error"
    ss.dependency "WCRBase/Utils"
    ss.dependency "WCRBase/Log"
    ss.dependency "WCRPlayer"
  end


  s.subspec "AVCourseWare" do |ss|
    ss.platform     = :ios, "8.0"
    ss.source_files  = ["WCRCourseWare/WCRCourseWare/*.{h,m}",
                        "WCRCourseWare/WCRCourseWare/AVCourseWare/*.{h,m}"]

    ss.public_header_files = ["WCRCourseWare/WCRCourseWare/CourseWare.h",
                              "WCRCourseWare/WCRCourseWare/WCRCourseWare.h",
                              "WCRCourseWare/WCRCourseWare/AVCourseWare/WCRAVCourseWare.h"]

    ss.dependency "ReactiveObjC"
    ss.dependency "WCRBase/Error"
    ss.dependency "WCRBase/Utils"
    ss.dependency "WCRBase/Log"
    ss.dependency "WCRPlayer"
  end

  s.subspec "ImageCourseWare" do |ss|
    ss.platform     = :ios, "8.0"
    ss.source_files  = ["WCRCourseWare/WCRCourseWare/*.{h,m}",
                        "WCRCourseWare/WCRCourseWare/ImageCourseWare/*.{h,m}"]

    ss.public_header_files = ["WCRCourseWare/WCRCourseWare/CourseWare.h",
                              "WCRCourseWare/WCRCourseWare/WCRCourseWare.h",
                              "WCRCourseWare/WCRCourseWare/ImageCourseWare/WCRImageCourseWare.h"]

    ss.dependency "ReactiveObjC"
    ss.dependency "WCRBase/Error"
    ss.dependency "WCRBase/Utils"
    ss.dependency "WCRBase/Log"
    ss.dependency "AFNetworking"
  end

  s.subspec "WebCourseWare" do |ss|
    ss.platform     = :ios, "8.0"
    ss.source_files  = ["WCRCourseWare/WCRCourseWare/*.{h,m}",
                        "WCRCourseWare/WCRCourseWare/WebCourseWare/*.{h,m}"]

    ss.public_header_files = ["WCRCourseWare/WCRCourseWare/CourseWare.h",
                              "WCRCourseWare/WCRCourseWare/WCRCourseWare.h",
                              "WCRCourseWare/WCRCourseWare/WebCourseWare/WCRWebCourseWare.h"]

    ss.dependency "ReactiveObjC"
    ss.dependency "YYModel"
    ss.dependency "WCRBase/Error"
    ss.dependency "WCRBase/Utils"
    ss.dependency "WCRBase/Log"
  end


  s.subspec "ViewCourseWare" do |ss|
    ss.platform     = :ios, "8.0"
    ss.source_files  = ["WCRCourseWare/WCRCourseWare/*.{h,m}",
                        "WCRCourseWare/WCRCourseWare/ViewCourseWare/*.{h,m}"]

    ss.public_header_files = ["WCRCourseWare/WCRCourseWare/CourseWare.h",
                              "WCRCourseWare/WCRCourseWare/WCRCourseWare.h",
                              "WCRCourseWare/WCRCourseWare/ViewCourseWare/WCRViewCourseWare.h"]
    ss.dependency "WCRBase/Error"
    ss.dependency "WCRBase/Log"
  end
end