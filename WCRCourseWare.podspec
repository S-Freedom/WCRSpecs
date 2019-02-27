Pod::Spec.new do |s|
  s.name         = "WCRCourseWare"
  s.version      = "1.0.0"
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

  s.platform     = :ios, "8.0"
  s.source_files  = ["WCRCourseWare/WCRCourseWare/*.{h,m}"]

  s.public_header_files = ["WCRCourseWare/WCRCourseWare/CourseWare.h",
                           "WCRCourseWare/WCRCourseWare/WCRCourseWare.h",
                           "WCRCourseWare/WCRCourseWare/WCRAVCourseWare.h",
                           "WCRCourseWare/WCRCourseWare/WCRImageCourseWare.h",
                           "WCRCourseWare/WCRCourseWare/WCRViewCourseWare.h",
                           "WCRCourseWare/WCRCourseWare/WCRWebCourseWare.h"]

  s.dependency "ReactiveObjC"
  s.dependency "AFNetworking"
  s.dependency "YYModel"
  s.dependency "WCRBase/Error"
  s.dependency "WCRBase/Utils"
  s.dependency "WCRBase/Log"
  s.dependency "WCRPlayer"
end